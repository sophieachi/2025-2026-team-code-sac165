#!/bin/bash -e
#SBATCH --job-name=trimreads_array
#SBATCH --time=7-00:00:00
#SBATCH --array=1-36
#SBATCH --output=logs/trimreads_%a.out
#SBATCH --error=logs/trimreads_%a.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=callie.hundley@duke.edu

# Load modules 
module load Trim_galore

## Set Paths ## 
RAW_DIR=/work/clh162/OysterRNA24/rawreads
TRIMMED_DIR=/work/clh162/OysterRNA24/trimmedreads
mkdir -p $TRIMMED_DIR logs

## Set up direction/path to each sample ##
# Make list of sample names (without _R1/_R2 suffix)
SAMPLES=($(ls ${RAW_DIR}/*_R1_001.fastq.gz | sed 's/_R1_001.fastq.gz//' | xargs -n 1 basename))

# Index an individual sample from the list for this array task
SAMPLE=${SAMPLES[$SLURM_ARRAY_TASK_ID-1]}

# Define R1 and R2 for the sample 
R1=${RAW_DIR}/${SAMPLE}_R1_001.fastq.gz
R2=${RAW_DIR}/${SAMPLE}_R2_001.fastq.gz

## Run Trimming ## 
echo "Trimming ${SAMPLE}..."

trim_galore \
    --paired \
    --quality 30 \
    --output_dir $TRIMMED_DIR \ 
    ${R1} ${R2} 

echo "Trimming completed for ${SAMPLE}"
