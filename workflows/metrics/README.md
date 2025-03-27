# Metrics

## Content

- [Overview](#overview)
- [Contiguity](#contiguity)
- [per base quality / k-mer completeness]()
- [Functional completeness](#functional-completeness)
    - [BUSCO scores](#busco-scores)
    - [Framseshift errors](#framsewhift-errors)
- [Gap description](#gap-description)
- [Genome mappability](#genome-mappability)
- [Mapping quality](#mapping-quality)

## Overview

The minimum target quality for our reference genomes is 6.7.Q40, and in most cases we expect to reach 7.C.Q50 or better (Table 1 from Rhie et al. 2021):

![Table 1 in Rhie et al. 2021](https://github.com/ccgproject/ccgp_assembly/assets/3216007/cbed8981-c283-486d-ba67-ad98b306a728)

## Contiguity

### Assumptions

- There is a directory hierarchy from `WD`.
  - `WD/`:
    - `asm/`: assemblies
    - `info/`: assemblies

- The estimation of the genome size and other genomic features has been obtained (See [here](https://github.com/ccgproject/ccgp_assembly/tree/main/workflows/preasm#genome-size-heterozygosity-and-repeat-content-estimation), to learn how to run it).
  - Output of this estimation (GenomeScope2.0 run) is under `$WD/info/genomescope` and the `stdout` output of GenomeScope2.0 is stored in a file `$WD/info/genomescope.log`
  - This would be required to get NG50 metrics. If the folder (or file) does not exist, then the NG50 metrics will **NOT** be generated.

### Requirements

#### Input

- Genome assembly (`FASTA`)
- Estimated genome size

#### Software

- Conda enviroment for `quast` (download [here](https://github.com/ccgproject/ccgp_assembly/blob/main/workflows/conda_env/conda.env.quast.yml))
- `split_fa` (from [`purge_dups`](https://github.com/dfguan/purge_dups)), but this could be modified to any software that splits an assembly file (`FASTA` file), at the gaps (generates a contig-level assembly).

#### Code

```
# Makes sure that there is folder/directory to write the output
if [[ ! -d $WD/info/quast ]]; then
	mkdir $WD/info/quast
fi

# Checking existence of `genomescope` output
if [[ -f $WD/info/genomescope.log ]]; then
	ESTGENOMESIZE=$(cat $WD/info/genomescope.log  | tail -1 | cut -d ":" -f 6)
else
	ESTGENOMESIZE=0
fi

if [[ "$ESTGENOMESIZE" == "Inf" ]]; then
	ESTGENOMESIZE=0
fi

# runs QUAST - general contiguity metrics
eval "$(conda shell.bash hook)"
conda activate quast

# generate contig-level assemblies
split_fa $WD/asm/assembly.fasta > $WD/asm/assembly.contigs.fasta

quast $WD/asm/assembly.contigs.fasta \
  --est-ref-size $ESTGENOMESIZE \
  -o $WD/info/quast/quast_assembly.contigs &
quast $WD/asm/assembly.fasta \
  --est-ref-size $ESTGENOMESIZE \
  -o $WD/info/quast/quast_assembly &
conda deactivate
```

#### Parsing QUAST output

- Assuming QUAST runs have been done on both assemblies, [here's a script](https://github.com/ccgproject/ccgp_assembly/edit/main/workflows/scripts/parseQuast.shortmetrics.sh) that would be able to generate a summarize table (in TSV format) with the information of both assemblies.

- You will be able to run the script:

```
bash parseQuast.shortmetrics.sh shortReferenceName version workingDirectory
```

For example: 
- If I wanted to run the script on the assembly of the **Puma concolor** (`mPumCon1`) initial version (`version=0`) and the hierachy of the project follows what has been explain throughout the repository:

  ```
  > bash parseQuast.shortmetrics.sh mPumCon1 0 /my/project/working/directory
  ```
- Output after running the script should be something like this:

```
Assembly            	mPumCon1.0.p_ctg    	mPumCon1.0.a_ctg
# contigs           	384                 	300
Largest contig      	110887988           	141280224
Total length        	2373411960          	2496348609
Estimated reference length	2363378643          	2363378643
GC (%)              	41.89               	41.91
N50                 	50506965            	65702467
NG50                	50506965            	65828543
L50                 	16                  	15
LG50                	16                  	14
# scaffolds         	384                 	300
Largest scaffold    	110887988           	141280224
Total length        	2373411960          	2496348609
Estimated reference length	2363378643          	2363378643
GC (%)              	41.89               	41.91
N50                 	50506965            	65702467
NG50                	50506965            	65828543
L50                 	16                  	15
LG50                	16                  	14
# N's per 100 kbp   	0.00                	0.00
```

## per base quality / k-mer completeness 

To generate these metrics, we generate a k-mer database from the data (HiFi reads) using meryl. 
We then use the database, and the assemblies to run merqury. With this program we obtained the 
per-base quality values (or consensus quality value; QV) for the assemblies and the k-mer completeness.

As described in Rhie et al, 2020:

a) the per-base quality or consensus quality value represents:

> a log-scaled probability of error for the consensus base calls. 

b) k-mer completeness, 

> The k-mer completeness is calculated as the fraction of reliable k-mers in the read set that are also found in the assembly.

🖥️ [how-to](https://github.com/ccgproject/ccgp_assembly/blob/main/workflows/metrics/kmers.md)

## Functional completeness

### BUSCO scores

#### Assumptions
There is a directory hierarchy from WD.

- There is a directory hierarchy from `WD`.
  - `WD/`:
    - `asm/`: assemblies
    - `info/`: assemblies

#### Requirements

##### Input
- Genome assembly (`FASTA`)
- `WD`: Working directory
- `BUSCODBPATH`: Path where we can access the databases if there have been downloaded before, or path to store the database if it is the first time using such database.
- `THREADS`: Number of processors/threads that will be used to run `BUSCO`
- `BUSCODB`: name of the database

### Software

- Conda environment for `BUSCO` (download [here](https://github.com/ccgproject/ccgp_assembly/blob/main/workflows/conda_env/conda.env.busco5.yml))

#### Code


```
conda activate busco5

busco -f --download_path $BUSCODBPATH --datasets_version odb10 -c $THREADS -m geno -l $BUSCODB \
        -i $WD/asm/assembly.fasta \
        -o busco_assembly &> busco.log &
conda deactivate
```

### Frameshift errors

## Gap description 

## Genome mappability

## Mapping quality


## References

- [Rhie A , Walenz BP, Koren S, Phillippy AM. (2020) Merqury: reference-free quality, completeness, and phasing assessment for genome assemblies. Genome Biol. 21:245.](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-020-02134-9)
- [Rhie   A , McCarthy SA, Fedrigo O, Damas J, Formenti G, Koren S, Uliano-Silva M, Chow W, Fungtammasan A, Kim J, et al.   (2021). Towards complete and error-free genome assemblies of all vertebrate species.Nature. 592:737–746.](https://www.nature.com/articles/s41586-021-03451-0)
