#setwd(choose.dir())
#user needs to set WD manual on Mac

exp_name<-basename(dirname(getwd()))


#list sliced directories
slices <- list.files(path = ".", pattern = ".csv", full.names = FALSE, recursive = FALSE)


#####COMPILE SLICES#####

slicedf=NULL
for (i in 1:length(slices)){
  slicedf <- rbind(slicedf, read.csv(slices[i], header=T))
}

write.csv(slicedf, paste0(exp_name, '_compiled.csv'), row.names=FALSE)

