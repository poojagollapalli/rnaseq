#!/bin/bash
#SBATCH --job-name=multiqc
#SBATCH --output=multiqc.out
#SBATCH --error=multiqc.err
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --time=02:00:00
#SBATCH --partition=pibu_el8


module load MultiQC/1.11 
INPUT_DIR="/data/users/pgollapalli/rnaseq/fastqc_results"  
OUTPUT_DIR="/data/users/pgollapalli/rnaseq/multiqc_output"

mkdir -p $OUTPUT_DIR
multiqc $INPUT_DIR -o $OUTPUT_DIR