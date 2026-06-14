#!/bin/bash
#PBS -W group_list=pr_47002 -A pr_47002
#PBS -N merge
#PBS -e merge.err
#PBS -o merge.log
#PBS -m n
#PBS -l nodes=1:ppn=1
#PBS -l mem=2gb
#PBS -l walltime=02:00:00


INDIR="/home/projects/pr_47002/data/DANIELA/mackerel/trimmed"
OUTDIR="/home/projects/pr_47002/data/DANIELA/mackerel/merged"

# Create output directory if it doesn't exist
mkdir -p "$OUTDIR"

cd "$INDIR" || exit

echo "Starting lane merging..."
echo "Input dir: $INDIR"
echo "Output dir: $OUTDIR"

# Extract unique sample IDs (everything before _MKRN)
samples=$(ls *_forward_paired.fq | sed 's/_MKRN.*//' | sort | uniq)

for sample in $samples
do
    echo "-------------------------------------"
    echo "Processing sample: $sample"

    # Forward reads
    forward_files=$(ls ${sample}_MKRN*_forward_paired.fq 2>/dev/null)

    # Reverse reads
    reverse_files=$(ls ${sample}_MKRN*_reverse_paired.fq 2>/dev/null)

    # Output files
    out_R1="${OUTDIR}/${sample}_R1_merged.fq"
    out_R2="${OUTDIR}/${sample}_R2_merged.fq"

    # Merge forward
    if [ -n "$forward_files" ]; then
        cat $forward_files > "$out_R1"
        echo "Created $out_R1"
    else
        echo "WARNING: No forward files for $sample"
    fi

    # Merge reverse
    if [ -n "$reverse_files" ]; then
        cat $reverse_files > "$out_R2"
        echo "Created $out_R2"
    else
        echo "WARNING: No reverse files for $sample"
    fi

done

echo "Merging completed!"
``