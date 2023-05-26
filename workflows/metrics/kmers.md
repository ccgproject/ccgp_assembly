# per base quality / k-mer completeness

## Assumptions

- The `meryl` database should have been generated (find the [how-to here](https://github.com/ccgproject/ccgp_assembly/tree/main/workflows/preasm#k-mer-counting))

## Requirements

### Input

- Assemblies
- `meryl` database

### Software

- [`merqury`](https://github.com/marbl/merqury)
- Conda environment with the `merqury` setup (download [here](https://github.com/ccgproject/ccgp_assembly/blob/main/workflows/conda_env/conda.env.merqury.yml))

## Code

### Variables

- `WD`: Working directory
- `VERSION`: assembly version 

```
conda activate merqury
mkdir -p $WD/info/merqury/v${VERSION}

cd $WD/info/merqury/v${VERSION}

merqury.sh $WD/info/meryl/${REFNAME}.hifi.meryl \
    $WD/asm/assembly.${VERSION}.p_ctg.fasta \
    $WD/asm/assembly.${VERSION}.a_ctg.fasta \
    merqury &> merqury.log
conda deactivate
```
