#!/bin/bash
#SBATCH --array=1-12
#SBATCH --time=20:00:00
#SBATCH --mem=16gb
#SBATCH --cpus-per-task=3
#SBATCH --job-name=mapped_bam_files
#SBATCH --output=array_%J.out
#SBATCH --error=array_%J.err
#SBATCH --partition=pibu_el8



INDIR="/data/courses/RNAseq/breastcancer_de/reads"
WORKDIR="/data/users/pgollapalli/RNAseq"
OUTDIR="$WORKDIR/map/sorted_bam"

mkdir -p $OUTDIR

SAMPLELIST="/data/users/pgollapalli/RNAseq/reads_list.tsv"
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`

mkdir -p $WORKDIR/mapped_reads

apptainer exec --bind /data /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif\
 samtools sort -m 2G -@ 8 -o ${OUTDIR}/${SAMPLE}_sorted.bam -T ${OUTDIR}/${SAMPLE}_temp ${OUTDIR}/${SAMPLE}_mapped.bam

 
