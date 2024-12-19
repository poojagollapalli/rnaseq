#!/bin/bash
#SBATCH --array=1-12
#SBATCH --time=20:00:00
#SBATCH --mem=16gb
#SBATCH --cpus-per-task=3
#SBATCH --job-name=mapped_bam_files
#SBATCH --output=array_%J.out
#SBATCH --error=array_%J.err
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/pgollapalli/rnaseq"  # Corrected working directory
OUTDIR="$WORKDIR/mapped_reads"
INDEXFILES="$WORKDIR/map/Homo_sapiens_GRCh38_index"  # Correct path to reference genome index

mkdir -p $OUTDIR

# Define sample and read files based on task ID
case $SLURM_ARRAY_TASK_ID in
1)
  SAMPLE="HER21"
  READ1="/data/users/pgollapalli/rnaseq/breastcancer/HER21_R1.fastq.gz"  # Corrected path
  READ2="/data/users/pgollapalli/rnaseq/breastcancer/HER21_R2.fastq.gz"
  ;;
2)
  SAMPLE="HER22"
  READ1="/data/users/pgollapalli/rnaseq/breastcancer/HER22_R1.fastq.gz"
  READ2="/data/users/pgollapalli/rnaseq/breastcancer/HER22_R2.fastq.gz"
  ;;
3)
  SAMPLE="HER23"
  READ1="/data/users/pgollapalli/rnaseq/breastcancer/HER23_R1.fastq.gz"
  READ2="/data/users/pgollapalli/rnaseq/breastcancer/HER23_R2.fastq.gz"
  ;;
4)
  SAMPLE="NonTNBC1"
  READ1="/data/users/pgollapalli/rnaseq/breastcancer/NonTNBC1_R1.fastq.gz"
  READ2="/data/users/pgollapalli/rnaseq/breastcancer/NonTNBC1_R2.fastq.gz"
  ;;
5)
  SAMPLE="NonTNBC2"
  READ1="/data/users/pgollapalli/rnaseq/breastcancer/NonTNBC2_R1.fastq.gz"
  READ2="/data/users/pgollapalli/rnaseq/breastcancer/NonTNBC2_R2.fastq.gz"
  ;;
6)
  SAMPLE="NonTNBC3"
  READ1="/data/users/pgollapalli/rnaseq/breastcancer/NonTNBC3_R1.fastq.gz"
  READ2="/data/users/pgollapalli/rnaseq/breastcancer/NonTNBC3_R2.fastq.gz"
  ;;
7)
  SAMPLE="Normal1"
  READ1="/data/users/pgollapalli/rnaseq/breastcancer/Normal1_R1.fastq.gz"
  READ2="/data/users/pgollapalli/rnaseq/breastcancer/Normal1_R2.fastq.gz"
  ;;
8)
  SAMPLE="Normal2"
  READ1="/data/users/pgollapalli/rnaseq/breastcancer/Normal2_R1.fastq.gz"
  READ2="/data/users/pgollapalli/rnaseq/breastcancer/Normal2_R2.fastq.gz"
  ;;
9)
  SAMPLE="Normal3"
  READ1="/data/users/pgollapalli/rnaseq/breastcancer/Normal3_R1.fastq.gz"
  READ2="/data/users/pgollapalli/rnaseq/breastcancer/Normal3_R2.fastq.gz"
  ;;
10)
  SAMPLE="TNBC1"
  READ1="/data/users/pgollapalli/rnaseq/breastcancer/TNBC1_R1.fastq.gz"
  READ2="/data/users/pgollapalli/rnaseq/breastcancer/TNBC1_R2.fastq.gz"
  ;;
11)
  SAMPLE="TNBC2"
  READ1="/data/users/pgollapalli/rnaseq/breastcancer/TNBC2_R1.fastq.gz"
  READ2="/data/users/pgollapalli/rnaseq/breastcancer/TNBC2_R2.fastq.gz"
  ;;
12)
  SAMPLE="TNBC3"
  READ1="/data/users/pgollapalli/rnaseq/breastcancer/TNBC3_R1.fastq.gz"
  READ2="/data/users/pgollapalli/rnaseq/breastcancer/TNBC3_R2.fastq.gz"
  ;;
*)
  echo "Invalid SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
  exit 1
  ;;
esac

apptainer exec --bind /data/ /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif bash -c "
    hisat2 -p 3 -x $INDEXFILES -1 $READ1 -2 $READ2 -S $OUTDIR/$SAMPLE.sam 2> $OUTDIR/${SAMPLE}_hisat2_summary.log;
    samtools view -S -b $OUTDIR/$SAMPLE.sam > $OUTDIR/${SAMPLE}_mapped.bam
"

echo "Mapping completed for $SAMPLE"

