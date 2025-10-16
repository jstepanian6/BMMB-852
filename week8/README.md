# Week 8: Excecuting samples in parallel using GNU 

## Design file 
A design file must be constructed with SRR ids and other information that wants to be kept. In this case, all the SRR were retrived from NCBI website. An example design file was created and named "design.csv". 
## Excecuting multiple samples in parallel 
Now that we have a CSV file (design.csv) with multiple SRR accessions, you can process them in parallel:

'''
cat design.csv | parallel -j 2 --colsep , --header : "make all SRR={srr_id}"

'''
This command will:

- Read the design.csv file
- Use column headers to identify the srr_id column
- Run up to 2 jobs in parallel (-j 2)
- Execute the complete pipeline for each SRR accession

##
Identify the sample names that connect the SRR numbers to the samples.
Create a design.csv file that connects the SRR numbers to the sample names.
Create a Makefile that can produce multiple BAM alignment files (you can reuse the one from the previous assignment) where from an SRR you can produce a BAM alignment file named after the sample name.
Using GNU parallel run the Makefile on all (or at least 10) samples.
Create a README.md file that explains how to run the Makefile
