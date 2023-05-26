# Metrics for contiguity

## Assumptions

- There is a directory hierarchy from `WD`.
  - `WD/`:
    - `asm/`: assemblies
    - `info/`: assemblies

- The estimation of the genome size and other genomic features has been obtained (See [here](https://github.com/ccgproject/ccgp_assembly/tree/main/workflows/preasm#genome-size-heterozygosity-and-repeat-content-estimation), to learn how to run it).
  - Output of this estimation (GenomeScope2.0 run) is under `WD/info/genomescope`
  - This would be required to get NG50 metrics. If this folder does not exit, the NG50 metrics will **NOT** be generated.

## Requirements

### Input

- Genome assembly (`FASTA`)
- Genome size

### Software

- Conda enviroment for `quast` (download [here](https://github.com/ccgproject/ccgp_assembly/blob/main/workflows/conda_env/conda.env.quast.yml))
- `split_fa` (from [`purge_dups`](https://github.com/dfguan/purge_dups)), but this could be modified to any software that splits an assembly file (`FASTA` file), at the gaps (generates a contig-level assembly).

## Code

```
# Makes sure that there is folder/directory to write the output
if [[ ! -d $WD/info/quast ]]; then
	mkdir $WD/info/quast
fi

# Checking existence of `genomescope` output
if [[ -f $WD/info/genomescope.log ]]; then
	ESTGENOMESIZE=$(cat $WD/info/genomescope.log  | tail -1 | cut -d ":" -f 6)
else
	ESTGENOMESIZE=0
fi

if [[ "$ESTGENOMESIZE" == "Inf" ]]; then
	ESTGENOMESIZE=0
fi

# runs QUAST - general contiguity metrics
eval "$(conda shell.bash hook)"
conda activate quast

# generate contig-level assemblies
split_fa $WD/asm/assembly.fasta > $WD/asm/assembly.contigs.fasta

quast $WD/asm/assembly.contigs.fasta \
  --est-ref-size $ESTGENOMESIZE \
  -o $WD/info/quast/quast_assembly.contigs &
quast $WD/asm/assembly.fasta \
  --est-ref-size $ESTGENOMESIZE \
  -o $WD/info/quast/quast_assembly &
conda deactivate
```
