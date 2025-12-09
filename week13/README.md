## Set up environment 
	
    #Activate bioinfo conda env 
    conda activate bioinfo
    # Get the code.
    bio code
    
    # Run the script to create the stats environment.
    bash src/setup/init-stats.sh
 Test the environment
    micromamba run -n stats Rscript src/setup/doctor.r

## Download the data and decompress the data 

    wget -nc  http://data.biostarhandbook.com/data/uhr-hbr.tar.gz

    tar xzvf uhr-hbr.tar.gz

## RNA-seq processing 
Checking reference stats:
 

    seqkit stats refs/*.fa

    

> processed files:  2 / 2 [======================================] ETA:
> 0s. done
>     file                       format  type  num_seqs     sum_len     min_len     avg_len     max_len
>     refs/chr22.genome.fa       FASTA   DNA          1  50,818,468  50,818,468  50,818,468  50,818,468
>     refs/chr22.transcripts.fa  FASTA   DNA      4,506   7,079,970          33     1,571.2      84,332

Checking reads stats:

    seqkit stats reads/*.fq

> processed files:  6 / 6 [======================================] ETA:
> 0s. done file               format  type  num_seqs     sum_len 
> min_len  avg_len  max_len reads/HBR_1_R1.fq  FASTQ   DNA    118,571 
> 11,857,100      100      100      100 reads/HBR_2_R1.fq  FASTQ   DNA  
> 144,826  14,482,600      100      100      100 reads/HBR_3_R1.fq 
> FASTQ   DNA    129,786  12,978,600      100      100      100
> reads/UHR_1_R1.fq  FASTQ   DNA    227,392  22,739,200      100     
> 100      100 reads/UHR_2_R1.fq  FASTQ   DNA    162,373  16,237,300    
> 100      100      100 reads/UHR_3_R1.fq  FASTQ   DNA    185,442 
> 18,544,200      100      100      100

Construct design file:

    vim design.csv

> sample,group
HBR_1,HBR
HBR_2,HBR
HBR_3,HBR
UHR_1,UHR
UHR_2,UHR
UHR_3,UHR


#### Generate index

    # Get the bioinformatics toolbox
    bio code
    
    # Index the genome
    make -f src/run/hisat2.mk index REF=refs/chr22.genome.fa

#### Create alignments 
An script was created under the name "mapping.sh" 

    #!/bin/bash
    
    # Read design.csv and process each sample
    tail -n +2 design.csv | while IFS=, read -r sample group; do
        echo "Processing sample: $sample (group: $group)"
        
        # Run the alignment
        make -f src/run/hisat2.mk \
            REF=refs/chr22.genome.fa \
            R1=reads/${sample}_R1.fq \
            BAM=bam/${sample}.bam \
            run
        
        echo "Completed processing $sample"
        echo "----------------------------------------"
    done
    
    echo "All samples processed!"

Then excuted 

#### Create gene count matrix 

    featureCounts -a refs/chr22.gtf -o counts.txt \
                  bam/HBR_1.bam \
                  bam/HBR_2.bam \
                  bam/HBR_3.bam \
                  bam/UHR_1.bam \
                  bam/UHR_2.bam \
                  bam/UHR_3.bam
