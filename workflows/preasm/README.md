# Pre-assembly quality control and data validation


## Overview 

- [PacBio HiFi](#hifi)  
    - [PacBio Adapter filtering using HiFiAdapterFilt](#pacbio-adapter-filtering)
    - [Coverage validation](#coverage-validation)
    - [K-mer counting with meryl](k--mer-counting-with-meryl)
    - [Genome size, heterozygosity and repeat content estimation with GenomeScope2.0]()
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

## K-mer counting with [meryl](https://github.com/marbl/meryl)

## Genome size, heterozygosity and repeat content estimation with [GenomeScope2.0](https://github.com/tbenavi1/genomescope2.0)


## OmniC
