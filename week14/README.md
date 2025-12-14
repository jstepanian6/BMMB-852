
# RNA-seq Analysis Pipeline

An automated pipeline for processing RNA-seq data, from raw reads to differential expression analysis and functional enrichment.

## Overview

This Makefile implements a complete RNA-seq analysis workflow that includes:

-   Reference genome and annotation download
-   Genome indexing (BWA and HISAT2)
-   Read alignment
-   BAM to BigWig conversion for visualization
-   Gene-level quantification
-   Differential expression analysis
-   Principal component analysis
-   Heatmap visualization
-   Functional enrichment analysis


## Usage

### Run Complete Pipeline

```bash
make all 

```

### Run Individual Steps

**Download reference data:**

```bash
make download_data

```

**Index the genome:**

```bash
make index

```

**Align reads:**

```bash
make align SAMPLE=HBR_1

```

**Generate BigWig files:**

```bash
make bigwig SAMPLE=HBR_1

```

**Count features:**

```bash
make counts

```

**Run statistical analysis:**

```bash
make analysis

```

### Help

```bash
make help

```

## Pipeline Steps

### 1. Download Data (`download_data`)

-   Creates directory structure
-   Downloads reference genome and GTF annotation
-   Extracts chr22 reference files

### 2. Index Genome (`index`)

-   Creates BWA index for alignment
-   Generates samtools faidx index
-   Builds HISAT2 index (4 threads)

### 3. Align Reads (`align`)

-   Aligns reads using BWA MEM (4 threads)
-   Sorts alignments and creates indexed BAM file
-   Generates alignment statistics

### 4. Create BigWig (`bigwig`)

-   Converts BAM to bedGraph using bedtools
-   Converts bedGraph to BigWig for genome browser visualization

### 5. Feature Counting (`counts`)

-   Quantifies gene expression using featureCounts
-   Strand-specific counting (reverse stranded: `-s 2`)
-   Formats output to CSV
-   Creates transcript-to-gene mapping

### 6. Statistical Analysis (`analysis`)

-   Differential expression analysis using edgeR
-   PCA plot generation
-   Heatmap visualization
-   Functional enrichment using g:Profiler

## Directory Structure

```
RNA-seq/
├── refs/              # Reference genome and annotations
├── reads/             # Raw FASTQ files (user-provided)
├── index/             # Genome indices
├── alignments/        # BAM files and alignment stats
├── bigwig/            # BigWig files for visualization
├── counts/            # Gene count matrices
└── results/           # Analysis results (PCA, heatmaps)

```

## Required Input Files

Before running the pipeline, ensure you have:

-   FASTQ files in `RNA-seq/reads/` named as `{SAMPLE}_R1.fq`
-   A `design.csv` file describing your experimental design
-   R scripts in `src/r/` directory:
    -   `format_featurecounts.r`
    -   `create_tx2gene.r`
    -   `edger.r`
    -   `plot_pca.r`
    -   `plot_heatmap.r`

## Output Files

-   `RNA-seq/alignments/{SAMPLE}.bam` - Sorted, indexed BAM file
-   `RNA-seq/alignments/{SAMPLE}_align_stats.txt` - Alignment statistics
-   `RNA-seq/bigwig/{SAMPLE}.bw` - BigWig coverage file
-   `RNA-seq/counts/counts.csv` - Normalized gene counts
-   `RNA-seq/results/pca.pdf` - PCA plot
-   `RNA-seq/results/heatmap.pdf` - Expression heatmap
-   `edger.csv` - Differential expression results

## Notes

-   The pipeline uses chromosome 22 as a test dataset
-   Alignment is single-end by default (only _R1 files)
-   Feature counting assumes reverse-stranded library prep (`-s 2`)
-   All steps check for existing output to avoid redundant processing
