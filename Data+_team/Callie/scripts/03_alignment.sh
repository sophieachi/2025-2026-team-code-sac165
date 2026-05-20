#!/bin/bash -e
#SBATCH --job-name=alignment_array
#SBATCH --time=7-00:00:00
#SBATCH --array=1-36
#SBATCH --output=/work/clh162/OysterRNA24/logs/hisat2_alignment_%A_%a.out
#SBATCH --error=/work/clh162/OysterRNA24/logs/hisat2_alignment_%A_%a.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=callie.hundley@duke.edu

## Load module - HISAT2 already loaded on DCC ## 
module load HISAT2

## Set Paths ## 
TRIMMED_DIR=/work/clh162/OysterRNA24/trimmedreads
INDEX_DIR=/work/clh162/OysterRNA24/hisat2_index
BAM_DIR=/work/clh162/OysterRNA24/hisat2_index
mkdir -p ${BAM_DIR}


