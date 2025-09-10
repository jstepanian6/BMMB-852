# Week 3 
## Visualizing genome and annotations relative to the genome 
I choose *Acinetobacter baumannii* genome (gca_000069245.ASM6924v1.62). It has 4 fragments: 

    jstepanian@jstepanian ~/Documents/AppliedBioinfo/week3
    $ grep ">" Acinetobacter_baumannii_aye_gca_000069245.ASM6924v1.*fa
    >p1ABAYE dna_sm:plasmid plasmid:ASM6924v1:p1ABAYE:1:5644:1 REF
    >p2ABAYE dna_sm:plasmid plasmid:ASM6924v1:p2ABAYE:1:9661:1 REF
    >p3ABAYE dna_sm:plasmid plasmid:ASM6924v1:p3ABAYE:1:94413:1 REF
    >p4ABAYE dna_sm:plasmid plasmid:ASM6924v1:p4ABAYE:1:2726:1 REF
    >Chromosome dna_sm:chromosome chromosome:ASM6924v1:Chromosome:1:3936291:1 REF
This is also evident in the upper tab in IGV.
<img width="1442" height="900" alt="image" src="https://github.com/user-attachments/assets/ea94bc1e-2d9a-4610-9fc3-65ea4019ed0b" />
<img width="1439" height="900" alt="image" src="https://github.com/user-attachments/assets/cf189d93-3189-4edd-829b-3d616e95f3cd" />



## Genome size and features 
I reused code from the previous assignment 

    jstepanian@jstepanian ~/Documents/AppliedBioinfo/week3
    $ cat *gff3 | cut -f 1 | sort | uniq
Output & Q&A:
	

    #!genebuild-last-updated 2015-02
        #!genome-build Genoscope ASM6924v1
        #!genome-build-accession GCA_000069245.1
        #!genome-version ASM6924v1
        ###
        ##gff-version 3
        ##sequence-region   Chromosome 1 3936291 ### This is the genome size
        ##sequence-region   p1ABAYE 1 5644
        ##sequence-region   p2ABAYE 1 9661
        ##sequence-region   p3ABAYE 1 94413
        ##sequence-region   p4ABAYE 1 2726
        Chromosome
        p1ABAYE
        p2ABAYE
        p3ABAYE
        p4ABAYE
Regarding the features: 

    jstepanian@jstepanian ~/Documents/AppliedBioinfo/week3
    $ cat *gff3 Acinetobacter_baumannii_aye_gca_000069245.ASM6924v1.*gff3 | grep -v "#" | cut -f 3 |  sort | uniq -c 
       7424 CDS
         20 biological_region
          2 chromosome
       7760 exon
       7424 gene
       7424 mRNA
        182 ncRNA_gene
        154 pseudogene
        154 pseudogenic_transcript
         36 rRNA
          8 region
        144 tRNA
          2 tmRNA

## Gene | Transcript separation 

    grep -i -E "gene|transcript" Acinetobacter_baumannii_aye_gca_000069245.ASM6924v1.*gff3 > genes_transcriptsAbaumanii.gff3 

    jstepanian@jstepanian ~/Documents/AppliedBioinfo/week3
    $ head genes_transcriptsAbaumanii.gff3 
    #!genebuild-last-updated 2015-02
    Chromosome	ena	gene	170	1567	.	+	.	ID=gene:ABAYE0001;Name=dnaA;biotype=protein_coding;description=DNA replication initiator protein%2C transcriptional regulator of replication and housekeeping genes;gene_id=ABAYE0001;logic_name=ena
    Chromosome	ena	mRNA	170	1567	.	+	.	ID=transcript:CAM84993;Parent=gene:ABAYE0001;Name=dnaA-1;biotype=protein_coding;tag=Ensembl_canonical;transcript_id=CAM84993
    Chromosome	ena	exon	170	1567	.	+	.	Parent=transcript:CAM84993;Name=CAM84993-1;constitutive=1;ensembl_end_phase=0;ensembl_phase=0;exon_id=CAM84993-1;rank=1
    Chromosome	ena	CDS	170	1567	.	+	0	ID=CDS:CAM84993;Parent=transcript:CAM84993;protein_id=CAM84993
    Chromosome	ena	gene	1665	2813	.	+	.	ID=gene:ABAYE0002;Name=dnaN;biotype=protein_coding;description=DNA polymerase III%2C beta chain;gene_id=ABAYE0002;logic_name=ena
    Chromosome	ena	mRNA	1665	2813	.	+	.	ID=transcript:CAM84994;Parent=gene:ABAYE0002;Name=dnaN-1;biotype=protein_coding;tag=Ensembl_canonical;transcript_id=CAM84994
    Chromosome	ena	exon	1665	2813	.	+	.	Parent=transcript:CAM84994;Name=CAM84994-1;constitutive=1;ensembl_end_phase=0;ensembl_phase=0;exon_id=CAM84994-1;rank=1
    Chromosome	ena	CDS	1665	2813	.	+	0	ID=CDS:CAM84994;Parent=transcript:CAM84994;protein_id=CAM84994
    Chromosome	ena	gene	2828	3910	.	+	.	ID=gene:ABAYE0003;Name=recF;biotype=protein_coding;description=DNA replication%2C recombinaison and repair protein;gene_id=ABAYE0003;logic_name=ena

## Visualize the simplified GFF in IGV as a separate track. Compare the visualization of the original GFF with the simplified GFF.
The main difference is that all the inter-genic regions get "lost" with the filtered gff3 
<img width="1439" height="900" alt="image" src="https://github.com/user-attachments/assets/afa32038-584d-4c7a-8eb9-f72a7d9d354c" />

## Zoom in to see the sequences, expand the view to show the translation table in IGV. Note how the translation table needs to be displayed in the correct orientation for it to make sense.
<img width="1439" height="900" alt="image" src="https://github.com/user-attachments/assets/e9ebf6ef-5e5f-483d-bf04-9e16c030fb61" />

## Visually verify that the first coding sequence of a gene starts with a start codon and that the last coding sequence of a gene ends with a stop codon.
<img width="1439" height="900" alt="image" src="https://github.com/user-attachments/assets/69700ee1-f334-4047-9cc8-bc79d9ba24a0" />
<img width="1439" height="900" alt="image" src="https://github.com/user-attachments/assets/9437b51e-039e-49bf-af96-e2549a93a77d" />


