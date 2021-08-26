# ccgp_assembly

California Conservation Genomics Project (CCGP) repository for the genome assembly working group.

## Content

- Overview
- Pipeline
- Software 

## Overview

This repository contains scripts used for the reference genome assembly efforts of the CCGP. 

This effort focuses on the usage of PacBio HiFi long reads and proximity ligation (chromatin capture) data
for the generation of high quality and higly contiguos genome assemblies.


## Pipeline

- Pre-assembly quality control and data validation
    - K-mer counting with meryl
    - Genome size, heterozygosity and repeat content estimation with GenomeScope2.0
    - Coverage validation
- *de novo* assembly (contigging)
    - Contig assembly with HiFiasm
- Generation of scaffolding 
