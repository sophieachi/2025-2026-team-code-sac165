#!/bin/bash -e
#SBATCH --job-name=trim_multiqc_array
#SBATCH --time=7-00:00:00
#SBATCH --array=1-36
#SBATCH --output=logs/trim_multiqc_%a.out
#SBATCH --error=logs/trim_multiqc_%a.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=callie.hundley@duke.edu

## Set paths ##


## Run MultiQC ##


