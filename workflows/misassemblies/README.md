# Identification of misassemblies

## Overview

## Alignments

## HiGlass contact maps

### Generation

### Visualization

## Pretext contact maps

### Generation 

#### Requirements

##### Input

##### Software

#### Code

```
conda activate pretext
 samtools view -h -@ $THREADS $WD/aln/assembly.omnic.bam \
    | PretextMap -o $WD/contact_maps/assembly.multimap.pretext \
        --sortby length --sortorder descend &
samtools view -h -@ $THREADS $WD/aln/assembly.pairtools.bam \
    | PretextMap -o $WD/contact_maps/assembly.pairtools.pretext \
        --sortby length --sortorder descend &&
PretextSnapshot -m $WD/contact_maps/assembly.pairtools.pretext \
        -c "Red 2" -r 12000 --gridColour "black" \
        --printSequenceNames \
        -o $WD/contact_maps/ \
        --minTexels 8 \
        --prefix "assembly_" \
        --sequences "=full" &
conda deactivate
```

### Visualization

