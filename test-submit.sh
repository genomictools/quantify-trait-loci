#!/bin/bash

#SBATCH -o test/test.out
#SBATCH -e test/test.err
#SBATCH -J test
#SBATCH -p master-worker
#SBATCH -t 120:00:00

# Setup test directory
mkdir -p tests/ tests/input

# Download dataset
URL="https://raw.githubusercontent.com/andreyshabalin/MatrixEQTL/refs/heads/master/data"
wget -c $URL/GE.txt -O tests/input/GE.txt
wget -c $URL/geneloc.txt -O tests/input/geneloc.txt
wget -c $URL/SNP.txt -O tests/input/SNP.txt
wget -c $URL/snpsloc.txt -O tests/input/snpsloc.txt
wget -c $URL/Covariates.txt -O tests/input/Covariates.txt

echo -e "cohort,category,snps,traits,covariates" > tests/input/cohorts_info.csv
echo -e "test,all,input/SNP.txt,input/GE.txt,input/Covariates.txt" >> tests/input/cohorts_info.csv

cd tests/

# Run nextflow
module load Nextflow

# nextflow run genomictools/quantify-trait-loci -r main \
nextflow run ../main.nf \
    --output_dir ./results/ \
    -profile local,test \
    -resume

# usage: nextflow run [ local_dir/main.nf | git_url ]  
# These are the required arguments:
#     -r            {main,dev} to run specific branch
#     -profile      {local,cluster} to run using differens resources
#     -params-file  params.json to pass parameters to the pipeline
#     -resume       To resume the pipeline from the last checkpoint
