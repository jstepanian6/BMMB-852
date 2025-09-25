set -uexo pipefail

## Parameter number 1 is the SRR number
SRR=$1
READ_DIR=reads

#--------- NO CHANGES BELOW THIS LINE --------

mkdir -p $READ_DIR

fastq-dump -X 137931 -F --outdir $READ_DIR --split-files $1 

#Stats 
seqkit stats $READ_DIR/${SRR}_1.fastq $READ_DIR/${SRR}_2.fastq
