# RNA-seq Alignment Pipeline Makefile
# Separates genome preparation from sample processing for efficient parallelization

# Set the shell the commands run in.
SHELL = bash

# Execute all commands in a single shell.
.ONESHELL:

# Run the shell with strict error checking.
.SHELLFLAGS = -eu -o pipefail -c

# Delete target files if the command fails.
.DELETE_ON_ERROR:

# Warn if a variable is not defined.
MAKEFLAGS += --warn-undefined-variables

# Disable built-in rules.
MAKEFLAGS += --no-builtin-rules

#----- Configuration Variables -----

# Genbank accession for the reference genome 
# Dataset RNA-seq
RNADATA = http://data.biostarhandbook.com/data/uhr-hbr.tar.gz
#----- Derived Paths -----

# Design file	
DESIGN = design.csv

# Reference genome directory and file
REF_DIR = refs
REF = ${REF_DIR}/*.fa

# Reads directory
READS_DIR = reads
R1 = ${READS_DIR}/${sample}_R1.fastq
R2 = ${READS_DIR}/${sample}_R2.fastq

# BAM directory and files (named by sample)
BAM_DIR = bam
BAM = ${BAM_DIR}/${SAMPLE}.bam

#----- Phony Targets -----

.PHONY: usage genome sample fastq align stats coverage clean clean-all

#----- Usage -----

usage:
	@echo "#"
	@echo "# RNA-seq Alignment Pipeline"
	@echo "#"
	@echo "# Step 1: Get rna data"
	@echo "#   make get_rna_data "
	@echo "#"
	@echo "# Step 2: Create stats for reference genome and reads"
	@echo "#   make ref_stats"
	@echo "#   make reads_stats"
	@echo "#"
	@echo "# Step 3: Index reference genome (run once)"
	@echo "#   make index_ref"
	@echo "#"
	@echo "# Step 4: Map RNA-seq reads to genome"
	@echo "#   make map_rna
	@echo "# cat design.csv | parallel -j 4 --colsep , --header : 'make map_rna  sample={sample}'"
	@echo "# Step 4: Process samples (map reads to genome)"
	@echo "# Available targets:"
	@echo "#   genome   - Download and index reference genome (run once)"
	@echo "#   sample   - Process complete sample: download, align, stats, coverage"
	@echo "#   fastq    - Download reads for a sample"
	@echo "#   align    - Align reads to genome"
	@echo "#   stats    - Generate alignment statistics"
	@echo "#   coverage - Generate coverage files (bedgraph and bigwig)"
	@echo "#   clean    - Remove sample-specific files"
	@echo "#   clean-all - Remove all generated files including genome"
	@echo "#"

all: get_rna_data ref_stats index_ref map_rna
#---- Get data RNA-seq ----
get_rna_data:
	wget -nc ${RNADATA}
	tar -xvzf uhr-hbr.tar.gz
	rm uhr-hbr.tar.gz
#--- Stats over reference genome  and reads ----
ref_stats: genome
	seqkit stats ${REF}
reads_stats: fastq
	seqkit stats ${READS_DIR}/*.fq	
# ----- Index reference genome for RNA-seq -----
index_ref: genome
	make -f ~/src/run/hisat2.mk index REF=${REF}

#----- Mapping RNA-seq reads ----- #TODO
map_rna: index_ref fastq
	@echo "Starting RNA-seq mapping for all samples..."
	# Read the design file and process each sample
	make -f ~/src/run/hisat2.mk align \
			REF=${REF} \
			R1=reads/${sample}_R1.fq \
			R2=reads/${sample}_R2.fq \
			BAM=bam/${sample}.bam \
			run
		
		echo "Completed processing ${sample}"
		echo "----------------------------------------"
	done
#----- Create gene count matrix -----
gene_counts: map_rna
	featureCounts -a ${REF_DIR}/*.gtf -o counts.csv ${BAM_DIR}/*.bam

#----- RNA-seq differential expression analysis -----
diff_expression: gene_counts
	Rscript ~/src/r/edge.r -c counts.csv -d ${DESIGN} 
	
#----- Cleanup -----

# Remove sample-specific files
clean:
	@echo "Cleaning sample ${SAMPLE} files..."
	rm -f ${R1} ${R2} ${BAM} ${BAM}.bai ${BG} ${BW}

# Remove all generated files including genome
clean-all:
	@echo "Removing all generated files..."
	rm -rf ${REF_DIR} ${READS_DIR} ${BAM_DIR}