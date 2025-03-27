# Metrics for contiguity

### Assumptions

- There is a directory hierarchy from `WD`.
  - `WD/`:
    - `asm/`: assemblies
    - `info/`: assemblies

- The estimation of the genome size and other genomic features has been obtained (See [here](https://github.com/ccgproject/ccgp_assembly/tree/main/workflows/preasm#genome-size-heterozygosity-and-repeat-content-estimation), to learn how to run it).
  - Output of this estimation (GenomeScope2.0 run) is under `$WD/info/genomescope` and the `stdout` output of GenomeScope2.0 is stored in a file `$WD/info/genomescope.log`
  - This would be required to get NG50 metrics. If the folder (or file) does not exist, then the NG50 metrics will **NOT** be generated.

### Requirements

#### Input

- Genome assembly (`FASTA`)
- Estimated genome size

#### Software

- Conda enviroment for `quast` (download [here](https://github.com/ccgproject/ccgp_assembly/blob/main/workflows/conda_env/conda.env.quast.yml))
- `split_fa` (from [`purge_dups`](https://github.com/dfguan/purge_dups)), but this could be modified to any software that splits an assembly file (`FASTA` file), at the gaps (generates a contig-level assembly).

#### Code

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

#### Parsing QUAST output

- Assuming QUAST runs have been done on both assemblies, [here's a script](https://github.com/ccgproject/ccgp_assembly/blob/main/workflows/metrics/scripts/parseQuast.shortmetrics.sh) that would be able to generate a summarize table (in TSV format) with the information of both assemblies.

- You will be able to run the script:

```
bash parseQuast.shortmetrics.sh shortReferenceName version workingDirectory
```

For example: 
- If I wanted to run the script on the assembly of the **Puma concolor** (`mPumCon1`) initial version (`version=0`) and the hierachy of the project follows what has been explain throughout the repository:

  ```
  > bash parseQuast.shortmetrics.sh mPumCon1 0 /my/project/working/directory
  ```
- Output after running the script should be something like this:

```
Assembly            	mPumCon1.0.p_ctg    	mPumCon1.0.a_ctg
# contigs           	384                 	300
Largest contig      	110887988           	141280224
Total length        	2373411960          	2496348609
Estimated reference length	2363378643          	2363378643
GC (%)              	41.89               	41.91
N50                 	50506965            	65702467
NG50                	50506965            	65828543
L50                 	16                  	15
LG50                	16                  	14
# scaffolds         	384                 	300
Largest scaffold    	110887988           	141280224
Total length        	2373411960          	2496348609
Estimated reference length	2363378643          	2363378643
GC (%)              	41.89               	41.91
N50                 	50506965            	65702467
NG50                	50506965            	65828543
L50                 	16                  	15
LG50                	16                  	14
# N's per 100 kbp   	0.00                	0.00
```
