# Week 6
## Make file construction 
All the previosly developed scripts were transformed  into a Makefile that includes rules for:
  1. Obtaining the genome
  2. Downloading sequencing reads from SRA


This Makefile has instructions for:


  1. all: performs all the following actions.
  2. refs: downloads the desire reference.
  3. fastq: downloads the desire reads.
  4. index: creates the index for the reference genome.
  5. align: maps the reads to the reference genome.
  6. clean: removes all the intermediate files. 

## Visualization 
Visualize the resulting BAM files for both simulated reads and reads downloaded from SRA.
<img width="1156" height="806" alt="image" src="https://github.com/user-attachments/assets/2d47a0ac-f072-42b4-a961-41ee43482a1d" />

## Stats 
What percentage of reads aligned to the genome?

  99.81%

  
What was the expected average coverage?

  10X

What is the observed average coverage?

  9.6X

  
How much does the coverage vary across the genome? (Provide a visual estimate.)

  A lot but that is expected considering that it is an RNA-seq experiment.

