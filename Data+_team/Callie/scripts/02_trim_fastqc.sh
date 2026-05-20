#!/bin/bash -e
#SBATCH --job-name=trim_fastqc_array
#SBATCH --time=7-00:00:00
#SBATCH --array=1-36
#SBATCH --output=/work/clh162/OysterRNA24/logs/trim_fastqc_%a.out
#SBATCH --error=/work/clh162/OysterRNA24/logs/trim_fastqc_%a.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=callie.hundley@duke.edu

## Load module ##
module load FastQC

## Set paths ##
TRIMMED_DIR=/work/clh162/OysterRNA24/trimmedreads
FASTQC_OUT=/work/clh162/OysterRNA24/fastqc_trimmed
mkdir -p $FASTQC_OUT

## Set up direction/path to each sample ##
SAMPLES=($(ls ${TRIMMED_DIR}/*_R1_001_val_1.fq.gz | sed 's/_R1_001_val_1.fq.gz//' | xargs -n 1 basename))

# Index an individual sample from the list for this array task
SAMPLE=${SAMPLES[$SLURM_ARRAY_TASK_ID-1]}

# Define R1 and R2 for the sample 
R1=${TRIMMED_DIR}/${SAMPLE}_R1_001_val_1.fq.gz
R2=${TRIMMED_DIR}/${SAMPLE}_R1_001_val_1.fq.gz


## Run FastQC on Trimmed Samples ##
## Run FastQC ##
echo "Running FastQC for sample: ${SAMPLE}"

fastqc -o ${FASTQC_OUT} -t ${SLURM_CPUS_PER_TASK} ${R1} ${R2}

echo "FastQC complete for sample: ${SAMPLE}"
