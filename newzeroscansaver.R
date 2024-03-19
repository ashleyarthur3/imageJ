#setwd(choose.dir(default = "S:/Groups/LAB-titus004/AshleyArthur/Microscopy", caption = "Select folder"))
setwd(choose.dir())
exp_name<-basename(getwd())

#list sliced directories
slices <- list.dirs(path = ".", full.names = FALSE, recursive = FALSE)

#####COMPILE SLICES#####
slicedf=NULL
for (i in 1:length(slices)){
  setwd(slices[i])
  #newzeros <- list.files(pattern="newzeroscan")
  scan <- rbind(slicedf, read.delim("newzeroscan-0-7.txt", header=F))
#     for (j in 1:length(newzeros)){
#     scan <- rbind(slicedf, read.delim(newzeros[j], header=F))
#     setwd("../..")
#     write.csv(scan, paste0(exp_name, '_trim', i,j, '.csv'), row.names=FALSE)
#     }
  setwd("..")
  write.csv(scan, paste0(exp_name, '_trim', i, '.csv'), row.names=FALSE)
  
}

##
