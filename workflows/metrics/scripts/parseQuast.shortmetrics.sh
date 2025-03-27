#!/bin/bash
REFNAME=$1 # referenceCode
VERSION=$2 # 0, 1, 2, etc.
WD=$3      # /my/project/path/here

ASMS=(p a)
for asm in 0 1; do
	FOLDER=$WD/info/quast/quast_$REFNAME.$VERSION.${ASMS[$asm]}_ctg
	if [[ -e $FOLDER ]]; then
		ASMS[$asm]=$(
			awk '{ printf "%20-s\t%20-s\n", $1, $2}' <<< $(head -n 1 $FOLDER/report.tsv)
			if [[ -e $FOLDER.contigs ]]; then
				cat  $FOLDER.contigs/report.tsv |grep -v N75 | grep -v NG75 | grep -v L75 | grep -v LG75 | tail -n 10 | head -n 9 | awk -F '	' '{ printf "%20-s\t%20-s\n" ,$1,$2  }'
			else
				echo ,,
				echo ,,
				echo ,,
				echo ,,
				echo ,,
				echo ,,
				echo ,,
			fi
			cat  $FOLDER/report.tsv |grep -v N75 | grep -v NG75 | grep -v L75 | grep -v LG75 | tail -n 10 | sed 's/contig/scaffold/g' | awk -F '	' '{ printf "%20-s\t%20-s\n",$1 ,$2 }'
		)

	else
		echo Quast: $FOLDER does not exist. >&2
		exit 1
	fi
done

paste <(echo "${ASMS[0]}") <(echo "${ASMS[1]}") | cut -f 1,2,4
