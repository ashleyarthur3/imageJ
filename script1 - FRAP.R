##setwd(choose.dir(default = "S:/LAB-titus004/LiviaSongster/Microscopy", caption = "Select folder"))
rm(list=ls())
exp_name <- unlist(strsplit(getwd(), "/"))[7]

#####COMPILE SLICES#####

# loop thru all sliced directories to find analysis results files
analysisfiles <- list.files(path = ".", full.names = FALSE, recursive = TRUE, pattern="Results_1.txt")
slicedf=NULL


for (i in 1:length(analysisfiles)){
  data <- read.table(analysisfiles[i], header=T)
  dirname <- unlist(strsplit(analysisfiles[i]," "))[3]
 # data$Slice <- unlist(strsplit(dirname,"_"))[2]
#  data$Movie <- unlist(strsplit(dirname,"_"))[4]
  slicedf <- cbind(slicedf, data$FrapF)
  rm(data)
}

# save the files, then trim it
write.csv(slicedf, paste0(exp_name, '_raw_compiled.csv'), row.names=FALSE)


rescalemat <- function(mat){
  apply(mat, 1, function(x){
    colmax<-apply(mat, 2, function(x) max(x))
    colmin<-apply(mat, 2, function(x) min(x))
    (x-colmin)/(colmax-colmin)
  })
}

scaled<-rescalemat(slicedf)

write.csv(scaled, paste0(exp_name, '_norm_compiled.csv'), row.names=FALSE)

