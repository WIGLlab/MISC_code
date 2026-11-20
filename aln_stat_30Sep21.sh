#!/bin/bash
# ----------------SLURM Parameters----------------
#SBATCH -p normal
#SBATCH -n 1
#SBATCH --mem=16g
#SBATCH -N 1
#SBATCH --mail-user=deflami2@illinoise.edu
#SBATCH --mail-type=ALL
#SBATCH -J aln_stat
# ----------------Load Modules--------------------
module load SAMtools/1.12-IGB-gcc-8.2.0
# ----------------Commands------------------------

#launch this code from the directory containing bams
#sample_names=$(ls -1 | grep '^Alida' | cut -f1 -d '.' | sort -u) #change grep to work for your samples
sample_names=$(ls *.fastq | cut -f1 -d '.') #vivian


for sample in $sample_names
do
    echo ${sample}>> aln_stat.txt
    echo "depth" >> aln_stat.txt
    samtools depth -a  ${sample}.ready.bam |	awk '{c++;s+=$3}END{print s/c}' >> aln_stat.txt
    echo "breadth" >> aln_stat.txt
    samtools depth -a  ${sample}.ready.bam |	awk '{c++; if($3>0) total+=1}END{print (total/c)*100}' >> aln_stat.txt
    echo "Total reads after trim" >> aln_stat.txt
    cat ${sample}.wdup.bam.stat | sed -n '1p' >> aln_stat.txt
    echo "Filtered reads" >> aln_stat.txt
    cat ${sample}.ready.bam.stat | sed -n '5p' >> aln_stat.txt
    echo "---------" >> aln_stat.txt
done

#awk 'NR%10{printf "%s,", $0; next} {print $0}' aln_stat.txt > aln_stat.csv