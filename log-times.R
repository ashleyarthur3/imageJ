# open dir with log files
setwd("S:/LAB-titus004/LiviaSongster/Analysis/190723 - filopodia life time hmm-cc and ddmyo7/logs")
# read in all file names
files <- list.files(pattern=".log")
# loop through all log files and save total frame number and time interval with file name
df <- as.data.frame(matrix(data=NA,nrow=length(files),ncol=3))
colnames(df) <- c("File","Frame.Interval","Time.Points")
df$File <- files
for (i in 1:length(files)) {
  log <- readLines(files[i])
  # find and save framerate from log file
  line <- grep("Average Timelapse Interval: ",log,
                value=TRUE)
  df[i,"Frame.Interval"] <- as.numeric(unlist(strsplit(line,split = " "))[4])
  line2 <- grep("Time Points: ",log,
                value=TRUE)
  df[i,"Time.Points"] <- as.numeric(unlist(strsplit(line2,split = " "))[3])
}

write.csv(df,"log-times.csv")
