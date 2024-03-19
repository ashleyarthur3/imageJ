####PREREQUISITES####
#your data must be in the following format

#Kymograph_multiplot_results.csv    WHERE the columns represent, in order left to right
#X0   Y0    Y1    Y2    Y3    Y4    Time, Background intensity, tip intensity, shaft intensity, cortex intensity, cell body intensity
#0    2     3     5     6     7     

#if your data is not in the correct format, you will have issues running this script.
#to get it in the right format, I suggest manually deleting any X columns besides X0
#then you can add additional rows to all the columns until they are the same lengths.
#for X0 and Y1, populate these rows with 0
#for the other columns, populate new rows with the column mean...not a perfect solution but it works

#load libraries
library(tools)
library(dplyr)
library(qpcR)
library(svDialogs)

#Choose file location
setwd("~/Desktop/test_data")
protein <- dlg_input("Enter protein name and cell background: ", Sys.info()["protein"])$res

library(rJava)
library(rChoiceDialogs)
getwd()
# [1] "C:/Users/Root/Documents"
jchoose.dir()  # opens the dialog window in "C:\\Users\\Root\\Documents"


# create directories
dir.create("results")
DIROUT_results <- c("./results/")
dir.create("temp")
DIROUT_temp <- c("./temp/")

#find names of files
fileNames <- list.files(path = ".", full.names = FALSE, recursive = FALSE,pattern =".csv")

#find plot profiles for each kymograph
for (fileName in fileNames){
  p = file_path_sans_ext(basename(fileName))
  df <- read.csv(fileName)
  #find maximum from tip column
  #subtract background (column 2) from each point
    #df[,3:ncol(df)] <- df[,3:ncol(df)] - mean(df[,2])
  #find maximum tip intensity
    tip_sweep<-as.numeric(nrow(df)-round(nrow(df)/4)) #how far from end do you want to look for max tip intensity?
    print(tip_sweep)
    tip_val<- which.max(df[tip_sweep:nrow(df), 3]) #finds row with highest tip intesnity
    tip<- df[tip_sweep+tip_val-1,] #write row with filo tip
    print(tip)
  start <- df[1,]
  #print(min)
   #find slope between first point and max point
  x1 <- as.numeric(as.character(start[1]))
  y1 <- as.numeric(as.character(start[3]))
  x2 <- as.numeric(as.character(tip[1]))
  y2 <- as.numeric(as.character(tip[3]))


  Et <- data.frame(matrix(NA,nrow = 1, ncol = 0))
    Et$TotalTime <- max(df[,1])
    Et$TipSlope <- as.numeric(as.character((y2 - y1) / (x2 - x1)))
  #next separate out means of data from combined multiplot csv
  df <- df[,2:ncol(df)] #remove first column with X values
  means <- data.frame(colMeans(df,na.rm = TRUE)) #finds column means for each plot profile
    Et$MeanTip <- means[2,1]
    Et$MeanShaft <- means[3,1]
    Et$MeanCortex <- means[4,1]
    Et$MeanCell <- means[5,1]
    Et$Shaft.Cortex <- means[3,1] / means[4,1]
    Et$Shaft.Cell <- means[3,1] / means[5,1]
    Et$Cortex.Cell <- means[4,1] / means[5,1]
    Et$Tip.Cell <- means[2,1] / means[5,1]
  write.csv(Et, file=paste(DIROUT_temp,p, "_temp.csv", sep=""), row.names = F)
}


#generate a merged data table where row names are file names and columns are same as in Et
setwd(DIROUT_temp)
tempfiles <- list.files(path =".", full.names = FALSE, recursive = FALSE)
mergedata <- NULL
mergedata <- do.call(rbind, lapply(tempfiles, function(x) cbind(read.csv(x), name=strsplit(x,'\\.')[[1]][1])))

#save file containing merged Et data in results folder
setwd("..")
write.csv(mergedata, file=paste(DIROUT_results,protein,"_merged_nrow.csv", sep=""), row.names = F)

