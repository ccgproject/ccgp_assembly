# Pre-assembly quality control and data validation


## Overview 

- [PacBio HiFi](#hifi)  
    - [PacBio Adapter filtering using HiFiAdapterFilt](#pacbio-adapter-filtering)
    - [Coverage validation](#coverage-validation)
    - [K-mer counting](k--mer-counting)
    - [Genome size, heterozygosity and repeat content estimation]#genome-size-heterozygosity-and-repeat-content-estimation)
- [HiC/OmniC](#omnic)
    - Library QC with Dovetail Genomics tools

## HiFi

### PacBio Adater filtering 

The first thing we need to do once we receive the PacBio HiFi data is to filter remnants of PacBio adapters. This process we have adapted from [HiFiAdapterFilt](https://github.com/sheinasim/HiFiAdapterFilt). We start from the `*.hifi_reads.fasta.gz` file that has been generated directly on the machine (Sequel II or Sequel IIe).

#### Requirements

- [HiFiAdapterFilt](https://github.com/sheinasim/HiFiAdapterFilt)
- BLAST (V2.6)
- samtools
- bgzip 
- Conda environment: 
    - We have set up a conda environment that is able to load all the dependencies for BLAST (V2.6)
    - Download from [here](https://github.com/ccgproject/ccgp_assembly/blob/main/workflows/conda_env/conda.env.ncbi216.yml)

#### Description

1. `HiFiAdapterFilt` uses `BLAST` to find matches of the PacBio adapters in our FASTA file. The PacBio adapters are organized in a database (DB) that comes with the repository. This DB was generated with `BLAST v2.6`.
    - The output is a file on BLAST format 6 (`-outfmt6`) (`*.contaminant.blastout`)
2. The BLAST output is then filtered based on percentage identity and target/alignment size.
    - This generates a file with a list of readnames (`*.blocklist`)
3. Readnames from step 2 are then filtered out from the original FASTA file.
4. We use `bgzip` to compress the new filtered file
5. We generate an index of the FASTA file using `samtools faidx`



#### Variables

- `THREADS`: Number of threads that you will used to run the `BLAST` command.
- `WD`: Working directory. This is a path.
- `SEQDIR`: Path to directory where the HiFi sequencing data has been downloaded to. We are using only the `FASTA` Files. 
- `DBpath="/usr/local/src/HiFiAdapterFilt/DB"`: Follow instructions from [HiFiAdapterFilt](https://github.com/sheinasim/HiFiAdapterFilt) to understand this path.


Here's the code we use to run our HiFi adapter filtering:


```
conda activate ncbi26
mkdir -p $WD/seq/hifi
# Filtering HiFiAdapters
for ccs in $(find ${SEQDIR} -type f | grep fasta.gz| grep -v cromwell); do
    ccsbase=$(basename $ccs .gz)
    currentccs="${WD}/seq/hifi/${ccsbase}" 
    if  [[ ! -f ${currentccs%.fasta}.filt.fasta.gz || "$FORCED" == "Y" ]]; then
        gunzip -c $ccs > ${currentccs} && 
        blastn -db $DBpath/pacbio_vectors_db -query ${currentccs} \
            -num_threads ${THREADS} \
            -task blastn -reward 1 -penalty -5 -gapopen 3 -gapextend 3 -dust no \
            -soft_masking true -evalue .01 -searchsp 1750000000000 \
            -outfmt 6 > ${currentccs%.fasta}.contaminant.blastout &&
        cat ${currentccs%.fasta}.contaminant.blastout \
            | grep 'NGB0097' \
            | awk -v OFS='\t' '{if (($2 ~ /NGB00972/ && $3 >= 97 && $4 >= 44) || ($2 ~ /NGB00973/ && $3 >= 97 && $4 >= 34)) print $1}' \
            | sort -u > ${currentccs%.fasta}.blocklist &&
        cat ${currentccs} | paste - - - - | \
            grep -v -f ${currentccs%.fasta}.blocklist -F | \
            tr "\t" "\n" | seqtk seq - > ${currentccs%.fasta}.filt.fasta &&
        bgzip -@ ${THREADS} ${currentccs%.fasta}.filt.fasta -f &&
        samtools faidx ${currentccs%.fasta}.filt.fasta.gz &&
        rm $currentccs &
    fi
done
conda deactivate
```


## Coverage validation

After filtering we calculate the expected coverage of our sample based on the length of the adapter-trimmed HiFi reads and the estimated genome size we have of a particular species.
These steps will generate files for each sequencing file and an aggregate coverage.

### Requirements

- R

### Variables

- `WD`: Working directory
- `ESTGENOMESIZE`: Estimated genome size for the species at hand

### Code

```
mkdir -p $WD/info

# Getting coverage per SMRT cell after adapter-trimming
for ccs in $(find ${WD}/seq/hifi/ -type f | grep filt.fasta.gz$); do
    ccsbase=$(basename $ccs .filt.fasta.gz)
    cat ${ccs}.fai | cut -f 2 | R -s -e 'data=scan(file("stdin")); sum(data)/'$ESTGENOMESIZE'' | cut -d " " -f 2 > ${WD}/info/${ccsbase}.coverage
done

# Getting coverage for all the HiFi data
cat $WD/seq/hifi/*.filt.fasta.gz.fai \
    | cut -f 2 | R -s -e 'data=scan(file("stdin")); sum(data)/'$ESTGENOMESIZE'' \
    | cut -d " " -f 2 > ${WD}/info/total.coverage
    
# Generating a summary file of the HiFi read lengths (NG50, min, 1Q, median, mean, 3Q, max)

cat $WD/seq/hifi/*.filt.fasta.gz.fai | cut -f 2 \
    | R -s -e 'data=scan(file("stdin"));data_ordered=data[order(data,decreasing=T)];total=sum(data_ordered);n50=total/2;cummulative=cumsum(data_ordered);l50=which(cummulative>n50)[1]; c(l50,data_ordered[l50]); summary(data)' \
    | cut -d " " -f 2- > $WD/info/hifi.len.summary

```


## K-mer counting

K-mer database required for estimation of genomic features

### Requirements
-  [meryl](https://github.com/marbl/meryl)

### Assumptions

- We assume to run this code that the HiFi data has gone through the adapter filtering step.
- The directory hierarchy exists, and the HiFi data is under `$WD/seq/hifi`

### Variables

- `WD`: Working directory
- `K`: K-mer size to generate the `meryl` database.
- `REFNAME`: name of the assmebly. We generate the 


### Code

```
mkdir -p $WD/info/meryl
cd $WD/info/meryl
for ccs in $(find ${WD}/seq/hifi/ -type f | grep filt.fasta.gz$ ); do
    ccsbase=$(basename $ccs .filt.fasta.gz)
    if [[ ! -d "${ccsbase}.meryl" ]]; then
        meryl k=$K count output ${ccsbase}.meryl $ccs &> ${ccsbase}.meryl.log
    fi
done

if [[ -d "${REFNAME}.hifi.meryl" ]]; then
    rm -rf ${REFNAME}.hifi.meryl
fi

# Agreggated meryl database
meryl union-sum output ${REFNAME}.hifi.meryl *.meryl

# Generating histogram for Genomescope2.0
meryl histogram ${REFNAME}.hifi.meryl | awk '{print $1,$2}' > ${REFNAME}.hifi.hist

```

## Genome size, heterozygosity and repeat content estimation

We extract information of the HiFi reads to be able to validate the data we are generating. In addition, it allows us to generate and expectation of the genome assembly process
by gaining infomarion about repeat content, genome size and heterozygosity.


### Requirements
- [GenomeScope2.0](https://github.com/tbenavi1/genomescope2.0)

### Variables

- `WD`: Working directory
- `K`: K-mer size used to generate the `meryl` database.
- `REFNAME`: name of the assmebly. We generate the 

### Assumptions

- Given the scope and/or limitation of the projects, the code below is set up for diploid genomes, using the default parameters of Genomescope2.0. 
- For haploid species we set up option `-p` to `1`.
- We are assuming that the meryl database has been generated and exists under `$WD/info/meryl/${REFNAME}.hifi.hist`

### Code

```
/path/to/genomescope2.0/genomescope.R -i $WD/info/meryl/${REFNAME}.hifi.hist \
    -k $K \
    # [-p 1] # Optional
    -o genomescope &> genomescope.log 
```

## OmniC

We follow the instructions that have been set up and orgenized by [Dovetail Genomics](https://omni-c.readthedocs.io/en/latest/index.html).



