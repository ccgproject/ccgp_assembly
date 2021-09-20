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


#### Description

1. `HiFiAdapterFilt` uses `BLAST` to find matches of the PacBio adapters in our FASTA file. The PacBio adapters are organized in a database (DB) that comes with the repository. This DB was generated with `BLAST v2.6`.
    - The output is a file on BLAST format 6 (`-outfmt6`) (`*.contaminant.blastout`)
2. The BLAST output is then filtered based on percentage identity and target/alignment size.
    - This generates a file with a list of readnames (`*.blocklist`)
3. Readnames from step 2 are then filtered out from the original FASTA file.
4. We use `bgzip` to compress the new filtered file
5. We generate an index of the FASTA file using `samtools faidx`


## Coverage validation

## K-mer counting with [meryl](https://github.com/marbl/meryl)

## Genome size, heterozygosity and repeat content estimation with [GenomeScope2.0](https://github.com/tbenavi1/genomescope2.0)


## OmniC