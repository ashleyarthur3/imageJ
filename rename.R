#setwd(choose.dir(default = "G:/data/SPC/variance", caption = "Select folder with .txt compiled"))
rm(list=ls())

analysisfiles <- list.files(path = ".", pattern=".csv",full.names = TRUE, recursive = FALSE) #where you have your files

  for (csvfile in analysisfiles) {
    data <- read.csv(csvfile, header=T)
    df<-data[,2:3]
    temp <- unlist(strsplit(csvfile, "./"))[2]
    temp <- unlist(strsplit(temp, "_Airyscan Processing - "))
    exp<-temp[1]
    channel<- substr(temp[2], 1, 3)
    
    temp2<- unlist(strsplit(temp[2], ".csvtrim"))[1]
    frame<- substr(temp2, 6, 100)
    
    
    write.csv(df,paste0(exp,"_", frame,"_",channel, ".csv"))
  }
  



  







  