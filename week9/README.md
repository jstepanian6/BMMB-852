
# Week 9: # Revising and Improving Your Automation Code

## Prerequisites 

 Update your Linux system

    sudo apt-get update && sudo apt-get upgrade -y

Install bzip2 because it may not be installed by default

    sudo apt install -y  bzip2

Install and activate conda package 

    curl http://data.biostarhandbook.com/install.sh | bash
    conda activate bioinfo

## Quick Start
### Prepare Reference Genome 
Before processing any samples, download and index the reference genome, this only needs to be done once:

    make genome ACC=NC_007793.1
This creates:

-   `refs/NC_007793.1.fa` - Reference genome
-   `refs/NC_007793.1.fa.bwt` (and other BWA index files)
### Processing a Single Sample 

To process one sample from download to coverage analysis:
```bash
make sample SRR=SRR21835896 SAMPLE=control_1
```

This will:

1.  Download reads from SRA (as `reads/SRR21835896_*.fastq`)
2.  Align reads to the reference genome
3.  Generate alignment file (`bam/control_1.bam`)
4.  Create alignment statistics
5.  Generate coverage files (`bam/control_1.bedgraph` and `bam/control_1.bw`)
### Processing Samples in Parallel 
#### Design file

A design file must be constructed with SRR ids and other information that wants to be kept. In this case, all the SRR were retrived from NCBI website. An example design file was created and named "design.csv".

Now that we have a CSV file (design.csv) with multiple SRR accessions, you can process them in parallel:

```
cat design.csv | parallel -j 4 --colsep , --header : 'make sample SRR={srr_id} SAMPLE={Sample}'
```
## Makefile Targets
### Genome Preparation (Non-Parallelizable)

-   **`genome`**: Download and index the reference genome (run once before processing samples)

### Sample Processing (Parallelizable)

-   **`sample`**: Complete workflow for a single sample (fastq → align → stats → coverage)
-   **`fastq`**: Download reads from SRA
-   **`align`**: Align reads and generate BAM file
-   **`stats`**: Generate alignment statistics
-   **`coverage`**: Generate bedgraph and bigWig coverage files

### Utility

-   **`clean`**: Remove files for a specific sample
-   **`clean-all`**: Remove all generated files including genome
-   **`usage`**: Display help message

## Configuration Variables

Set these on the command line or edit the Makefile:

| Variable | Description                              | Default      |
|-----------|------------------------------------------|--------------|
| ACC       | GenBank accession for reference genome   | NC_007793.1  |
| SAMPLE    | Output sample name                       | sample1      |



## Directory Structure

    .
    ├── Makefile           # Pipeline definition
    ├── design.csv         # Sample metadata
    ├── refs/              # Reference genome (created by 'make genome')
    │   ├── NC_007793.1.fa
    │   └── NC_007793.1.fa.* (BWA index files)
    ├── reads/             # Downloaded reads (named by SRR)
    │   ├── SRR21835896_1.fastq
    │   └── SRR21835896_2.fastq
    └── bam/               # Alignments and coverage (named by sample)
        ├── control_1.bam
        ├── control_1.bam.bai
        ├── control_1.bedgraph
        └── control_1.bw
