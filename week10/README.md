# Week 10: Variant Calling Pipeline

## Prerequisites


Install and activate conda package

```
curl http://data.biostarhandbook.com/install.sh | bash
conda activate bioinfo

```

## Quick Start


### Prepare Reference Genome

Before processing any samples, download and index the reference genome, this only needs to be done once:

```
make genome ACC=NC_007793.1

```

This creates:

-   `refs/NC_007793.1.fa`  - Reference genome
-   `refs/NC_007793.1.fa.bwt`  (and other BWA index files)

### Processing a Single Sample

To process one sample from download to coverage analysis:

make sample SRR=SRR21835896 SAMPLE=control_1

This will:

1.  Download reads from SRA (as  `reads/SRR21835896_*.fastq`)
2.  Align reads to the reference genome
3.  Generate alignment file (`bam/control_1.bam`)
4.  Create alignment statistics
5.  Generate coverage files (`bam/control_1.bedgraph`  and  `bam/control_1.bw`)

### Call Variants for a Single Sample 
If you already have a BAM file and only need variant calling:

    make variants SAMPLE=sample1
The variant calling workflow uses a multi-step bcftools pipeline:

1.  **bcftools mpileup**: Generates genotype likelihoods from aligned reads
2.  **bcftools call**: Calls variants from likelihoods
3.  **bcftools norm**: Normalizes indels and removes duplicates
4.  **bcftools sort**: Sorts variants by chromosomal position

**Key Parameters:**

-   `-d 100`: Maximum read depth of 100
-   `--ploidy 2`: Diploid organism
-   `-mv`: Output multiallelic and variant sites only
-   `-d all`: Remove all duplicate positions

**Annotations:**

-   `INFO/AD`: Allelic depth
-   `FORMAT/DP`: Read depth per sample
-   `FORMAT/GQ`: Genotype quality
-   `FORMAT/SP`: Strand bias P-value
### Processing Samples in Parallel 

    cat design.csv | parallel -j 4 --colsep , --header :   'make sample SRR={srr_id} SAMPLE={sample_number}'
### Create Multisample VCF 

    make merge-vcf

#### Design file

A design file must be constructed with SRR ids and other information that wants to be kept. In this case, all the SRR were retrived from NCBI website. An example design file was created and named "design.csv".


### Single Sample VCF Visualization 

    # View VCF statistics
    bcftools stats vcf/sample1.vcf.gz | grep "^SN"
    
    # View variants in terminal
    bcftools view vcf/sample1.vcf.gz | less -S
    
    # Load in IGV alongside BAM and GFF
### Multisample VCF Visualization 

    # View sample information
    bcftools query -l vcf/multisample.vcf.gz
    
    # Extract variants in specific region
    bcftools view -r NC_007793.1:1000-2000 vcf/multisample.vcf.gz
    
    # View variant statistics
    bcftools stats vcf/multisample.vcf.gz | grep "^SN"

