#!/bin/bash -e
#SBATCH --job-name=fastqc_data
#SBATCH --time=7-00:00:00
#SBATCH --output=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/fastqc_%j.out
#SBATCH --error=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/fastqc_%j.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sophie.chi@duke.edu

# load fastqc
module load fastqc

# set paths
RAW_DIR = /work/clh162/OysterRNA24/rawreads
FASTQC_OUTPUT_DIR = /work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/fastqc_data

# make folder for fastqc files
mkdir -p $FASTQC_OUTPUT_DIR

# run fastqc on the raw reads and put them in the output folder
fastqc $RAW_DIR/*.fastq.gz -o $FASTQC_OUTPUT_DIR
