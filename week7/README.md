# Week 7 
This is the README file for assignment number 7. Reusing code described in [week6](https://github.com/jstepanian6/BMMB-852/tree/main/week6). 

## Diferences between alignment files 

I used two *S. aureus* accessions, one coming from Illumina sequencing (SRR21835896) and the other one coming from Nanopore GridION tecnology (SRR33300097). 
Illumina had 275338 primary mapped reads (99.81%). 
Nanopore reads had only 4408 primary mapped reads (88.16%). 
The amount of reads was expected considering that nanopore outputs longer reads, but the lower quality on the alignment can be due to contamination or even sequencing errors. 
## Larger coordinate observed coverage 
For determining what coordinate has the largest observed coverage (hint samtools depth), I used: 

    samtools depth bam/${BAM}.bam | sort -k3,3nr | head -n 1


Getting as output: 

 - SRR21835896 (Illumina): NC_007793.1	2500332	27272
 - SRR33300097 (Nanopore): NC_007793.1	168868	63

## Gene of interest 
I selected *dnaA* as  a gene of interest due to it encodes the DnaA protein, which is a crucial master regulator of chromosomal DNA replication in bacteria.

    samtools view -c -F 20 bam/{BAM}.bam NC_007793.1:544-1905
Getting as output: 
Illumina SRR21835896: 27
Nanopore SRR33300097: 4
