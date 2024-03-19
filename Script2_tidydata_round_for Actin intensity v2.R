
rm(list=ls())
library(data.table)
library(tidyr)

dir.create("Tidy_data")

#save the names of the files you want to import
file_names <- list.files(path = ".", pattern="csv",full.names = FALSE, recursive = FALSE) #where you have your files
temp <- read.csv(file_names[1]) # read in files
keep <- c("ImageID","Bin","Average") #columns we want to keep
temp <- temp[keep] # save only the columns we want (defined above)
temp <-na.omit(temp) # remove NAs
keys <- colnames(temp)[!grepl('Average',colnames(temp))] # save colnames of key columns, aka not It.Norm
X <- as.data.table(temp)
  # if there is a duplicate cell for each time point, find the average
  temp2 <- spread(temp,ImageID,Average) #spred the dataframe "temp" by image ID and the values are "average" as in average image intensity
  genotype <-unlist(strsplit(file_names[1],split = ".csv"))[1]
  write.csv(temp2,paste0("Tidy_data/",genotype,"_tidy bins raw.csv"))
  
  
## now do a min-max normalization  
  normalize <- function(x)
  {
    return((x- min(x)) /(max(x)-min(x)))
  }
  
  # To get a vector, use apply instead of lapply
 temp3<- as.data.frame(sapply(temp2, normalize))
 temp3$Bin<-temp2$Bin #fix the bins!
 write.csv(temp3,paste0("Tidy_data/",genotype,"_tidy bins min-max-norm.csv"))
