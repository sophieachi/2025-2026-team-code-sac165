#!/bin/bash -e
#SBATCH --job-name=trim_fastqc_array
#SBATCH --time=7-00:00:00
#SBATCH --array=1-36
#SBATCH --output=logs/trim_fastqc_%a.out
#SBATCH --error=logs/trim_fastqc_%a.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=callie.hundley@duke.edu

# Load module
module load FastQC

## Set paths ##
TRIMMED_DIR=/work/clh162/OysterRNA24/trimmedreads
FASTQC_OUT=/work/clh162/OysterRNA24/fastqc_trimmed
mkdir -p $FASTQC_OUT

## Set up direction/path to each sample ##

## Run FastQC on Trimmed Samples ##
## Run FastQC ##
echo "Running FastQC for sample: ${SAMPLE}"
fastqc -o ${FASTQC_OUT} -t ${SLURM_CPUS_PER_TASK} ${R1} ${R2}

echo "FastQC complete for sample: ${SAMPLE}"
