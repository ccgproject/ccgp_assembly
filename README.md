# ccgp_assembly

California Conservation Genomics Project (CCGP) repository for the genome assembly working group.

## Content

- Overview
- Pipeline

## Overview

This repository contains scripts used for the reference genome assembly efforts of the CCGP. 

This effort focuses on the usage of PacBio HiFi long reads and proximity ligation/chromatin capture (HiC or OmniC) data
for the generation of high quality and higly contiguos genome assemblies.


## Pipeline

1. Pre-assembly quality control and data validation
    - PacBio HiFi  
        - K-mer counting with meryl
        - Genome size, heterozygosity and repeat content estimation with GenomeScope2.0
        - Coverage validation
    - HiC/OmniC
        - Library QC with [Dovetail Genomics tools](https://github.com/dovetail-genomics/dovetail_tools)
2. *de novo* assembly (contigging)
    - Contig assembly with HiFiasm
3. Purge haplotigs: haplotypic duplications and contig overlaps.
    - alignment of HiFi data with minimap2 and purging with purge_dups
4. Scaffolding
    - Alignments with [Arima Genomics Mapping Pipeline](https://github.com/ArimaGenomics/mapping_pipeline) 
    - Scaffolding with [SALSA](https://www.github.com/marbl/SALSA)
5. Checking for misassemblies
    - Generation of coverage tracks (HiFi and HiC/OmniC) with bedtools
    - Generation of interactive contact maps
        -  HiGlass
        -  PretextSuite
6. Gap closing with [YAGCloser](https://www.github.com/merlyescalona/yagcloser)
7. Organalle assembly
    - Mitogenome assembly pipeline or [MitoHiFi](https://github.com/marcelauliano/MitoHiFi)
    - Chloroplast assembly pipeline
8. Organelle filtering from nuclear assemblies
9. Contamination screening with Blobtools 
