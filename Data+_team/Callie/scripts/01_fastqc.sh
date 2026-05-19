#!/bin/bash -e
#SBATCH --job-name=fastqc_array
#SBATCH --time=7-00:00:00
#SBATCH --array=1-36
#SBATCH --output=logs/fastqc_%a.out
#SBATCH --error=logs/fastqc_%a.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=callie.hundley@duke.edu

# Load module
module load FastQC

## Set paths ##
RAW_DIR=/work/clh162/OysterRNA24/rawreads
FASTQC_OUT=/work/clh162/OysterRNA24/fastqc_raw
mkdir -p $FASTQC_OUT

## Set up direction/path to each sample ##
# Make list of sample names (without _R1/_R2 suffix)
SAMPLES=($(ls ${RAW_DIR}/*_R1_001.fastq.gz | sed 's/_R1_001.fastq.gz//' | xargs -n 1 basename))

# Index an individual sample from the list for this array task
SAMPLE=${SAMPLES[$SLURM_ARRAY_TASK_ID-1]}

# Define R1 and R2 for the sample 
R1=${RAW_DIR}/${SAMPLE}_R1_001.fastq.gz
R2=${RAW_DIR}/${SAMPLE}_R2_001.fastq.gz

## Run FastQC ##
echo "Running FastQC for sample: ${SAMPLE}"
fastqc -o ${FASTQC_OUT} -t ${SLURM_CPUS_PER_TASK} ${R1} ${R2}

echo "FastQC complete for sample: ${SAMPLE}"
