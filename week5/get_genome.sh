set -uexo 
ACC=GCA_000013425.1
GENBANK_ACC=NC_007793.1

##Get the genome 
efetch -db nuccore -format fasta -id $GENBANK_ACC > $GENBANK_ACC.fa

##Annother way to get the genome
bio fetch $ACC -format fasta > $ACC.fa

##Get the annotation
efetch -db nuccore -format gff -id $ACC > $ACC.gff

