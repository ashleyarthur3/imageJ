rm(list=ls())

#setwd(choose.dir(default = "S:/LAB-titus004/LiviaSongster/Microscopy", caption = "Select folder"))

exp_name <- basename(getwd())

#####COMPILE SLICES#####


# loop thru all sliced directories to find analysis results files
tau_value <- list.files(path = ".", full.names = FALSE, recursive = TRUE, pattern="data.dat")
#tau_data <-list.files(full.names = FALSE, recursive = TRUE, pattern="_Results.csv")
slicedf=NULL


for (i in 1:length(tau_value)){
  norm_tau<-NULL
  data <- read.table(tau_value[i], header=T)  #read in data table that stores tau value
  tau1<-data$tau.1..ns.[1] #get tau1
  tau2<-data$tau.2..ns.[1] #get tau 2
  dirname <- unlist(strsplit(tau_value[i],"/"))[1]
  rm(data) #now clear this data frame
  
  #get tau values for cellual localations in that movie folder
  tau_data <-list.files(path = dirname, full.names = TRUE, recursive = TRUE, pattern="_Results.csv")
  
  #read in each of them
  tau1_cortex<- read.csv(tau_data[1], header=T)
  tau1_cyto<- read.csv(tau_data[2], header=T)
  tau2_cortex<- read.csv(tau_data[3], header=T)
  tau2_cyto<- read.csv(tau_data[4], header=T)
    
  norm_tau$tau1_cortex<-tau1_cortex$Mean*tau1
  norm_tau$tau1_cyto<-tau1_cyto$Mean*tau1
  norm_tau$tau2_cortex<-tau2_cortex$Mean*tau2
  norm_tau$tau2_cyto<-tau2_cyto$Mean*tau2
  norm_tau$amplitudeCortex<-tau1_cortex$Mean+tau2_cortex$Mean
  norm_tau$amplitudeCyto<-tau1_cyto$Mean+tau2_cyto$Mean
  
  norm_tau$cortex<-(norm_tau$tau1_cortex + norm_tau$tau2_cortex) /  norm_tau$amplitudeCortex
  norm_tau$cyto<-(norm_tau$tau1_cyto + norm_tau$tau2_cyto) /  norm_tau$amplitudeCyto
  
  
  norm_tau<-as.data.frame(norm_tau)
  
  write.csv(norm_tau, paste0(dirname, '_average_nanosec.csv'), row.names=FALSE)
  rm(tau1) #now clear this data frame
  rm(tau2) #now clear this data frame
  rm(tau1_cortex)
  rm(tau1_cyto)
  rm(tau2_cortex)
  rm(tau2_cyto)
  
}



df=NULL

#save the names of the files you want to import
file_names <- list.files(path = ".", full.names = FALSE, recursive = FALSE, pattern = "_average_nanosec.csv") #where you have your files
#combines all the csv files and adds a column at the end with the name of the file the data came from
df <- do.call(rbind, lapply(file_names, function(x) cbind(read.csv(x), Experiment=strsplit(x,'\\.')[[1]][1])))


#save the final compiled document
write.csv(df, paste0(exp_name, '_ns_norm_allfiles.csv'), row.names=FALSE)





# save the files, then trim it
#write.csv(slicedf, paste0(exp_name, '_compiled.csv'), row.names=FALSE)
