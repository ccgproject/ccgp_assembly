# Current version (V1.0)

## Overview

![Overview diagram - CCGP Assembly Pipeline V1.0](https://github.com/ccgproject/ccgp_assembly/assets/3216007/f170e937-32df-4fe0-b2cf-7c46a58accfc)

## Workflows 

- [Pre-assembly quality control and validation]()
- [*de novo* assembly]()
- [Purge haplotigs]()
- [Scaffolding]()
- [Checking for misassemblies]()
- [Gap closing]()
- [Organelle assembly]()
- [Contamination screening and curation]()

## Software

Almost all of the links will send you to the corresponding repository. 
The rest of the links correspond to the main documentation web site of the tool.

### Assembly

| Purpose | Program | Version | 
|:-------|:---------|--------:|
| Filtering PacBio HiFi adapters |  [HiFiAdapterFilt](https://github.com/sheinasim/HiFiAdapterFilt) | Commit `64d1c7b` | 
| K-mer counting |  [meryl](https://github.com/marbl/meryl) | `1` | 
| Estimation of genome size and heterozygosity |  [GenomeScope](https://github.com/tbenavi1/genomescope2.0) | `2` |
| *de novo* assembly (contiging) |  [HiFiasm](https://github.com/chhylp123/hifiasm) |   `0.13-r30`8 |
| Long-read, genome-genome alignment |  [minimap2](https://github.com/lh3/minimap2) |  `2.16` | 
| Remove low-coverage, duplicated contigs | [purge_dups](https://github.com/dfguan/purge_dups) | `1.0.1` |
| HiC mapping for SALSA |  [Arima Genomics mapping pipeline](https://github.com/ArimaGenomics/mapping_pipeline) |  Commit `2e74ea4` | 
| HiC Scaffolding | [SALSA](https://github.com/marbl/SALSA) | `2` | 
| Gap closing |  [YAGCloser](https://github.com/merlyescalona/yagcloser) | Commit `20e2769` | 

### Hi-C Contact map generation

| Purpose | Program | Version | 
|:-------|:---------|--------:|
| Short-read alignment  | [bwa](https://github.com/lh3/bwa) | `0.7.17-r1188` |
| SAM/BAM processing |  [samtools](https://github.com/samtools/samtools) |  `1.11` | 
| SAM/BAM filtering | [pairtools](https://github.com/open2c/pairtools) | `0.3.0` | 
| Pairs indexing | [pairix](https://github.com/4dn-dcic/pairix) | `0.3.7` | 
| Matrix generation | [cooler](https://github.com/open2c/cooler) | `0.8.10` | 
| Matrix balancing | [hicExplorer](https://github.com/deeptools/HiCExplorer) | `3.6` | 
| Contact map visualization | [HiGlass](http://higlass.io/) | `2.1.11` | 
| Contact map generation | [PretextMap](https://github.com/wtsi-hpag/PretextMap) | `0.1.4` | 
| Contact map visualization | [PretextView](https://github.com/wtsi-hpag/PretextView) | `0.1.5` | 
| Contact map visualization | [PretextSnapshot](https://github.com/wtsi-hpag/PretextSnapshot) | `0.0.3` | 

### Organelle assembly

| Purpose | Program | Version | 
|:-------|:---------|--------:|
| Sequence similarity search | BLAST+ |  `2.10` | 
| Long read alignment | [pbmm2](https://github.com/PacificBiosciences/pbmm2) | `1.4.0` | 
| Variant calling and consensus |  [bcftools](https://github.com/samtools/bcftools) |  `1.11-5-g9c15769` | 
| Extraction of sequences | [seqtk](https://github.com/lh3/seqtk) | `1.3-r115-dirty` | 
| Sequence polishing | [raptor](https://github.com/isovic/raptor) | `0.20.3-171e0f1` | 
| Circular-aware long-read alignment | [racon](https://github.com/isovic/racon) | `1.4.19` | 
| Sequence alignment | [lastz](https://github.com/lastz/lastz) | `1.04.08` | 
| Gene annotation |  [MitoFinder](https://github.com/RemiAllio/MitoFinder) |  `1.4` | 


### Genome quality assessment

| Purpose | Program | Version | 
|:-------|:---------|--------:|
| Basic assembly metrics | [QUAST](https://github.com/ablab/quast) | `5.0.2` | 
| Assembly completeness | [BUSCO](https://busco.ezlab.org/) | `5.0.0` |
| k-mer based assembly evaluation | [Merqury](https://github.com/marbl/merqury) |  `1` | 
| Contamination screening | [BlobToolKit](https://github.com/blobtoolkit/blobtools2) | `2.3.3` |


# Species generated with this pipeline

- *Arctostaphylos glauca*
