#!/bin/bash

#SBATCH --mail-type=fail
#SBATCH --job-name="index"
#SBATCH --output=index1.out
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=3:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8

# Define directories
WORKDIR="/data/users/pgollapalli/rnaseq"
MAPDIR="$WORKDIR/map"
READSDIR="/data/courses/rnaseq/breastcancer_de/reads"

# Create output directory for reference genome indexing
mkdir -p $MAPDIR
cd $MAPDIR

# Download the reference genome and annotation files
wget https://ftp.ensembl.org/pub/release-113/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
wget https://ftp.ensembl.org/pub/release-113/gtf/homo_sapiens/Homo_sapiens.GRCh38.113.gtf.gz

# Unzip the reference genome and annotation files
gunzip Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
gunzip Homo_sapiens.GRCh38.113.gtf.gz

# Load the HISAT2 module (or use Apptainer container)
module load HISAT2/2.2.1-gompi-2021a

# Index the reference genome with Hisat2
apptainer exec --bind /data/ /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif \
    hisat2-build $MAPDIR/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
    $MAPDIR/Homo_sapiens_GRCh38_index
