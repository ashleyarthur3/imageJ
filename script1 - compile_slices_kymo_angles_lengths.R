setwd(choose.dir(default = "S:/LAB-titus004/LiviaSongster/Microscopy", caption = "Select folder"))

exp_name<-basename(getwd())

#list sliced directories
slices <- list.dirs(path = ".", full.names = FALSE, recursive = FALSE)
slicesrec <- list.dirs(path = ".", full.names = FALSE, recursive = TRUE)
#list kymograph directories
kymo <- slicesrec[grep("Kymograph", slicesrec)]

#####COMPILE SLICES#####

slicedf=NULL
for (i in 1:length(slices)){
  setwd(slices[i])
  ##slicedf <- rbind(slicedf, read.csv("filopod-results-7.csv", header=T))
  slicedf <- rbind(slicedf, read.csv("analysis-results-7.csv", header=T))
  setwd("..")
}
slicedf <- slicedf[,1:ncol(slicedf)]
write.csv(slicedf, paste0(exp_name, '_compiled.csv'), row.names=FALSE)

#####COMPILE KYMO#####

kymodf=NULL
for (i in 1:length(kymo)){
  setwd(kymo[i])
  kymodf <- rbind(kymodf, read.csv("kymograph_results.csv", header=T))
  setwd("../..")
}
kymodf <- kymodf[,2:length(kymodf)]
write.csv(kymodf, paste0(exp_name, '_kymo_compiled.csv'), row.names=F)

 #####COMPILE ANGLES#####

 slicesfiles <- list.files(path = ".", full.names = FALSE, recursive = TRUE)
 anglefiles <- slicesfiles[grep("overall_tips_Angle_results", slicesfiles)]
 angledf=NULL
 for (i in 1:length(anglefiles)){
   angledf <- rbind(angledf, read.delim(anglefiles[i], header = FALSE, sep = "\t"))
 }
 colnames(angledf) <- c("cell.x","cell.y","tip.x","tip.y","Angle.Degrees","Arc.Distance")
 write.csv(angledf, paste0(exp_name, '_angles_compiled.csv'), row.names=FALSE)

 #####COMPILE LENGTHS#####

 lengthdf <- read.delim("overall_tips_results.txt", header=FALSE, sep = "\t")
 colnames(lengthdf) <- "Length.um"
 write.csv(lengthdf, paste0(exp_name, '_length_compiled.csv'), row.names=FALSE)

 #################################
 ####SAVE TO MASTER DIRECTORY#####
 #################################

 setwd(choose.dir(default = "S:/LAB-titus004/LiviaSongster/Analysis/190109-DN-PLA_withAA", caption = "Select folder"))

 slicedf <- subset(slicedf, Cell.Perimeter..um. >10)
 write.csv(slicedf, paste0(exp_name, '_compiled.csv'), row.names=FALSE)

 kymodf[kymodf==0] = NA
 kymodf <- na.omit(kymodf)
 kymodf <- subset(kymodf, kymodf[,2] > 0)
 write.csv(kymodf, paste0(exp_name, '_kymo_compiled.csv'), row.names=F)

 angledf[angledf==0] = NA
 angledf <- na.omit(angledf)
 write.csv(angledf, paste0(exp_name, '_angles_compiled.csv'), row.names=FALSE)

 lengthdf <- subset(lengthdf, Length.um <=10)
 write.csv(lengthdf, paste0(exp_name, '_length_compiled.csv'), row.names=FALSE)

 