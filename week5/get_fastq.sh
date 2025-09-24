set -uexo pipefail

## Parameter number 1 is the SRR number
SRR=$1
READ_DIR=reads

#--------- NO CHANGES BELOW THIS LINE --------
mkdir -p $READ_DIR


##TODO Fix the X to get 10x coverage -X number of reads 
fastq-dump -X 137931 -F --outdir reads --split-files $1

#Stats 
seqkit stats $READ_DIR/${SRR}_1.fastq $READ_DIR/${SRR}_2.fastq
