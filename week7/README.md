# Week 7 
This is the README file for assignment number 7. Reusing code described in [week6](https://github.com/jstepanian6/BMMB-852/tree/main/week6). 
# Genomic Analysis Pipeline 
A Makefile-based workflow for downloading reference genomes, fetching sequencing reads from SRA, performing alignment, and generating coverage files.
## Overview
This pipeline automates the process of:
 -  Downloading a reference genome from GenBank
 -  Fetching paired-end sequencing reads from the Sequence Read Archive (SRA)
 -  Indexing the reference genome
 -  Aligning reads to the reference using BWA-MEM
 -  Generating alignment statistics
 -  Creating bedGraph and BigWig coverage files
## Prerequisites
Create bioinfo conda package using 

    curl http://data.biostarhandbook.com/install.sh | bash
When completed, this will show: 

    #
    # Biostar Handbook installation complete! 
    #
Then it can be activated by using: 

    conda activate bioinfo
 
## Configuration 
You can customize the following variables 

 - ACC # GenBank accession for reference genome 
 - SRR# SRA run number 
 - N=137931 # Number of reads to download 
## Directory structure 
The pipeline creates the following directory structure:

    .
    ├── refs/              # Reference genome files
    ├── reads/             # Downloaded FASTQ files
    └── bam/               # Alignment files and coverage tracks
## Usage 

For a quick summary on how to use this file you can use the following code: 

    make usage
For executing the full pipeling using an example accession code, an example genome reference with a 10X coverage, this is the code to be used: 

    make all
### Individual targets
This make file also can perform individual process: 

**Download reference genome:**

```bash
make refs
```

**Download sequencing reads:**

```bash
make fastq
```

**Index the reference genome:**

```bash
make index
```

**Align reads to reference:**
```bash
make align
```

-   Uses 4 threads by default
-   Generates sorted BAM file and index
**Generate alignment statistics:**
```bash
make stats
```

-   Outputs flagstat and coverage information

**Create coverage tracks:**
```bash
make bedgraph
```

-   Generates bedGraph file
-   Converts to BigWig format
-   Uses deepTools bamCoverage (requires micromamba environment named 'deep')

**Clean up generated files:**
```bash
make clean
```
-   Removes reference, reads, and alignment files
-   Use with caution!
## Output Files

-   `refs/NC_007793.1.fa` - Reference genome in FASTA format
-   `refs/NC_007793.1.fa.*` - BWA index files
-   `reads/SRR21835896_1.fastq` - Forward reads
-   `reads/SRR21835896_2.fastq` - Reverse reads
-   `bam/SRR21835896.bam` - Sorted alignment file
-   `bam/SRR21835896.bam.bai` - BAM index
-   `bam/SRR21835896.bedgraph` - Coverage in bedGraph format
-   `bam/SRR21835896deeptools.bw` - Coverage in BigWig format
## Notes

-   The pipeline is configured for **paired-end reads**. For single-end reads, modify the `align` target to use only `${R1}`.
-   By default, only 137,931 reads are downloaded. To download all available reads, remove the `-X ${N}` flag from the `fastq` target.
-   The alignment step uses 4 threads. Adjust the `-t` parameter in the `align` target for your system.
-   The `bedgraph` target requires a micromamba environment named 'deep' with deepTools installed.

## Example of execution
Two *S. aureus* accessions were analized using this make file: one coming from Illumina sequencing (SRR21835896) and the other one coming from Nanopore GridION tecnology (SRR33300097):

### Diferences between alignment files 
Illumina had 275338 primary mapped reads (99.81%). 
Nanopore reads had only 4408 primary mapped reads (88.16%). 
The amount of reads was expected considering that nanopore outputs longer reads, but the lower quality on the alignment can be due to contamination or even sequencing errors. 
## Larger coordinate observed coverage 
For determining what coordinate has the largest observed coverage (hint samtools depth), I used: 

    samtools depth bam/${BAM}.bam | sort -k3,3nr | head -n 1


Getting as output: 

 - SRR21835896 (Illumina): NC_007793.1	2500332	27272
 - SRR33300097 (Nanopore): NC_007793.1	168868	63

## Gene of interest 
I selected *dnaA* as  a gene of interest due to it encodes the DnaA protein, which is a crucial master regulator of chromosomal DNA replication in bacteria.

    samtools view -c -F 20 bam/{BAM}.bam NC_007793.1:544-1905
Getting as output: 

 - Illumina SRR21835896: 27 
 - Nanopore SRR33300097: 4

This image shows an overview of the alignments, it is very easy to tell which one comes from Illumina and which one comes from Nanopore sequencing: 
<img width="1854" height="1165" alt="image" src="https://github.com/user-attachments/assets/b3cb4af0-4681-4ab9-a471-79795cb4066a" />
