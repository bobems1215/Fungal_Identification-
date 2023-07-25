#!/bin/bash
#PBS -l walltime=135:00:00
#PBS -N test_run
#PBS -l nodes=1:ppn=1
#PBS -l pmem=240gb 
#PBS -o log.txt 
#PBS -A exd44_e_g_sc_default

#First change this next line of code to your working directory 

cd /gpfs/group/exd44/default/rgn5011/Fungal_exploration/full_test/scripts

#make a directory for the reference database

mkdir fungal_db
cd ./fungal_db

#download the 55 gb database from the kraken wiki

wget https://genome-idx.s3.amazonaws.com/kraken/k2_pluspf_20230605.tar.gz

#unzip the reference files

tar -zxvf k2_pluspf_20230605.tar.gz 

#remove the tar file to save space 

rm k2_pluspf_20230605.tar.gz

#Create the conda envionment 

conda env create -f kracken2.yml

#Create a folder for fastq data

mkdir fastq

#you only have to run this once to download the reference database to the fungal_db folder.
