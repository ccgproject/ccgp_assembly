# Contigging

We start with the *de novo* genome assembly of a particular species using HiFiasm. Given the major updates that have happened since the beginning of the procect, we have changed our approaches. 

## Approach 1: 

Initially, HiFiasm only used HiFi data to generate highly contiguous assemblies. The output corresponding to a diploid assembly consists of two pseudo haplotypes (primary and alternate). 
The primary assembly is more complete and consists of longer phased blocks. The alternate consists of haplotigs (contigs of the same haplotype) in heterozygous regions and is not as complete and more fragmented.
As explained [here](https://lh3.github.io/2021/04/17/concepts-in-phased-assemblies) and [here](https://wwwd.ncbi.nlm.nih.gov/grc/help/definitions/), given the characteristics of the alternate assembly, it cannot be considered on its own but as a complement of the primary assembly.

These approach affects pipeline [Version 1](https://github.com/ccgproject/ccgp_assembly/blob/main/versions/V1.0.md); [Version 2](https://github.com/ccgproject/ccgp_assembly/blob/main/versions/V2.0.md) and [Version 3](https://github.com/ccgproject/ccgp_assembly/blob/main/versions/V3.0.md).

### Requirements

#### Input

- HiFi Reads

#### Software

- [HiFiasm](https://github.com/chhylp123/hifiasm) (Version < 0.16)
- [gfatool](https://github.com/lh3/gfatools)
- [pigz](https://github.com/madler/pigz)

### Variables

- `WD`: Working directory
- `THREADS`: Number of threads that can be used
- `REFNAME`: genome assembly name
- `HIFIASM_FOLDERNAME`: folder where the output from the HiFiasm run will be stored within `WD`.
 
### Code

```
mkdir -p $WD/asm/$HIFIASM_FOLDERNAME
cd $WD/asm/$HIFIASM_FOLDERNAME
VERSION=0 # First version by default V0

hifiasm -t $THREADS -o ${REFNAME}.$VERSION --primary $WD/seq/hifi/*.filt.fasta.gz &> hifiasm.${REFNAME}.${VERSION}.log

for ASM in p_ctg a_ctg; do
    gfatools gfa2fa $WD/asm/$HFIASM_FOLDERNAME/${REFNAME}.${VERSION}.${ASM}.gfa \
        > $WD/asm/${REFNAME}.${VERSION}.${ASM}.fasta
done
HIFIASM_ASM_PATH="${WD}/asm/$HIFIASM_FOLDERNAME"
for f in  $(find ${HIFIASM_ASM_PATH}/*.gfa -type f); do
    echo "pigz -c -p20 $f > ${HIFIASM_ASM_PATH}/$(basename $f).gz  && rm $f &"
    pigz -c -p20 $f > ${HIFIASM_ASM_PATH}/$(basename $f).gz  && rm $f &
done
for f in  $(find ${HIFIASM_ASM_PATH}/ -type f | grep -v fasta | grep -v gfa); do
    gzip $f &
done
```


## Approach 2: 

For the second approach, The output from this approach are dual or partially phased diploid assemblies (http://lh3.github.io/2021/10/10/introducing-dual-assembly) using HiFiasm on Hi-C mode, with the filtered PacBio HiFi reads and the Omni-C dataset.

These approach affects pipeline [Version 4](https://github.com/ccgproject/ccgp_assembly/blob/main/versions/V4.0.md) and [Version 5](https://github.com/ccgproject/ccgp_assembly/blob/main/versions/V5.0.md) (and whatever other version that comes after, since this is the intial assembly step).

#### Input

- HiFi Reads

#### Software

- [HiFiasm](https://github.com/chhylp123/hifiasm) (Version 0.16+)
- [gfatool](https://github.com/lh3/gfatools)
- [pigz](https://github.com/madler/pigz)

### Variables

- `WD`: Working directory
- `THREADS`: Number of threads that can be used
- `REFNAME`: genome assembly name
- `HIFIASM_FOLDERNAME`: folder where the output from the HiFiasm run will be stored within `WD`.
- `OMNIC_LIBNAME`: Common prefix of the OmniC datasets
- `OMNICSEQDIR`: Path for the directory that contains the OmniC libraries.

### Code

```
VERSION=0 # This is the first version so - by default - V0
mkdir -p $WD/asm/$HIFIASM_FOLDERNAME
cd $WD/asm/$HIFIASM_FOLDERNAME

# Running actual assembly
# Format of the arguments
##--h1 file1_R1.fastq.gz,file2_R1.fastq.gz --h2 file1_R2....
OMNIC_R1=""
OMNIC_R2=""

for R1 in $(find $OMNICSEQDIR -type f | grep $OMNIC_LIBNAME | grep R1 | grep fastq.gz$| sort | uniq );do
	if [[ -z "$OMNIC_R1" ]];then
		OMNIC_R1="${R1}"
	else
		OMNIC_R1="${OMNIC_R1},${R1}"
	fi
done
for R2 in $(find $OMNICSEQDIR -type f | grep $OMNIC_LIBNAME | grep R2 |  grep fastq.gz$| sort |  uniq);do
        if [[ -z "$OMNIC_R2" ]];then
                OMNIC_R2="${R2}"
        else
                OMNIC_R2="${OMNIC_R2},${R2}"
        fi
done

echo $OMNIC_R1
echo $OMNIC_R2
# Actual assembly run
hifiasm -t $THREADS -o ${REFNAME}.${VERSION} \
        --primary \
        --h1 $OMNIC_R1 \
        --h2 $OMNIC_R2 \
        $WD/seq/hifi/*.filt.fasta.gz &> hifiasm.${REFNAME}.${VERSION}.log

# converts GFA (graph) into FASTA
# Using OmniC/HiC data the assembler now modifies the name of the outputs
# we are keeping the FASTA file with the same naming
# Hap1/hap2
gfatools gfa2fa $WD/asm/${HIFIASM_FOLDERNAME}/${REFNAME}.${VERSION}.hic.hap1.p_ctg.gfa \
        > $WD/asm/${REFNAME}.${VERSION}.p_ctg.fasta
gfatools gfa2fa $WD/asm/${HIFIASM_FOLDERNAME}/${REFNAME}.${VERSION}.hic.hap2.p_ctg.gfa \
        > $WD/asm/${REFNAME}.${VERSION}.a_ctg.fasta


# Compress all the rest of the data
HIFIASM_ASM_PATH="${WD}/asm/$HIFIASM_FOLDERNAME"
for f in  $(find ${HIFIASM_ASM_PATH}/*.gfa -type f); do
    echo "pigz -c -p20 $f > ${HIFIASM_ASM_PATH}/$(basename $f).gz  && rm $f &"
    pigz -c -p20 $f > ${HIFIASM_ASM_PATH}/$(basename $f).gz  && rm $f &
done
for f in  $(find ${HIFIASM_ASM_PATH}/ -type f |  grep -v fasta | grep -v gfa); do
    gzip -f $f &
done
```



# Cite

- [Cheng H, Jarvis ED, Fedrigo O, Koepfli K-P, Urban L, Gemmell NJ, Li H. (2022) Haplotype-resolved assembly of diploid genomes without parental data. Nature Biotechnology,  40, 1332–133. DOI 10.1038/s41587-022-01261-x.](https://www.nature.com/articles/s41587-022-01261-x)
