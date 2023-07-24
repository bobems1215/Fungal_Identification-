
#The only thing you need to change in this script is the working directory where your output files are from the fungal_kracken.sh script 
setwd("./fungal_hits")

#We first  need to extract all of the file names that we want to combine
temp = list.files(pattern="*.txt")

#We also want to import the file with all the fungal genera to get the length of the final data frame 
fung.list <- read.table("../fung.list.txt", quote="\"", comment.char="")

#We then use the 'temp' variable to read in all of the files 
for (i in 1:length(temp)) {
  assign(temp[i], read.delim(temp[i], header=FALSE))
}
#We then want to extract the file names. As long as the files have '_R1' in the file name, this will work.
samp_names<-sapply(strsplit(basename(temp), "_R1"), `[`, 1)

#Then we make a blank dataframe that we will fill with the fungal hits from the specific files. We also want to change the column names to the funal genera and the row names to the sample names we extracted above  
fung_total<-data.frame(matrix(ncol = (length(temp)), nrow=(length(row.names(fung.list))+2)))
colnames(fung_total)<-samp_names
rownames(fung_total)<-get(temp[1])$V1

#This loop reads in the fungal hits for each sample and puts them in the fung_total data frame
for (i in 1:length(temp)){ 
  fung_total[,i] <- get(temp[i])$V2
}

#This adds an extra row to the dataframe 
fung_total[nrow(fung_total) +1,] = c("NA")

#This last loop creates the percentage of fungal hits for each sample 
for (i in 1:length(temp)){
  as.numeric((fung_total[46,i]))->A
  as.numeric((fung_total[47,i]))->B
  ((A/B)*100) -> fung_total[48,i]
}

#This just changes the extra row name 
row.names(fung_total)[48] <-"Percent Fungal Reads"

#Finally we export the fung_total data frame to the excel file 'Fungal_total.csv"
write.csv(fung_total, file="Fungal_total.csv")
