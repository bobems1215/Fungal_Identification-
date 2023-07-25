# Fungal_Identification
These scripts can be used to rapidly identify fungal taxonomic hits from metagenomic data.

## What is included:

  
  - `Fungal_combo.R`:          R script used to combine all fungal hits into one table called `Fungal_total.csv` 
  
  - `fungal_db_download.sh`:    Bash script used to download PlusPF Refseq index for kraken2 analysis
  
 - `fungal_lookup.sh`:        Bash script used to run the kraken2 analysis and identify fungal hits in the samples
  
  - `fung.list.txt`:           List of fungal genera that is used for the fungal identification. This can be changed as the database is updated
  
  - `kracken2.yml`:            Yml file that can be used to create a conda environment called kracken2.

## Step 1: Change the working directory in fungal_lookup.sh and fungal_db_download.sh
If this is being run on a PBS or SLURM server you need to change line 11 of `fungal_lookup.sh` and line 11 of `fungal_db_download.sh` to the path of where these scripts are being run. If this is the case use the `qsub` options below

## Step 2: Download kraken database
The first script to use is `fungal_db_download.sh`. This will download the PlusPF Refseq index. This index has the standard bacterial Refseq database with fungi and protozoa references added. Additionally, this script will create a conda environment called kracken2 from the included .yml file and the fastq directory for your fastq files. 

```
bash ./fungal_db_download.sh
```
or

```
qsub fungal_db_download.sh
```

## Step 3: Move Fastq data to the newly created fastq directory.
Move your paired-end Illumina fastq data to the included fastq directory. It is important to note that this data must be in _R1.fastq/_R2.fastq format. So for example, if you were working on a human sample with the ID SRA56892, the paired-end fastq data would be SRA56892_R1.fastq and SRA56892_R2.fastq. Publically available data should already be in this format.

```
mv Path/To/Your/Fastq/Data/*.fastq ./fastq
```

## Step 4: Run fungal_lookup.sh
This script will run kraken2 on all paired-end fastq files in the fastq directory. This will create a directory called `c_out` which will include all of the classified reads in paired read format. Additionally, all the taxonomy results will be sent to a second created directory called `out`. Next, the script will pull out all the fungal hits and count how many times each one appears in each sample. These results will be in a created directory called `fungal_hits`. Finally, this script will run an R script called `Fungal_combo.R`. The R script will take all of the files in the `fungal_hits` directory and combine them into one large table called `Fungal_total.csv`. This file can be opened in Excel and has the tabulated fungal hits, the total reads, and the percent of fungal reads for all files included.

```
bash ./fungal_lookup.sh
```
or

```
qsub fungal_lookup.sh
```
