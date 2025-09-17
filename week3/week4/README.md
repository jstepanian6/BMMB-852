<img width="1848" height="1170" alt="image" src="https://github.com/user-attachments/assets/edd0362a-d7bf-427c-9a38-399f3c812b14" />



<img width="1848" height="1170" alt="image" src="https://github.com/user-attachments/assets/9c024883-2ee9-4de9-8dbd-f1ddf5f8ca60" />


Using "fastq-dump" version 3.0.0 from sratools packages 
for i in $(cat accessionNumbers.txt); do fastq-dump --gzip --split-files $i &> ${i}_fastqdump.log; done



