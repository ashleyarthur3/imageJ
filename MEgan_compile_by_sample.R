setwd(choose.dir(default = "G:/data/SPC/variance", caption = "Select folder with .txt compiled"))
rm(list=ls())
library(data.table)
library(tidyr)
library(stringr)
library(svDialogs)
library(plyr)
library(tools)

## Summarizes data.
## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)


all_files <- list.files(path = ".", pattern=".txt",full.names = TRUE, recursive = FALSE) #where you have your files

sampleTypes<-c("s1_", "s2_", "s15_", "s16_")

for (sampleType in sampleTypes) {
  
  get_samples<-grepl(sampleType, all_files)
  file_names<-all_files[get_samples]
  
  
  df<-""
  for (file_name in file_names) {
    temp<-""
    temp <- read.table(file_name, header = TRUE, sep = "\t") #read.table(file_names) # read in files
    end<-dim(temp)[1]-2
    temp2<-temp[1033:end,]
    
    expt <- unlist(strsplit(as.character(temp2), "<i Sigma=0>", ">/i"))
    counts<-matrix(as.numeric(unlist(regmatches(expt,gregexpr("(?>-)*[[:digit:]]+\\.*[[:digit:]]*",expt, perl=TRUE)))))
    colName<-matrix(unlist(str_split(file_name,"./")))[2]
    colnames(counts) <- colName
    
    df<-cbind(df,counts)
    sampleName<-unlist(str_split(colnames(df)[2], "_"))[1] #get sample name
    
  }
  
  write.csv(df,paste0("Sample_",sampleName,".csv"))


  
}






  