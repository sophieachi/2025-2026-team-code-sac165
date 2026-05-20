#!/bin/bash -e
#SBATCH --job-name=trim_multiqc
#SBATCH --time=7-00:00:00
#SBATCH --output=/work/clh162/OysterRNA24/logs/trim_multiqc_%a.out
#SBATCH --error=/work/clh162/OysterRNA24/logs/trim_multiqc_%a.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=callie.hundley@duke.edu

# Activate conda environment containing RNA-seq package
source /hpc/home/clh162/miniconda3/etc/profile.d/conda.sh
conda activate RNA-seq

## Set paths ##
FASTQC_OUT=/work/clh162/OysterRNA24/fastqc_trimmed
MULTIQC_OUT=/work/clh162/OysterRNA24/multiqc_report_trimmed
mkdir -p $MULTIQC_OUT


## Run MultiQC ##
multiqc $FASTQC_OUT -o $MULTIQC_OUT
echo "MultiQC complete!"

conda deactivate

