#!/bin/bash
#PBS -l walltime=135:00:00
#PBS -N test_run
#PBS -l nodes=1:ppn=1
#PBS -l pmem=240gb 
#PBS -o log.txt 
#PBS -A exd44_e_g_sc_default

#The above PBS commands are for our server specifically. We have the script walltime at 135 hours. We have 1 processor and 240 gb of memory allocated for this script. 

cd /gpfs/group/exd44/default/rgn5011/Fungal_exploration/full_test
#Activate Conda environoment with kraken2

conda activate kracken2

#Prep your files for the loops. This requires the input data to be paired end Fastq data placed in a directory called 'fastq'. Additionally data must be in _R1.fastq/_R2.fastq format  
ls ./fastq > fastq.txt
cat fastq.txt | grep "R1">R1.txt
cat fastq.txt | grep "R2">R2.txt
mapfile -t R1 <R1.txt
mapfile -t R2 <R2.txt

#We can do this next line to count how many files we have in the directory "R1". This is effectively counting how many fastq pairs we have. This only works if the fastq data is in R1/R2 format.  
n=${#R1[@]}

#Run Kraken2 on all data and have the classified reads go into a folder called 'c_out' and the kraken output go into a folder called 'out'. The 'n' variable will show how many fastq pairs we have  
mkdir c_out
mkdir out
for ((i=0; i<n; i++));do kraken2 --db ./fungal_db/ --paired --use-names --classified-out ./c_out/${R1[i]}.cseq#.fq ./fastq/${R1[i]} ./fastq/${R2[i]} > ./out/${R1[i]}.fun.txt; done 

#Now we search for fungal hits with the grep command. The results will be in a folder called 'fungal_hits'. There will  be one file for each individual and also a combined file with the results of the run. Like with the kraken loop above 'n' will be used to show how many fastq pairs we have. The second for loop will be the amount of fungal genera we look up 

ls ./out/ > krak.txt
mapfile -t krak <krak.txt   
mapfile -t fung <fung.list.txt 
n_fungal=${#fung[@]}
mkdir fungal_hits
for ((i=0; i<n; i++)); do for ((j=0; j<n_fungal; j++)); do echo ${fung[j]} >>./fungal_hits/${krak[i]}.fung.hits.txt; cat ./out/${krak[i]} | grep -w ${fung[j]} | wc -l >>./fungal_hits/${krak[i]}.fung.hits.txt; done; echo "total fungal reads" >> ./fungal_hits/${krak[i]}.fung.hits.txt; cat ./out/${krak[i]} | grep -wf fung.list.txt | wc -l >>./fungal_hits/${krak[i]}.fung.hits.txt; echo "total reads" >> ./fungal_hits/${krak[i]}.fung.hits.txt; cat ./out/${krak[i]} | grep -w "C" | wc -l >> ./fungal_hits/${krak[i]}.fung.hits.txt; done

#This last loop is to format the fungal hit files to make two columns. The first column will be fungal genera and the second column will be fungal hits.

ls fungal_hits/ > hits.txt
mapfile -t hits <hits.txt 

for ((i=0; i<n; i++)); do awk '{printf "%s%s",$0,NR%2?"\t":RS}' ./fungal_hits/${hits[i]} > ./fungal_hits/${R1[i]}.col.txt; rm fungal_hits/${hits[i]}; done 

#This will run the R script to combine all the fungal results. Make sure to go in to the R script  and change the working directory to where the fungal_out folder is.

Rscript  Fungal_combo.R 
