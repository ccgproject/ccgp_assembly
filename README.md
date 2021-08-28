# ccgp_assembly

California Conservation Genomics Project (CCGP) repository for the genome assembly working group.

## Content

- Overview
- Pipeline
    - Versioning
-  

## Overview

This repository contains scripts used for the reference genome assembly efforts of the CCGP. 

This effort focuses on the usage of PacBio HiFi long reads and proximity ligation/chromatin capture (HiC or OmniC) data
for the generation of high quality and higly contiguos genome assemblies.


## Pipeline

### Workflows

#### Pre-assembly quality control and data validation

- PacBio HiFi  
    - PacBio Adapter filtering  
    - K-mer counting with meryl
    - Genome size, heterozygosity and repeat content estimation
    - Coverage validation
- HiC/OmniC
    - Library QC with Dovetail Genomics tools
 
### *de novo* assembly (contigging)

- Contig assembly with HiFiasm

### Purge haplotigs: haplotypic duplications and contig overlaps.

- Alignment of HiFi data with minimap2 and purging with purge_dups

### Scaffolding

- Alignments with [Arima Genomics Mapping Pipeline](https://github.com/ArimaGenomics/mapping_pipeline) 
- Scaffolding with SALSA

### Checking for misassemblies

- Generation of coverage tracks (HiFi and HiC/OmniC) with bedtools
- Generation of interactive contact maps
    -  HiGlass
    -  PretextSuite

### Gap closing 

- [YAGCloser](https://www.github.com/merlyescalona/yagcloser)

### Organalle assembly

- Mitogenome assembly pipeline or [MitoHiFi](https://github.com/marcelauliano/MitoHiFi)
- Chloroplast assembly pipeline

### Contamination screening

- Organelle filtering from nuclear assemblies
- Contamination screening with Blobtools 


### Metrics / stats

- Contiguity metrics (contig and scaffold N50)
- BUSCO scores
- per base quality 
- frameshift errors


## Versioning

- V1.0


