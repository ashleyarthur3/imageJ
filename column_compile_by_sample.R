#setwd(choose.dir(default = "G:/data/SPC/variance", caption = "Select folder with .txt compiled"))
rm(list=ls())
library(data.table)
library(tidyr)
library(stringr)
library(svDialogs)
library(plyr)
library(tools)

library(gtools)

rm(data)

analysisfiles <- list.files(path = ".", pattern=".csv",full.names = TRUE, recursive = FALSE) #where you have your files


  for (csvfile in analysisfiles) {
    data <- read.csv(csvfile, header=T)
    dirname <- unlist(strsplit(csvfile, "./Image ",".csv"))[2]
   
    df<-data$Slice
    df<-cbind(df,data$Mean)
    
    colnames(df)<-c(paste0("slice ",dirname), paste0("mean",dirname))
  
    
    write.csv(df,paste0(dirname,"trim.csv"))
  }
  
  


  







  