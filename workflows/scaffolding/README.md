# Scaffolding

 We aligned the Omni-C data to both assemblies following the [Arima Genomics Mapping Pipeline] (https://github.com/ArimaGenomics/mapping_pipeline) and then scaffold both assemblies with SALSA.

## Assumptions 

- You have been able to run the Arima Genomics Mapping Pipeline on each of the assemblies and you have generated the final deduplicated  and sorted `BAM` file (sufix of this file is `*.d.s.bam`)
- There is a directory hierarchy starting at `WD`. Where:
  - `WD`
      - `asm`: Assemblies
      - `aln`: Alignments

## Requirements

### Input

- `BAM` file (sufix of this file is `*.d.s.bam`)
- Genome assembly file (`FASTA`)

### Software

- [`SALSA`](https://github.com/marbl/SALSA)
- samtools
- [`bamToBed` (from `bedtools`)](https://bedtools.readthedocs.io/en/latest/content/tools/bamtobed.html)
- Conda environment for SALSA dependencies [here](https://github.com/ccgproject/ccgp_assembly/blob/main/workflows/conda_env/conda.env.salsa.yml)

## Code
 
```
REF=assembly.fasta
conda activate salsa
mkdir $WD/scaffolding

# Prepping alignments for SALSA
REF="$WD/asm/assembly.fasta"
bamToBed -i ${WD}/aln/assembly.omnic.d.s.bam \
    > ${WD}/scaffolding/assembly.omnic.bed &&
sort -k 4 ${WD}/scaffolding/assembly.omnic.bed \
    > ${WD}/scaffolding/assembly.omnic_tmp.bed &&
mv ${WD}/scaffolding/assembly.omnic_tmp.bed ${WD}/scaffolding/assembly.omnic.bed &&
samtools faidx $REF &&
python /usr/local/src/SALSA/run_pipeline.py -a $REF \
    -l $REF.fai \
    -b $WD/scaffolding/${REFNAME}.${VERSION}.${ASM}.${DATA}.bed -e DNASE \
    -o $WD/scaffolding/salsa_${REFNAME}_${VERSION}_${ASM} \
    -i 20 -p yes \
    &> $WD/scaffolding/salsa_assembly.log &&
cp $WD/scaffolding/salsa_assembly/scaffolds_FINAL.fasta \
    $WD/asm/new.assembly.fasta &
conda activate salsa
 ```
 
 
# Cite

- For `SALSA`:
  - [Ghurye   J, Pop   M, Koren   S, Bickhart   D, Chin   C-S.  Scaffolding of long read assemblies using long range contact information. BMC Genomics. 2017;18(1):527.](https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-017-3879-z)
  - [Ghurye   J, Rhie   A, Walenz   BP, Schmitt   A, Selvaraj   S, Pop   M, Koren   S.  Integrating Hi-C links with assembly graphs for chromosome-scale assembly. PLoS Comput Biol. 2019;15(8):e1007273.](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1007273)
- For `samtools`:
  - [Danecek P, Bonfield JK, Liddle J, Marshall J, Ohan V, Pollard MO, Whitwham A, Keane T, McCarthy SA, Davies RM, Li H, (2021) Twelve years of SAMtools and BCFtools, GigaScience, 10(2) giab008 [33590861]](https://academic.oup.com/gigascience/article/10/2/giab008/6137722?login=true)
- For `bedtools`:
  - [Quinlan AR , Hall IM (2010) BEDTools: a flexible suite of utilities for comparing genomic features, Bioinformatics, Volume 26, Issue 6, Pages 841–842, https://doi.org/10.1093/bioinformatics/btq033](https://academic.oup.com/bioinformatics/article/26/6/841/244688)  
