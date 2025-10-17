
# Week 8: Excecuting samples in parallel using GNU 

## Design file 
A design file must be constructed with SRR ids and other information that wants to be kept. In this case, all the SRR were retrived from NCBI website. An example design file was created and named "design.csv". 
## Excecuting multiple samples in parallel 
Now that we have a CSV file (design.csv) with multiple SRR accessions, you can process them in parallel:


    cat design.csv | parallel -j 2 --colsep , --header : "make all SRR={srr_id}"

This command will:

- Read the design.csv file
- Use column headers to identify the srr_id column
- Run up to 2 jobs in parallel (-j 2)
- Execute the complete pipeline for each SRR accession
For more information about the make file you can check the README.md on [week7](https://github.com/jstepanian6/BMMB-852/tree/main/week7) 

## Output structure 
The pipeline creates the following directory structure:

        |-- Makefile
    |-- bam
    |   |-- SRR21835896.bam # Aligned reads
    |   |-- SRR21835896.bam.bai # BAM index
    |   |-- SRR21835897.bam
    |   |-- SRR21835897.bam.bai
    |   |-- SRR21835898.bam
    |   |-- SRR21835898.bam.bai
    |   |-- SRR21835899.bam
    |   |-- SRR21835899.bam.bai
    |   |-- SRR21835900.bam
    |   |-- SRR21835900.bam.bai
    |   |-- SRR21835901.bam
    |   `-- SRR21835901.bam.bai
    |-- design.csv
    |-- reads
    |   |-- SRR21835896_1.fastq # Forward reads
    |   |-- SRR21835896_2.fastq # Reverse reads
    |   |-- SRR21835897_1.fastq
    |   |-- SRR21835897_2.fastq
    |   |-- SRR21835898_1.fastq
    |   |-- SRR21835898_2.fastq
    |   |-- SRR21835899_1.fastq
    |   |-- SRR21835899_2.fastq
    |   |-- SRR21835900_1.fastq
    |   |-- SRR21835900_2.fastq
    |   |-- SRR21835901_1.fastq
    |   `-- SRR21835901_2.fastq
    `-- refs # Reference genome
        |-- NC_007793.1.fa
        |-- NC_007793.1.fa.amb
        |-- NC_007793.1.fa.ann
        |-- NC_007793.1.fa.bwt
        |-- NC_007793.1.fa.pac
        `-- NC_007793.1.fa.sa
    
    4 directories, 32 files
## Adjusting Parallelization

To process more samples simultaneously, increase the `-j` parameter:

```bash
cat design.csv | parallel -j 4 --colsep , --header : "make all SRR={srr_id}"
```
