# RNA-seq Alignment and Variant Calling Pipeline Makefile
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
GFF = ${REF_DIR}/${ACC}.gff

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

# Variant call files
VCF_DIR = vcf
VCF = ${VCF_DIR}/${SAMPLE}.vcf.gz
MULTI_VCF = ${VCF_DIR}/multisample.vcf.gz

# SnpEff files
SNPEFF_CONFIG = snpEff.config
SNPEFF_DATA_DIR = data
SNPEFF_DB = Staphylococcus_aureus_subsp_aureus_usa300_fpr3757
ANNOTATED_VCF = ${VCF_DIR}/${SAMPLE}_annotated.vcf
ANNOTATED_HTML = ${VCF_DIR}/${SAMPLE}_annotated.html
ANNOTATED_GENES = ${VCF_DIR}/${SAMPLE}_annotated.genes.txt
MULTI_ANNOTATED_VCF = ${VCF_DIR}/multisample_annotated.vcf

#----- Phony Targets -----

.PHONY: usage genome sample fastq align stats coverage variants clean clean-all merge-vcf

#----- Usage -----

usage:
	@echo "#"
	@echo "# RNA-seq Alignment and Variant Calling Pipeline"
	@echo "#"
	@echo "# Step 1: Prepare genome (run once)"
	@echo "#   make genome ACC=NC_007793.1"
	@echo "#"
	@echo "# Step 2: Process a single sample with variant calling"
	@echo "#   make sample SRR=SRR21835896 SAMPLE=sample1"
	@echo "#"
	@echo "# Step 3: Call variants for a single sample"
	@echo "#   make variants SAMPLE=sample1"
	@echo "#"
	@echo "# Step 4: Process all samples in parallel"
	@echo "#   cat design.csv | parallel -j 4 --colsep , --header : 'make sample SRR={srr_id} SAMPLE={sample}'"
	@echo "#"
	@echo "# Step 5: Merge all VCF files into multisample VCF"
	@echo "#   make merge-vcf"
	@echo "#"
	@echo "# Available targets:"
	@echo "#   genome     - Download and index reference genome (run once)"
	@echo "#   sample     - Process complete sample: download, align, stats, coverage, variants"
	@echo "#   fastq      - Download reads for a sample"
	@echo "#   align      - Align reads to genome"
	@echo "#   stats      - Generate alignment statistics"
	@echo "#   coverage   - Generate coverage files (bedgraph and bigwig)"
	@echo "#   variants   - Call variants for a sample"
	@echo "#   merge-vcf  - Merge all individual VCF files into multisample VCF"
	@echo "#   clean      - Remove sample-specific files"
	@echo "#   clean-all  - Remove all generated files including genome"
	@echo "#"

#----- Genome Preparation (Run Once) -----

# Prepare the reference genome: download and index
genome: ${REF} ${REF}.bwt ${GFF}

# Download the reference genome
${REF}:
	@echo "Downloading reference genome ${ACC}..."
	mkdir -p ${REF_DIR}
	bio fetch ${ACC} --format fasta > ${REF}
	seqkit stats ${REF}

# Download the GFF annotation file
${GFF}:
	@echo "Downloading GFF annotation for ${ACC}..."
	mkdir -p ${REF_DIR}
	bio fetch ${ACC} --format gff > ${GFF}
	@echo "GFF file downloaded: ${GFF}"

# Index the reference genome with BWA and samtools
${REF}.bwt: ${REF}
	@echo "Indexing reference genome..."
	bwa index ${REF}
	samtools faidx ${REF}
	@echo "Genome preparation complete!"

#----- Sample Processing (Parallelizable) -----

# Process a complete sample: download reads, align, generate stats, coverage, and call variants
sample: ${VCF} ${BW} stats
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

#----- Variant Calling -----

# Flags for the mpileup command
F1 = -d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'

# Flags for the call command
F2 = --ploidy 2 --annotate 'FORMAT/GQ'

# Call variants for a single sample
variants: ${VCF}

${VCF}: ${BAM} ${REF}
	@echo "Calling variants for ${SAMPLE}..."
	mkdir -p ${VCF_DIR}
	bcftools mpileup ${F1} -O u -f ${REF} ${BAM} | \
	bcftools call ${F2} -mv -O u | \
	bcftools norm -f ${REF} -d all -O u | \
	bcftools sort -O z > ${VCF}
	bcftools index ${VCF}
	@echo "Variant calling complete: ${VCF}"
	@echo "Variant summary:"
	bcftools stats ${VCF} | grep "number of SNPs:"
	bcftools stats ${VCF} | grep "number of indels:"
# Annotate variants for a single sample using SnpEff


annotate: ${ANNOTATED_VCF}

${ANNOTATED_VCF}: ${VCF} ${SNPEFF_CONFIG} ${SNPEFF_DATA_DIR}/${SNPEFF_DB}/snpEffectPredictor.bin
	@echo "Annotating variants for ${SAMPLE}..."
	mkdir -p ${VCF_DIR}
	# Decompress VCF for SnpEff (it expects uncompressed VCF)
	bcftools view ${VCF} | \
	snpEff -c ${SNPEFF_CONFIG} -stats ${ANNOTATED_HTML} ${SNPEFF_DB} > ${ANNOTATED_VCF}
	@echo "Variant annotation complete!"
	@echo "Output files:"
	@echo "  - Annotated VCF: ${ANNOTATED_VCF}"
	@echo "  - HTML report: ${ANNOTATED_HTML}"
	@echo "  - Genes file: ${ANNOTATED_GENES}"


#----- Multi-sample VCF -----

# Merge all individual VCF files into a multisample VCF
merge-vcf: ${MULTI_VCF}

${MULTI_VCF}:
	@echo "Merging individual VCF files into multisample VCF..."
	mkdir -p ${VCF_DIR}
	bcftools merge -O z ${VCF_DIR}/*.vcf.gz -o ${MULTI_VCF}
	bcftools index ${MULTI_VCF}
	@echo "Multisample VCF created: ${MULTI_VCF}"
	@echo "Summary:"
	bcftools stats ${MULTI_VCF} | grep "number of samples:"
	bcftools stats ${MULTI_VCF} | grep "number of SNPs:"
	bcftools stats ${MULTI_VCF} | grep "number of indels:"

# Variant annotation 
annotate-multi: ${MULTI_ANNOTATED_VCF}

${MULTI_ANNOTATED_VCF}: ${MULTI_VCF} ${SNPEFF_CONFIG} ${SNPEFF_DATA_DIR}/${SNPEFF_DB}/snpEffectPredictor.bin
	@echo "Annotating multisample VCF..."
	bcftools view ${MULTI_VCF} | \
	snpEff -c ${SNPEFF_CONFIG} -stats ${VCF_DIR}/multisample_annotated.html ${SNPEFF_DB} > ${MULTI_ANNOTATED_VCF}
	@echo "Multisample annotation complete: ${MULTI_ANNOTATED_VCF}"

#----- Cleanup -----

# Remove sample-specific files
clean:
	@echo "Cleaning sample ${SAMPLE} files..."
	rm -f ${R1} ${R2} ${BAM} ${BAM}.bai ${BG} ${BW} ${VCF} ${VCF}.csi

# Remove all generated files including genome
clean-all:
	@echo "Removing all generated files..."
	rm -rf ${REF_DIR} ${READS_DIR} ${BAM_DIR} ${VCF_DIR}