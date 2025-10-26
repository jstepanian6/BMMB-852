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
ACC = NC_007793.1

# SRR number (for downloading reads)
SRR = SRR21835896

# Sample name (for output files)
SAMPLE = sample1

# Amount of reads to download
N = 137931

#----- Derived Paths -----

# Reference genome directory and file
REF_DIR = refs
REF = ${REF_DIR}/${ACC}.fa

# Reads directory
READS_DIR = reads
R1 = ${READS_DIR}/${SRR}_1.fastq
R2 = ${READS_DIR}/${SRR}_2.fastq

# BAM directory and files (named by sample)
BAM_DIR = bam
BAM = ${BAM_DIR}/${SAMPLE}.bam

# Coverage files (named by sample)
BG = ${BAM_DIR}/${SAMPLE}.bedgraph
BW = ${BAM_DIR}/${SAMPLE}.bw

#----- Phony Targets -----

.PHONY: usage genome sample fastq align stats coverage clean clean-all

#----- Usage -----

usage:
	@echo "#"
	@echo "# RNA-seq Alignment Pipeline"
	@echo "#"
	@echo "# Step 1: Prepare genome (run once)"
	@echo "#   make genome ACC=NC_007793.1"
	@echo "#"
	@echo "# Step 2: Process a single sample"
	@echo "#   make sample SRR=SRR21835896 SAMPLE=sample1"
	@echo "#"
	@echo "# Step 3: Parallelize multiple samples"
	@echo "#   cat design.csv | parallel -j 4 --colsep , --header : 'make sample SRR={srr_id} SAMPLE={Sample}'"
	@echo "#"
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

#----- Genome Preparation (Run Once) -----

# Prepare the reference genome: download and index
genome: ${REF} ${REF}.bwt

# Download the reference genome
${REF}:
	@echo "Downloading reference genome ${ACC}..."
	mkdir -p ${REF_DIR}
	bio fetch ${ACC} --format fasta > ${REF}
	seqkit stats ${REF}

# Index the reference genome with BWA and samtools
${REF}.bwt: ${REF}
	@echo "Indexing reference genome..."
	bwa index ${REF}
	samtools faidx ${REF}
	@echo "Genome preparation complete!"

#----- Sample Processing (Parallelizable) -----

# Process a complete sample: download reads, align, generate stats and coverage
sample: ${BW} stats
	@echo "Sample ${SAMPLE} processing complete!"

# Download reads from SRA
fastq: ${R1}

${R1}:
	@echo "Downloading reads for ${SRR}..."
	mkdir -p ${READS_DIR}
	fastq-dump -X ${N} --outdir ${READS_DIR} --split-files ${SRR}
	seqkit stats ${READS_DIR}/${SRR}*.fastq

# Align reads and generate BAM file
align: ${BAM}

${BAM}: ${R1} ${REF}.bwt
	@echo "Aligning ${SRR} (sample: ${SAMPLE})..."
	mkdir -p ${BAM_DIR}
	bwa mem -t 4 ${REF} ${R1} ${R2} | samtools sort > ${BAM}
	samtools index ${BAM}
	@echo "Alignment complete: ${BAM}"

# Generate alignment statistics
stats: ${BAM}
	@echo "Alignment statistics for ${SAMPLE}:"
	samtools flagstat ${BAM}
	@echo ""
	samtools coverage ${BAM}

# Generate coverage files
coverage: ${BW}

${BW}: ${BAM}
	@echo "Generating coverage files for ${SAMPLE}..."
	mkdir -p ${BAM_DIR}
	LC_ALL=C; bedtools genomecov -ibam ${BAM} -split -bg | sort -k1,1 -k2,2n > ${BG}
	bedGraphToBigWig ${BG} ${REF}.fai ${BW}
	@echo "Coverage files generated: ${BG}, ${BW}"

#----- Cleanup -----

# Remove sample-specific files
clean:
	@echo "Cleaning sample ${SAMPLE} files..."
	rm -f ${R1} ${R2} ${BAM} ${BAM}.bai ${BG} ${BW}

# Remove all generated files including genome
clean-all:
	@echo "Removing all generated files..."
	rm -rf ${REF_DIR} ${READS_DIR} ${BAM_DIR}