# Assignment #1
## Setting up Linux 
Update your Linux system  

    sudo  apt-get update &&  sudo  apt-get upgrade -y 
    # Install bzip2 because it may not be installed by default  
    sudo  apt install -y bzip2
Afterwards, I installed bwa using 
```bash
sudo apt install bwa
```
Verified the instalation using: 
```bash
bwa mem
```
That outputs bwa manual:

    jstepanian@jstepanian ~/Documents/AppliedBioinfo/work
    $ bwa mem
    
    Usage: bwa mem [options] <idxbase> <in1.fq> [in2.fq]
    
    Algorithm options:
    
           -t INT        number of threads [1]
           -k INT        minimum seed length [19]
           -w INT        band width for banded alignment [100]
           -d INT        off-diagonal X-dropoff [100]
           -r FLOAT      look for internal seeds inside a seed longer than {-k} * FLOAT [1.5]
           -y INT        seed occurrence for the 3rd round seeding [20]
           -c INT        skip seeds with more than INT occurrences [500]
           -D FLOAT      drop chains shorter than FLOAT fraction of the longest overlapping chain [0.50]
           -W INT        discard a chain if seeded bases shorter than INT [0]
           -m INT        perform at most INT rounds of mate rescues for each read [50]
           -S            skip mate rescue
           -P            skip pairing; mate rescue performed unless -S also in use
    
    Scoring options:
    
           -A INT        score for a sequence match, which scales options -TdBOELU unless overridden [1]
           -B INT        penalty for a mismatch [4]
           -O INT[,INT]  gap open penalties for deletions and insertions [6,6]
           -E INT[,INT]  gap extension penalty; a gap of size k cost '{-O} + {-E}*k' [1,1]
           -L INT[,INT]  penalty for 5'- and 3'-end clipping [5,5]
           -U INT        penalty for an unpaired read pair [17]
    
           -x STR        read type. Setting -x changes multiple parameters unless overridden [null]
                         pacbio: -k17 -W40 -r10 -A1 -B1 -O1 -E1 -L0  (PacBio reads to ref)
                         ont2d: -k14 -W20 -r10 -A1 -B1 -O1 -E1 -L0  (Oxford Nanopore 2D-reads to ref)
                         intractg: -B9 -O16 -L5  (intra-species contigs to ref)
    
    Input/output options:
    
           -p            smart pairing (ignoring in2.fq)
           -R STR        read group header line such as '@RG\tID:foo\tSM:bar' [null]
           -H STR/FILE   insert STR to header if it starts with @; or insert lines in FILE [null]
           -o FILE       sam file to output results to [stdout]
           -j            treat ALT contigs as part of the primary assembly (i.e. ignore <idxbase>.alt file)
           -5            for split alignment, take the alignment with the smallest query (not genomic) coordinate as primary
           -q            don't modify mapQ of supplementary alignments
           -K INT        process INT input bases in each batch regardless of nThreads (for reproducibility) []
    
           -v INT        verbosity level: 1=error, 2=warning, 3=message, 4+=debugging [3]
           -T INT        minimum score to output [30]
           -h INT[,INT]  if there are <INT hits with score >80.00% of the max score, output all in XA [5,200]
                         A second value may be given for alternate sequences.
           -z FLOAT      The fraction of the max score to use with -h [0.800000].
                         specify the mean, standard deviation (10% of the mean if absent), max
           -a            output all alignments for SE or unpaired PE
           -C            append FASTA/FASTQ comment to SAM output
           -V            output the reference FASTA header in the XR tag
           -Y            use soft clipping for supplementary alignments
           -M            mark shorter split hits as secondary
    
           -I FLOAT[,FLOAT[,INT[,INT]]]
                         specify the mean, standard deviation (10% of the mean if absent), max
                         (4 sigma from the mean if absent) and min of the insert size distribution.
                         FR orientation only. [inferred]
           -u            output XB instead of XA; XB is XA with the alignment score and mapping quality added.
    
    Note: Please read the man page for detailed description of the command line and options.
## Setting up the terminal 
I've been an user of ubuntu terminal for a while and I already had it set up using the GNOME dark scheme with a customized color palette 

## Create the bioinfo environment

    curl http://data.biostarhandbook.com/install.sh | bash
    conda activate bioinfo
  Everything worked perfect and was tested using sample data using the proposed code
  

    # Obtain the makefile
    curl -s http://data.biostarhandbook.com/make/snpcall.mk > Makefile
    Run the makefile
    make
    make vcf
So now I have the following structure: 

        jstepanian@jstepanian ~/Documents/AppliedBioinfo/work$ tree
    .
    |-- Makefile
    |-- bam
    |   |-- SRR1553425-AF086833.bam
    |   `-- SRR1553425-AF086833.bam.bai
    |-- data
    |   `-- AF086833
    |       |-- genes.gbk
    |       `-- snpEffectPredictor.bin
    |-- reads
    |   |-- SRR1553425_1.fastq
    |   |-- SRR1553425_1P.fq
    |   |-- SRR1553425_1U.fq
    |   |-- SRR1553425_2.fastq
    |   |-- SRR1553425_2P.fq
    |   |-- SRR1553425_2U.fq
    |   `-- adapter.fa
    |-- refs
    |   |-- AF086833.fa
    |   |-- AF086833.fa.amb
    |   |-- AF086833.fa.ann
    |   |-- AF086833.fa.bwt
    |   |-- AF086833.fa.fai
    |   |-- AF086833.fa.pac
    |   |-- AF086833.fa.sa
    |   `-- AF086833.gff
    |-- snpEff.config
    `-- vcf
        |-- SRR1553425-AF086833.annotated.vcf.gz
        |-- SRR1553425-AF086833.annotated.vcf.gz.csi
        |-- SRR1553425-AF086833.vcf.gz
        |-- SRR1553425-AF086833.vcf.gz.csi
        |-- snpEff_genes.txt
        `-- snpEff_summary.html
    
    7 directories, 27 files
## Questions 5 to 10 
5. What version is your samtools command in the bioinfo environment?
    Program: samtools (Tools for alignments in the SAM format)
    Version: 1.22.1 (using htslib 1.22.1)
6. Show commands needed to create a nested directory structure.
        `mkdir -p dir1/dir2/dir3/dir4`
    then check the results using `tree` command

        tree
        .
        `-- dir1
            `-- dir2
                `-- dir3
                    `-- dir4
        
        5 directories, 0 files
7. Show commands that create files in different directories
   `touch dir1/dir2/example.txt`
8. Show how to access these files using relative and absolute paths.

        jstepanian@jstepanian ~/Documents/AppliedBioinfo/work/dir
        $ tree
        .
        `-- dir1
            `-- dir2
                |-- dir3
                |   `-- dir4
                `-- example.txt
        
        5 directories, 1 file



