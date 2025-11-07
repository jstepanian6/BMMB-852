# Week 11: Establish the effects of variants
This guide focuses on annotating variants using SnpEff from variant calling process. The pipeline provides two annotation targets:

- annotate: Annotate variants for a single sample
-   annotate-multi: Annotate a merged multisample VCF file
First we need to install and set up snpEff using the following commands: 

    '''
    conda install -c bioconda snpeff
    snpEff databases | grep -i "aureus" | grep -i "usa300"
    snpEff download Staphylococcus_aureus_subsp_aureus_usa300_fpr3757
    cp /home/jstepanian/micromamba/envs/snpEff/share/snpeff-5.3.0a-1/snpEff.config .

    '''

Then, we need to perform variant calling as it was described and explained in the previous weeks using the makefile and the following commands: 

    make genome
    make sample SRR=SRR21835896 SAMPLE=sample1
And finally, for annotating variants we will use 

    make annotate SAMPLE=sample1
**What does this command do?**

1.  Takes the compressed VCF file (`vcf/sample1.vcf.gz`)
2.  Decompresses it and runs SnpEff annotation
3.  Generates three output files:
    -   **Annotated VCF**: `vcf/sample1_annotated.vcf`
    -   **HTML Report**: `vcf/sample1_annotated.html`
    -   **Genes File**: `vcf/sample1_annotated.genes.txt`

### Output Files

-   **`sample1_annotated.vcf`**: VCF file with added annotation fields (ANN) describing variant effects, impact, gene names, and functional consequences
-   **`sample1_annotated.html`**: Interactive HTML report with summary statistics, charts showing variant types, effects by region, and impact categories
-   **`sample1_annotated.genes.txt`**: Tab-delimited file listing genes affected by variants with counts of different variant types per gene

