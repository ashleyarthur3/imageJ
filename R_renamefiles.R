
#set directory

mydir<-getwd()


files <- list.files(mydir) 
sapply(files,FUN=function(eachPath){ 
  file.rename(from=eachPath,to=sub(pattern="Object Predictions", paste0("nuclei"),eachPath)) 
}) 

