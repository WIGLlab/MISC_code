#!/bin/bash

#SBATCH --ntasks=4 #threads
#SBATCH --time 144:00:00
#SBATCH --job-name=sock_aln
#SBATCH --partition=catchenlab
#SBATCH --mail-user=deflami2@illinois.edu
#SBATCH --mail-type=ALL

#---modules:
module load gcc


#---comands:

cd /projects/catchenlab/data/oncorhynchus/sock/modern/trimmed

#align to the reference genome 

sample_names=$(ls -1 | grep '^KEN' | cut -f1 -d '.'| sed -E 's/^(.+)_R[12]_[0-9]{3}$/\1/'|sort -u)

for sample in $sample_names
do
    bwa mem -M -t 4 GCF_006149115.2_Oner_1.1_genomic.fna ${sample}.R1.pG.trimmed.fq.gz ${sample}.R2.pG.trimmed.fq.gz | samtools sort -@4 -o ${sample}.aln.raw.bam -
    picard MarkDuplicates I=${sample}.aln.raw.bam O=${sample}_marked_dups.bam M=${sample}_marked_dup_metrics.txt
    samtools view -bh -q 25 -F 4 -F 1024 ${sample}_marked_dups.bam >  ${sample}.dedup.filt.bam
done

#parameter_explanation
#BWA -m -t 4 (use 4 threads)(-M	Mark shorter split hits as secondary for Picard compatibility).
#samtools sort -@4 (use 4 threads; the - at end tells samtools to use pipe-input)
#samtools view -bh -q 25 -F 4 -F 1024  (filter alignment qual 25; remove unmapped reads using flag 4; remove duplicates using flag 1024)
