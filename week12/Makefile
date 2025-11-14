# Cancer Genome in a Bottle Variant Calling and Evaluation Pipeline
# Processes normal and tumor samples to identify tumor-specific variants

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

# Region of interest (default: KRAS gene region, extended to 2Mb)
CHR = chr12
START = 24000000
END = 26000000
REGION = $(CHR):$(START)-$(END)

# Reference genome URLs and paths
REF_URL = https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/references/GRCh38/GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.fasta.gz
REF_DIR = refs
REF_FULL = $(REF_DIR)/GRCh38.fasta.gz
REF = $(REF_DIR)/$(CHR).fasta

# BAM file URLs (HG008 Cancer Genome in a Bottle)
NORMAL_BAM_URL = https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data_somatic/HG008/Liss_lab/Element-AVITI-20241216/HG008-N-D_Element-StdInsert_77x_GRCh38-GIABv3.bam
TUMOR_BAM_URL = https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data_somatic/HG008/Liss_lab/Element-AVITI-20241216/HG008-T_Element-StdInsert_111x_GRCh38-GIABv3.bam

# Gold standard variant calls (DeepVariant)
GOLD_URL = https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data_somatic/HG008/Liss_lab/analysis/Ultima_DeepVariant-somatic-SNV-INDEL_20240822/HG008_edv_AF_recalibration.result.PASS.vcf.gz

# Sample names
NORMAL = normal
TUMOR = tumor

# Directory structure
BAM_DIR = bam
VCF_DIR = vcf
EVAL_DIR = eval
REPORT_DIR = reports

# BAM files
NORMAL_BAM = $(BAM_DIR)/$(NORMAL).bam
TUMOR_BAM = $(BAM_DIR)/$(TUMOR).bam

# VCF files
NORMAL_VCF = $(VCF_DIR)/$(NORMAL).vcf.gz
TUMOR_VCF = $(VCF_DIR)/$(TUMOR).vcf.gz
MERGED_VCF = $(VCF_DIR)/merged.vcf.gz
GOLD_VCF = $(VCF_DIR)/gold_standard.vcf.gz

# Filtered VCF files
TUMOR_FILTERED_VCF = $(VCF_DIR)/$(TUMOR).filtered.vcf.gz

# Intersection directory and files
ISEC_DIR = $(EVAL_DIR)/isec
NORMAL_ONLY_VCF = $(EVAL_DIR)/normal_only.vcf.gz
TUMOR_ONLY_VCF = $(EVAL_DIR)/tumor_only.vcf.gz
SHARED_VCF = $(EVAL_DIR)/shared.vcf.gz

# Comparison with gold standard
GOLD_ISEC_DIR = $(EVAL_DIR)/gold_isec
TRUE_POSITIVES_VCF = $(EVAL_DIR)/true_positives.vcf.gz
FALSE_POSITIVES_VCF = $(EVAL_DIR)/false_positives.vcf.gz
FALSE_NEGATIVES_VCF = $(EVAL_DIR)/false_negatives.vcf.gz

# Report file
REPORT = $(REPORT_DIR)/variant_analysis_report.txt

# Variant calling parameters
F1 = -d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'
F2 = --ploidy 2 --annotate 'FORMAT/GQ'

#----- Phony Targets -----

.PHONY: usage all genome bam vcf evaluate filter compare report clean clean-all

#----- Usage -----

usage:
	@echo "#"
	@echo "# Cancer Genome Variant Calling and Evaluation Pipeline"
	@echo "#"
	@echo "# Complete workflow:"
	@echo "#   make all                  - Run entire pipeline (genome -> vcf -> evaluate -> report)"
	@echo "#"
	@echo "# Step-by-step:"
	@echo "#   make genome               - Download and prepare reference genome"
	@echo "#   make bam                  - Download normal and tumor BAM files for region"
	@echo "#   make vcf                  - Call variants for both samples"
	@echo "#   make evaluate             - Identify tumor-specific variants"
	@echo "#   make filter               - Apply quality filters to tumor variants"
	@echo "#   make compare              - Compare with gold standard DeepVariant calls"
	@echo "#   make report               - Generate comprehensive analysis report"
	@echo "#"
	@echo "# Configuration (override with make VAR=value):"
	@echo "#   REGION=$(REGION)  - Region of interest"
	@echo "#   CHR=$(CHR)                      - Chromosome"
	@echo "#   START=$(START)                - Start position"
	@echo "#   END=$(END)                  - End position"
	@echo "#"
	@echo "# Cleanup:"
	@echo "#   make clean                - Remove analysis files (keep genome and BAM)"
	@echo "#   make clean-all            - Remove all generated files"
	@echo "#"

#----- Complete Pipeline -----

all: report
	@echo ""
	@echo "======================================"
	@echo "Pipeline complete!"
	@echo "======================================"
	@echo "Report available at: $(REPORT)"
	@echo ""

#----- Genome Preparation -----

genome: $(REF) $(REF).fai
	@echo "Genome preparation complete for $(CHR)"

$(REF_FULL):
	@echo "Downloading full reference genome..."
	mkdir -p $(REF_DIR)
	curl -L $(REF_URL) > $(REF_FULL)

$(REF): $(REF_FULL)
	@echo "Extracting chromosome $(CHR)..."
	samtools faidx $(REF_FULL) $(CHR) > $(REF)
	@echo "Chromosome extraction complete"

$(REF).fai: $(REF)
	@echo "Indexing reference genome..."
	samtools faidx $(REF)

#----- BAM File Download -----

bam: $(NORMAL_BAM) $(TUMOR_BAM)
	@echo "BAM files ready for analysis"

$(NORMAL_BAM):
	@echo "Downloading normal sample BAM for region $(REGION)..."
	mkdir -p $(BAM_DIR)
	samtools view -b $(NORMAL_BAM_URL) $(REGION) > $(NORMAL_BAM)
	samtools index $(NORMAL_BAM)
	@echo "Normal BAM statistics:"
	samtools flagstat $(NORMAL_BAM)
	samtools coverage $(NORMAL_BAM)

$(TUMOR_BAM):
	@echo "Downloading tumor sample BAM for region $(REGION)..."
	mkdir -p $(BAM_DIR)
	samtools view -b $(TUMOR_BAM_URL) $(REGION) > $(TUMOR_BAM)
	samtools index $(TUMOR_BAM)
	@echo "Tumor BAM statistics:"
	samtools flagstat $(TUMOR_BAM)
	samtools coverage $(TUMOR_BAM)

#----- Variant Calling -----

vcf: $(NORMAL_VCF) $(TUMOR_VCF) $(MERGED_VCF)
	@echo "Variant calling complete for both samples"

$(NORMAL_VCF): $(NORMAL_BAM) $(REF)
	@echo "Calling variants for normal sample..."
	mkdir -p $(VCF_DIR)
	bcftools mpileup $(F1) -O u -f $(REF) $(NORMAL_BAM) | \
	bcftools call $(F2) -mv -O u | \
	bcftools norm -f $(REF) -d all -O u | \
	bcftools sort -O z > $(NORMAL_VCF)
	bcftools index $(NORMAL_VCF)
	@echo "Normal variant calling complete"
	@echo "Summary:"
	bcftools stats $(NORMAL_VCF) | grep "number of"

$(TUMOR_VCF): $(TUMOR_BAM) $(REF)
	@echo "Calling variants for tumor sample..."
	mkdir -p $(VCF_DIR)
	bcftools mpileup $(F1) -O u -f $(REF) $(TUMOR_BAM) | \
	bcftools call $(F2) -mv -O u | \
	bcftools norm -f $(REF) -d all -O u | \
	bcftools sort -O z > $(TUMOR_VCF)
	bcftools index $(TUMOR_VCF)
	@echo "Tumor variant calling complete"
	@echo "Summary:"
	bcftools stats $(TUMOR_VCF) | grep "number of"

$(MERGED_VCF): $(NORMAL_VCF) $(TUMOR_VCF)
	@echo "Merging normal and tumor VCF files..."
	bcftools merge -O z -o $(MERGED_VCF) $(NORMAL_VCF) $(TUMOR_VCF)
	bcftools index $(MERGED_VCF)
	@echo "Merged VCF created: $(MERGED_VCF)"

#----- Variant Evaluation -----

evaluate: $(TUMOR_ONLY_VCF) $(NORMAL_ONLY_VCF) $(SHARED_VCF)
	@echo "Variant evaluation complete"
	@echo ""
	@echo "Results:"
	@echo "  Normal-only variants: $(NORMAL_ONLY_VCF)"
	@echo "  Tumor-specific variants: $(TUMOR_ONLY_VCF)"
	@echo "  Shared variants: $(SHARED_VCF)"

$(TUMOR_ONLY_VCF): $(NORMAL_VCF) $(TUMOR_VCF)
	@echo "Identifying tumor-specific variants..."
	mkdir -p $(EVAL_DIR) $(ISEC_DIR)
	bcftools isec -p $(ISEC_DIR) $(NORMAL_VCF) $(TUMOR_VCF)
	bcftools view -O z -o $(NORMAL_ONLY_VCF) $(ISEC_DIR)/0000.vcf
	bcftools view -O z -o $(TUMOR_ONLY_VCF) $(ISEC_DIR)/0001.vcf
	bcftools view -O z -o $(SHARED_VCF) $(ISEC_DIR)/0002.vcf
	bcftools index $(NORMAL_ONLY_VCF)
	bcftools index $(TUMOR_ONLY_VCF)
	bcftools index $(SHARED_VCF)
	@echo "Intersection analysis complete"

#----- Variant Filtering -----

filter: $(TUMOR_FILTERED_VCF)
	@echo "Filtering complete"
	@echo "Filtered tumor variants: $(TUMOR_FILTERED_VCF)"

$(TUMOR_FILTERED_VCF): $(TUMOR_ONLY_VCF)
	@echo "Applying quality filters to tumor-specific variants..."
	@echo "Filters: SNPs only, max 2 alleles, quality >= 20"
	bcftools view \
		--max-alleles 2 \
		--types snps \
		--min-ac 1 \
		-i 'QUAL>=20' \
		-O z \
		-o $(TUMOR_FILTERED_VCF) \
		$(TUMOR_ONLY_VCF)
	bcftools index $(TUMOR_FILTERED_VCF)
	@echo "Filtering complete"
	@echo "Filtered variant count:"
	bcftools stats $(TUMOR_FILTERED_VCF) | grep "number of SNPs:"

#----- Gold Standard Comparison -----

compare: $(TRUE_POSITIVES_VCF) $(FALSE_POSITIVES_VCF) $(FALSE_NEGATIVES_VCF)
	@echo "Comparison with gold standard complete"

$(GOLD_VCF):
	@echo "Downloading gold standard DeepVariant calls..."
	mkdir -p $(VCF_DIR)
	curl -L $(GOLD_URL) > $(GOLD_VCF)
	bcftools index $(GOLD_VCF)
	@echo "Gold standard downloaded and filtered for region"
	@echo "Gold standard variant count:"
	bcftools stats $(GOLD_VCF) | grep "number of SNPs:"

$(TRUE_POSITIVES_VCF): $(TUMOR_FILTERED_VCF) $(GOLD_VCF)
	@echo "Comparing tumor variants with gold standard..."
	mkdir -p $(GOLD_ISEC_DIR)
	bcftools isec -p $(GOLD_ISEC_DIR) $(TUMOR_FILTERED_VCF) $(GOLD_VCF)
	# 0000.vcf = variants in tumor only (false positives)
	# 0001.vcf = variants in gold only (false negatives)
	# 0002.vcf = variants in both (true positives)
	bcftools view -O z -o $(FALSE_POSITIVES_VCF) $(GOLD_ISEC_DIR)/0000.vcf
	bcftools view -O z -o $(FALSE_NEGATIVES_VCF) $(GOLD_ISEC_DIR)/0001.vcf
	bcftools view -O z -o $(TRUE_POSITIVES_VCF) $(GOLD_ISEC_DIR)/0002.vcf
	bcftools index $(FALSE_POSITIVES_VCF)
	bcftools index $(FALSE_NEGATIVES_VCF)
	bcftools index $(TRUE_POSITIVES_VCF)
	@echo "Gold standard comparison complete"

#----- Report Generation -----

report: $(REPORT)

$(REPORT): $(TUMOR_ONLY_VCF) $(TUMOR_FILTERED_VCF) $(TRUE_POSITIVES_VCF)
	@echo "Generating comprehensive analysis report..."
	mkdir -p $(REPORT_DIR)
	{
		echo "=========================================="
		echo "Cancer Genome Variant Analysis Report"
		echo "=========================================="
		echo ""
		echo "Analysis Date: $$(date)"
		echo "Region of Interest: $(REGION)"
		echo "Chromosome: $(CHR)"
		echo "Start Position: $(START)"
		echo "End Position: $(END)"
		echo "Region Size: $$(( $(END) - $(START) )) bp"
		echo ""
		echo "=========================================="
		echo "1. SAMPLE INFORMATION"
		echo "=========================================="
		echo ""
		echo "Normal Sample: $(NORMAL)"
		if [ -f "$(NORMAL_BAM)" ]; then
			echo "  BAM File: $(NORMAL_BAM)"
			echo "  Alignment Statistics:"
			samtools flagstat $(NORMAL_BAM) | sed 's/^/    /'
			echo ""
			echo "  Coverage:"
			samtools coverage $(NORMAL_BAM) | sed 's/^/    /'
		fi
		echo ""
		echo "Tumor Sample: $(TUMOR)"
		if [ -f "$(TUMOR_BAM)" ]; then
			echo "  BAM File: $(TUMOR_BAM)"
			echo "  Alignment Statistics:"
			samtools flagstat $(TUMOR_BAM) | sed 's/^/    /'
			echo ""
			echo "  Coverage:"
			samtools coverage $(TUMOR_BAM) | sed 's/^/    /'
		fi
		echo ""
		echo "=========================================="
		echo "2. VARIANT CALLING RESULTS"
		echo "=========================================="
		echo ""
		echo "Normal Sample Variants:"
		if [ -f "$(NORMAL_VCF)" ]; then
			bcftools stats $(NORMAL_VCF) | grep "^SN" | sed 's/^SN\t/  /'
		fi
		echo ""
		echo "Tumor Sample Variants:"
		if [ -f "$(TUMOR_VCF)" ]; then
			bcftools stats $(TUMOR_VCF) | grep "^SN" | sed 's/^SN\t/  /'
		fi
		echo ""
		echo "=========================================="
		echo "3. TUMOR-SPECIFIC VARIANTS"
		echo "=========================================="
		echo ""
		echo "Variants unique to normal: $$(bcftools view -H $(NORMAL_ONLY_VCF) 2>/dev/null | wc -l || echo 0)"
		echo "Variants unique to tumor (unfiltered): $$(bcftools view -H $(TUMOR_ONLY_VCF) 2>/dev/null | wc -l || echo 0)"
		echo "Variants shared between normal and tumor: $$(bcftools view -H $(SHARED_VCF) 2>/dev/null | wc -l || echo 0)"
		echo ""
		echo "Tumor-specific variants (after quality filtering):"
		if [ -f "$(TUMOR_FILTERED_VCF)" ]; then
			bcftools stats $(TUMOR_FILTERED_VCF) | grep "^SN" | sed 's/^SN\t/  /' || true
			echo ""
			VARIANT_COUNT=$(bcftools view -H $(TUMOR_FILTERED_VCF) | wc -l)
			if [ $VARIANT_COUNT -gt 0 ]; then
				echo "Top 10 tumor-specific variants:"
				echo "  CHROM	POSITION	REF	ALT	QUAL	DEPTH"
				bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%INFO/DP\n' $(TUMOR_FILTERED_VCF) | head -10 | sed 's/^/  /' || true
			else
				echo "No variants passed quality filters"
			fi
		fi
		echo ""
		echo "=========================================="
		echo "4. GOLD STANDARD COMPARISON"
		echo "=========================================="
		echo ""
		if [ -f "$(GOLD_VCF)" ]; then
			echo "Gold Standard (DeepVariant) Variants in Region:"
			bcftools stats $(GOLD_VCF) | grep "^SN" | sed 's/^SN\t/  /'
			echo ""
		fi
		if [ -f "$(TRUE_POSITIVES_VCF)" ]; then
			TP=$$(bcftools view -H $(TRUE_POSITIVES_VCF) 2>/dev/null | wc -l || echo 0)
			FP=$$(bcftools view -H $(FALSE_POSITIVES_VCF) 2>/dev/null | wc -l || echo 0)
			FN=$$(bcftools view -H $(FALSE_NEGATIVES_VCF) 2>/dev/null | wc -l || echo 0)
			echo "Performance Metrics:"
			echo "  True Positives (TP): $$TP"
			echo "  False Positives (FP): $$FP"
			echo "  False Negatives (FN): $$FN"
			echo ""
			if [ $$((TP + FP)) -gt 0 ]; then
				PRECISION=$$(awk "BEGIN {printf \"%.2f\", 100 * $$TP / ($$TP + $$FP)}")
				echo "  Precision: $$PRECISION%"
			fi
			if [ $$((TP + FN)) -gt 0 ]; then
				RECALL=$$(awk "BEGIN {printf \"%.2f\", 100 * $$TP / ($$TP + $$FN)}")
				echo "  Recall (Sensitivity): $$RECALL%"
			fi
			if [ $$((TP + FP)) -gt 0 ] && [ $$((TP + FN)) -gt 0 ]; then
				PRECISION=$$(awk "BEGIN {print $$TP / ($$TP + $$FP)}")
				RECALL=$$(awk "BEGIN {print $$TP / ($$TP + $$FN)}")
				F1=$$(awk "BEGIN {printf \"%.2f\", 200 * $$PRECISION * $$RECALL / ($$PRECISION + $$RECALL)}")
				echo "  F1 Score: $$F1%"
			fi
			echo ""
			echo "False Positives (variants called but not in gold standard):"
			echo "  Count: $FP"
			if [ $FP -gt 0 ]; then
				echo "  Examples (first 5):"
				bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\n' $(FALSE_POSITIVES_VCF) | head -5 | sed 's/^/    /' || true
			fi
			echo ""
			echo "False Negatives (variants in gold standard but not called):"
			echo "  Count: $FN"
			if [ $FN -gt 0 ]; then
				echo "  Examples (first 5):"
				bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' $(FALSE_NEGATIVES_VCF) | head -5 | sed 's/^/    /' || true
			fi
		else
			echo "Gold standard comparison not available."
			echo "Run 'make compare' to perform comparison with DeepVariant calls."
		fi
		echo ""
		echo "=========================================="
		echo "5. OUTPUT FILES"
		echo "=========================================="
		echo ""
		echo "Reference Genome:"
		echo "  $(REF)"
		echo ""
		echo "BAM Files:"
		echo "  Normal: $(NORMAL_BAM)"
		echo "  Tumor: $(TUMOR_BAM)"
		echo ""
		echo "VCF Files:"
		echo "  Normal variants: $(NORMAL_VCF)"
		echo "  Tumor variants: $(TUMOR_VCF)"
		echo "  Merged: $(MERGED_VCF)"
		echo ""
		echo "Analysis Results:"
		echo "  Normal-only: $(NORMAL_ONLY_VCF)"
		echo "  Tumor-specific (unfiltered): $(TUMOR_ONLY_VCF)"
		echo "  Tumor-specific (filtered): $(TUMOR_FILTERED_VCF)"
		echo "  Shared variants: $(SHARED_VCF)"
		echo ""
		echo "Gold Standard Comparison:"
		echo "  Gold standard: $(GOLD_VCF)"
		echo "  True positives: $(TRUE_POSITIVES_VCF)"
		echo "  False positives: $(FALSE_POSITIVES_VCF)"
		echo "  False negatives: $(FALSE_NEGATIVES_VCF)"
		echo ""
		echo "=========================================="
		echo "6. CONCLUSIONS"
		echo "=========================================="
		echo ""
		echo "This analysis identified tumor-specific variants in the region"
		echo "$(REGION) and compared them against the DeepVariant gold standard."
		echo ""
		echo "Key findings:"
		echo "- Tumor-specific variants represent potential somatic mutations"
		echo "- Quality filtering reduces false positives but may miss low-frequency variants"
		echo "- Comparison with gold standard reveals pipeline performance"
		echo ""
		echo "Next steps:"
		echo "- Examine specific variants of interest (e.g., known cancer genes)"
		echo "- Apply additional filters based on allele frequency, depth, etc."
		echo "- Validate candidate variants through orthogonal methods"
		echo ""
		echo "=========================================="
		echo "Report generated: $$(date)"
		echo "=========================================="
	} > $(REPORT)
	@echo ""
	@echo "Report generated: $(REPORT)"
	@echo ""
	@cat $(REPORT)

#----- Cleanup -----

clean:
	@echo "Cleaning analysis files (keeping genome and BAM files)..."
	rm -rf $(VCF_DIR) $(EVAL_DIR) $(REPORT_DIR)
	@echo "Clean complete"

clean-all:
	@echo "Removing all generated files..."
	rm -rf $(REF_DIR) $(BAM_DIR) $(VCF_DIR) $(EVAL_DIR) $(REPORT_DIR)
	@echo "Clean-all complete"