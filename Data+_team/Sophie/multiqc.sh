#!/bin/bash -e
#SBATCH --job-name=multiqc_data
#SBATCH --time=1:00:00
#SBATCH --output=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/multiqc_%j.out
#SBATCH --error=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/multiqc_%j.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sophie.chi@duke.edu

# load multiqc
module load multiqc

# set paths
FASTQC_OUTPUT_DIR = /work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/fastqc_data
MULTIQC_OUTPUT_DIR = /work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/multiqc_data

# make folder for multiqc output
mkdir -p $MULTIQC_OUTPUT_DIR

# run multiqc
multiqc $FASTQC_OUTPUT_DIR -o $MULTIQC_OUTPUT_DIR

echo "MultiQC complete"