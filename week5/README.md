## Week 5
## Continue from last week:
  Identify the BioProject and SRR accession numbers for the sequencing data associated with the publication.
    For *S. aureus* publication Bioproject is PRJNA887926 that contains 6 SRA accesions. 
    
## Writing Bash scripts 
  ### Expanding code from last week
  A new script was created that includes all the commands used in the previous assigment for downloading the reference genome. Refer to get_genome.sh 
  ### Downloading SRR number(s)
  A new script was created for this purpose: get_fastq.sh
  This script can be executed using a for loop that reads all the accession ids from another file as follows 

  
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
  ``` seqkit stats $FASTQ ```
    #TODO Fastqc
## Comparing sequencing platforms
Compare sequencing platforms:

Search the SRA for another dataset for the same genome, but generated using a different sequencing platform (e.g., if original data was Illumina select PacBio or Oxford Nanopore).
Briefly compare the quality or characteristics of the datasets from the two platforms.
