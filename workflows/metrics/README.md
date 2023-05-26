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

[How-to](https://github.com/ccgproject/ccgp_assembly/new/main/workflows/metrics/contiguity.md)

## per base quality / k-mer completeness 

To generate these metrics, we generate a k-mer database from the data (HiFi reads) using meryl. 
We then use the database, and the assemblies to run merqury. With this program we obtained the 
per-base quality values (or consensus quality value; QV) for the assemblies and the k-mer completeness.

As described in Rhie et al, 2020:

a) the per-base quality or consensus quality value represents:

> a log-scaled probability of error for the consensus base calls. 

b) k-mer completeness, 

> The k-mer completeness is calculated as the fraction of reliable k-mers in the read set that are also found in the assembly.



## Functional completeness

### BUSCO scores

### Frameshift errors

## Gap description 

## Genome mappability

## Mapping quality


## References

- [Rhie A , Walenz BP, Koren S, Phillippy AM. (2020) Merqury: reference-free quality, completeness, and phasing assessment for genome assemblies. Genome Biol. 21:245.](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-020-02134-9)
- [Rhie   A , McCarthy SA, Fedrigo O, Damas J, Formenti G, Koren S, Uliano-Silva M, Chow W, Fungtammasan A, Kim J, et al.   (2021). Towards complete and error-free genome assemblies of all vertebrate species.Nature. 592:737–746.](https://www.nature.com/articles/s41586-021-03451-0)
