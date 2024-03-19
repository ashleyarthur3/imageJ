rm(list=ls())

#setwd(choose.dir(default = "S:/LAB-titus004/LiviaSongster/Microscopy", caption = "Select folder"))

exp_name <- basename(getwd())

#####COMPILE SLICES#####

# loop thru all sliced directories to find analysis results files
analysisfiles <- list.files(path = ".", full.names = FALSE, recursive = TRUE, pattern="data.dat")
slicedf=NULL

for (i in 1:length(analysisfiles)){
  data <- read.table(analysisfiles[i], header=T)
  dirname <- unlist(strsplit(analysisfiles[i],"/"))[1]
  data$Movie <- unlist(strsplit(dirname,"_"))[1]
  slicedf <- rbind(slicedf, data)
  rm(data)
}

# save the files, then trim it
write.csv(slicedf, paste0(exp_name, '_compiled.csv'), row.names=FALSE)
