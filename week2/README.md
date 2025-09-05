# Assignment #2 
## Getting gff files
I used wget command and the link to the gff file 

    wget https://ftp.ensembl.org/pub/current_gff3/homo_sapiens/Homo_sapiens.GRCh38.115.chr.gff3.gz
 
    
The output looks like this: 
```bash
--2025-09-03 14:02:34--  https://ftp.ensembl.org/pub/current_gff3/homo_sapiens/Homo_sapiens.GRCh38.115.chr.gff3.gz
Resolving ftp.ensembl.org (ftp.ensembl.org)... 193.62.193.169
Connecting to ftp.ensembl.org (ftp.ensembl.org)|193.62.193.169|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 83669083 (80M) [application/x-gzip]
Saving to: 'Homo_sapiens.GRCh38.115.chr.gff3.gz'

Homo_sapiens.GRCh38 100%[===================>]  79.79M  4.33MB/s    in 18s     

2025-09-03 14:02:53 (4.44 MB/s) - 'Homo_sapiens.GRCh38.115.chr.gff3.gz' saved [83669083/83669083]

```
## Getting chromosome number
To avoid decompressing this file I'll be using zcat command, for getting the number of chromosomes I used:
```bash
zcat Homo_sapiens.GRCh38.115.chr.gff3.gz | cut -f 1 | sort | uniq
```
That outputs (which, by the way, matches the expectations):

    #!genebuild-last-updated 2025-05
    #!genome-build Genome Reference Consortium GRCh38.p14
    #!genome-build-accession GCA_000001405.29
    #!genome-date 2013-12
    #!genome-version GRCh38
    ###
    ##gff-version 3
    ##sequence-region   1 1 248956422
    ##sequence-region   10 1 133797422
    ##sequence-region   11 1 135086622
    ##sequence-region   12 1 133275309
    ##sequence-region   13 1 114364328
    ##sequence-region   14 1 107043718
    ##sequence-region   15 1 101991189
    ##sequence-region   16 1 90338345
    ##sequence-region   17 1 83257441
    ##sequence-region   18 1 80373285
    ##sequence-region   19 1 58617616
    ##sequence-region   2 1 242193529
    ##sequence-region   20 1 64444167
    ##sequence-region   21 1 46709983
    ##sequence-region   22 1 50818468
    ##sequence-region   3 1 198295559
    ##sequence-region   4 1 190214555
    ##sequence-region   5 1 181538259
    ##sequence-region   6 1 170805979
    ##sequence-region   7 1 159345973
    ##sequence-region   8 1 145138636
    ##sequence-region   9 1 138394717
    ##sequence-region   MT 1 16569
    ##sequence-region   X 1 156040895
    ##sequence-region   Y 1 57227415
    1
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    2
    20
    21
    22
    3
    4
    5
    6
    7
    8
    9
    MT
    X
    Y

## Features count 
I decided to count the lines in the file for determining the amount of features in this file, head was removed using and inverse grep command: 

    zcat Homo_sapiens.GRCh38.115.chr.gff3.gz | grep -v "#" | wc -l
which outputs: 

    7491843
## Gene count
Gene count was based on getting the info of column 3, then looking for genes, sorting them and getting only unique values 

    zcat Homo_sapiens.GRCh38.115.chr.gff3.gz | cut -f 3 | grep gene | sort | uniq -c
The output goes like:  

     1 #!genebuild-last-updated 2025-05
     29 C_gene_segment
     42 D_gene_segment
     97 J_gene_segment
    253 V_gene_segment
    21547 gene
    41946 ncRNA_gene
    15198 pseudogene
Meaning that humans have 21,547 genes. 

## Feature 
Is there a feature type that you may have not heard about before? What is the feature and how is it defined? (If there is no such feature, pick a common feature.)
J gene segment: a short stretch of DNA that recognizes an antigen (joining) that plays a role in VDJ recombination, a process by which T cells and B cells randomly assemble different gene-segments-known as variable (V), diversity (D) and joining (J) genes.  
## Top ten most annotated feature types (column 3) 

    $ zcat Homo_sapiens.GRCh38.115.chr.gff3.gz | cut -f 3 | grep gene | sort | uniq -c | sort 
          1 #!genebuild-last-updated 2025-05
         29 C_gene_segment
         42 D_gene_segment
         97 J_gene_segment
        253 V_gene_segment
      15198 pseudogene
      21547 gene
      41946 ncRNA_gene

## Is a complete and well-annotated organism?
Is one of the most complete genomes but there is still a lot to do especially with those genes annotated as pseudo-genes. 
## Share any other insights you might note.
I've found interesting is the fact that there's a huge chromosome (chr 2) while mitochondrial DNA is very small and becomes the powerhouse of the cell. 

    jstepanian@jstepanian ~/Documents/AppliedBioinfo/week2
    $ zcat Homo_sapiens.GRCh38.115.chr.gff3.gz | grep "sequence-region"
    ##sequence-region   1 1 248956422
    ##sequence-region   10 1 133797422
    ##sequence-region   11 1 135086622
    ##sequence-region   12 1 133275309
    ##sequence-region   13 1 114364328
    ##sequence-region   14 1 107043718
    ##sequence-region   15 1 101991189
    ##sequence-region   16 1 90338345
    ##sequence-region   17 1 83257441
    ##sequence-region   18 1 80373285
    ##sequence-region   19 1 58617616
    ##sequence-region   2 1 242193529
    ##sequence-region   20 1 64444167
    ##sequence-region   21 1 46709983
    ##sequence-region   22 1 50818468
    ##sequence-region   3 1 198295559
    ##sequence-region   4 1 190214555
    ##sequence-region   5 1 181538259
    ##sequence-region   6 1 170805979
    ##sequence-region   7 1 159345973
    ##sequence-region   8 1 145138636
    ##sequence-region   9 1 138394717
    ##sequence-region   MT 1 16569
    ##sequence-region   X 1 156040895
    ##sequence-region   Y 1 57227415
