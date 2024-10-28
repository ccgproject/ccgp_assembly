![California Conservation Genomics Project (CCGP)](https://github.com/ccgproject/ccgp_assembly/assets/3216007/84a23791-0b87-44fc-8ae4-3e57c51796cb)


California Conservation Genomics Project (CCGP) repository for the genome assembly working group.

## Content

- [Overview](https://github.com/ccgproject/ccgp_assembly/edit/main/README.md#overview)
- [Pipeline overview](https://github.com/ccgproject/ccgp_assembly/edit/main/README.md#pipeline-overview)
- [Workflows](https://github.com/ccgproject/ccgp_assembly/edit/main/README.md#workflow)
- [Versioning](versions/README.md)
- [Learn more](https://github.com/ccgproject/ccgp_assembly/edit/main/README.md#learn-more)

## Overview

This repository contains scripts used for the CCGP's reference genome assembly efforts. 

CCGP reference genomes are assembled following a protocol adapted from [Rhie et al. (2021)](https://www.nature.com/articles/s41586-021-03451-0). Assemblies comprise PacBio HiFi long read data, which is scaffolded using proximity ligation/chromatin conformation capture (HiC or OmniC) (Dovetail Genomics). Our minimum target reference genome quality is 6.7.Q40, and in most cases, we expect to reach 7.C.Q50 or better (see Table 1 in [Rhie et al. (2021)](https://www.nature.com/articles/s41586-021-03451-0)). 

Here is the overview of our current pipeline:

![CCGP: Overview of our current pipeline](https://github.com/ccgproject/ccgp_assembly/assets/3216007/6f652479-a407-47b0-87bb-d51ef6e06fd3)

## Pipeline Overview

There have been multiple versions since the beginning of the project and this is an overview of how the pipeline has evolved.

![CCGP: Evolution of the assembly pipeline](https://github.com/ccgproject/ccgp_assembly/assets/3216007/659836c5-7eaf-40cf-b90c-eebbd2f47a1d)

Color blocks:
- Yellow: sequencing datatypes
- Dark gray: Fixed processes
- Light gray: Optional processes
- Blue: Iterative step

## Workflows

### [Pre-assembly quality control and data validation](https://github.com/ccgproject/ccgp_assembly/blob/main/workflows/preasm/README.md)

- PacBio HiFi  
    - PacBio Adapter filtering  
    - K-mer counting with meryl
    - Genome size, heterozygosity, and repeat content estimation
    - Coverage validation (calculation of expected coverage given the sequencing data
- HiC/OmniC
    - Library QC with Dovetail Genomics tools
 
### [*de novo* assembly (contigging)](https://github.com/ccgproject/ccgp_assembly/tree/main/workflows/contig)

- Contig assembly with HiFiasm
    - We are using single or HiC mode on HiFiasm depending on the datasets available or ploidy. 

### Purge haplotigs: haplotypic duplications and contig overlaps

- Alignment of HiFi data with minimap2 and purging with purge_dups

### [Scaffolding](https://github.com/ccgproject/ccgp_assembly/blob/main/workflows/scaffolding/README.md)

- Alignments with Arima Genomics Mapping Pipeline
- Scaffolding with SALSA

### [Checking for misassemblies](https://github.com/ccgproject/ccgp_assembly/tree/main/workflows/misassemblies)

- Generation and visualization of contact maps
    -  HiGlass
    - Generation of tracks
        - HiFi coverage
        - HiC/OmniC coverage
        - Genome assembly mappability
        - Gap description
    -  PretextSuite


### Gap closing 

- Using YAGCloser - based on gap-spanning of long reads

### Mitochondrial assembly

- Mitogenome assembly pipeline or [MitoHiFi](https://github.com/marcelauliano/MitoHiFi)

### Contamination screening

- Organelle filtering from nuclear assemblies
- Contamination screening with Blobtools 

### [Metrics/stats/Others](https://github.com/ccgproject/ccgp_assembly/blob/main/workflows/metrics/README.md)

- Contiguity metrics (contig and scaffold N50)
- BUSCO scores
- per base quality / k-mer completeness 
- Frameshift errors
- Gap description
- Genome mappability
- Mapping quality

## Versioning

- [V1.0](versions/V1.0.md)
- [V2.0](versions/V2.0.md)
- [V3.0](versions/V3.0.md)
- [V4.0](versions/V4.0.md)
- [V5.0](versions/V5.0.md)

## Learn more

- For further information about our project and efforts, please redirect to the CCGP [website](https://www.ccgproject.org/)
- For more information about the project, you can also check this:

[Shaffer HB, Toffelmier E, Corbett-Detig RB, Escalona M, Erickson B, Fiedler P, Gold M, Harrigan RJ, Hodges S, Luckau TK, Miller C, Oliveira DR, Shaffer KE, Shapiro B, Sork VL, Wang IJ (2022) ***Landscape genomics to enable conservation actions: the California Conservation Genomics Project.*** Journal of Heredity, 113 (6): 577–588, https://doi.org/10.1093/jhered/esac020](https://academic.oup.com/jhered/article/113/6/577/6565646)


## References

- [Rhie   A , McCarthy SA, Fedrigo O, Damas J, Formenti G, Koren S, Uliano-Silva M, Chow W, Fungtammasan A, Kim J, et al.   (2021). Towards complete and error-free genome assemblies of all vertebrate species.Nature. 592:737–746.](https://www.nature.com/articles/s41586-021-03451-0)



