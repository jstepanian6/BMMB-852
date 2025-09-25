## Week 5
## Continue from last week:
  Identify the BioProject and SRR accession numbers for the sequencing data associated with the publication.
    For *S. aureus* publication Bioproject is PRJNA887926 that contains 6 SRA accesions. 
    
## Writing Bash scripts 
  ### Expanding code from last week
  A new script was created that includes all the commands used in the previous assigment for downloading the reference genome. Refer to get_genome.sh 
  ### Downloading SRR number(s)
  A new script was created for this purpose: get_fastq.sh
  To both scripts created in this assignment I added excecution permissions using 
  ```
  chmod +x get_fastq.sh
  ```
  This script can be executed using a for loop that reads all the accession ids from another file as follows: 

  
  ``` 
  for i in $(cat list_SRA_ids.txt); do bash get_fastq.sh $i 137931; done
  ```
  
  
  #### Downloading only 10x coverage 
  For *S. aureus* I chose 137931 reads based on the coverage formula that indicates 
  > Coverage (C) ≈ (N_spots × bases_per_spot) / genome_size

  Considering that *S. aureus* genome size corresponds to 2.8 Mb = 2,800,000 bases and the desired coverage is 10×, we need 28,000,000 bases. From the run info we have an average of total spots = 15,754,542 and a total bases = 3.2 Gb = 3,200,000,000 bases. 
  So, bases per spot = 3,200,000,000 / 15,754,542 ≈ 203 bases/spot
  #### Quality assessment
  I included this quality assesment on the get_fastq.sh by adding the command: 
  
  ``` 
  seqkit stats $FASTQ
  ```
  
  The output of each run looks like: 
   ``` 
  + SRR=SRR21835901
  + READ_DIR=reads
  + mkdir -p reads
  + fastq-dump -X 137931 -F --outdir reads --split-files SRR21835901
  Read 137931 spots for SRR21835901
  Written 137931 spots for SRR21835901
  + seqkit stats reads/SRR21835901_1.fastq reads/SRR21835901_2.fastq
  processed files:  2 / 2 [======================================] ETA: 0s. done
  file                       format  type  num_seqs     sum_len  min_len  avg_len  max_len
  reads/SRR21835901_1.fastq  FASTQ   DNA    137,931  13,931,031      101      101      101
  reads/SRR21835901_2.fastq  FASTQ   DNA    137,931  13,931,031      101      101      101
   ```

  #TODO Fastqc
## Comparing sequencing platforms
I searched the SRA for another dataset for the same genome, but generated using a different sequencing platform, in this case, PacBio: 

<img width="1911" height="1039" alt="image" src="https://github.com/user-attachments/assets/d873e001-88bd-41be-a310-7cb95cc3a728" />

I downloaded the same number of reads (137931), using the get_fastq.sh command. Stats look fine: 
 ```
file                       format  type  num_seqs      sum_len  min_len  avg_len  max_len
reads/SRR33150860_1.fastq  FASTQ   DNA    137,931  789,806,659      455  5,726.1   24,023
 ```
Briefly compare the quality or characteristics of the datasets from the two platforms. #TODO
