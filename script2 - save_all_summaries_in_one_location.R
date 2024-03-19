#Choose file location
setwd(choose.dir(default = "Z:/Groups/LAB-titus004/LiviaSongster/Microscopy", caption = "Select folder"))

# create directories
dir.create("summaries")
DIROUT_summaries <- c("./summaries/")

#find names of ALL files
fileNames <- list.files(path = ".", full.names = FALSE, recursive = TRUE)

#save only names of files that contain "_summary.csv"
summaryNames <- fileNames[grep("summary.csv", fileNames)]

#save copy of these files in summaries folder
for (summaryName in summaryNames){
  df <- read.csv(summaryName)
  p = file_path_sans_ext(basename(summaryName))
  write.csv(df, file=paste(DIROUT_summaries,p, ".csv", sep=""), row.names = F)
}
  
#clear everything
rm(list=ls())
