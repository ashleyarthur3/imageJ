#Open libraries
library(tools)

# FIRST SPLIT ALL FILES INTO SINGLE FILOPODIA
#this only applies to when you used multiplot on ImageJ ROIs

# Choose file location
path <- file.choose()
DIR  <- dirname(path)


# create directories
dir.create(file.path(DIR, "single_in"))
DIROUT_single_IN <- file.path(DIR, "single_in", "/") 

fileNames <- dir(DIR, full.names=TRUE, pattern =".csv")

#this will separate files with multiple plots into individual csv files;
#note that all csv in the folder MUST have 4 or more columns total
#(ie at least 2 ROIs saved in same csv)
for (fileName in fileNames) {
  p = file_path_sans_ext(basename(fileName))
  Values <- read.csv(fileName) 
  Nbvalues = ncol(Values)/2
  dp <- tapply(as.list(Values), gl(ncol(Values)/2, 2), as.data.frame)
  i = 1
  repeat {
    write.csv(dp[[i]], file=paste(DIROUT_single_IN,p,"_", i, ".csv", sep=""), row.names = F)
    i = i + 1
    if (i == Nbvalues) {
      break
    }
  }
  
}

