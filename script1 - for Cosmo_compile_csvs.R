rm(list=ls())
library(data.table)
library(tidyr)
library(rlang)
library(Rcpp)
install.packages("tidyverse")
dir.create("Tidy_data")

setwd(choose.dir(default = "C:/Users/arthu038/Desktop/", caption = "Select folder with CSV files"))

exp_name <- basename(getwd())

#####COMPILE#####

# find analysis results files
C1 <- list.files(path = ".", full.names = FALSE, recursive = TRUE, pattern="Results-C1.csv")
C3 <- list.files(path = ".", full.names = FALSE, recursive = TRUE, pattern="Results-C3.csv")

#combines all the csv files and adds a column at the end with the name of the file the data came from
df <- do.call(rbind, lapply(C1, function(x) cbind(read.csv(x), Experiment=strsplit(x,'\\.')[[1]][2])))
df2 <- do.call(rbind, lapply(C3, function(x) cbind(read.csv(x), Experiment=strsplit(x,'\\.')[[1]][2])))


mean_norm <- df2$Mean/df$Mean #c3 divided by C1?
t<-df$Slice
movie<-df$Experiment
temp=NULL
temp<-cbind(mean_norm,t,movie)
keys <- colnames(temp)[!grepl('mean_norm',colnames(temp))] # save colnames of key columns, aka not It.Norm
X <- as.data.table(temp)
# if there is a duplicate cell for each time point, find the average
temp2 <- X[,list(mean_norm=mean(mean_norm)),keys]
write.csv(temp2,paste0("Tidy_data/","norm_data.csv"))

#  