rm(list=ls())

#load files and calculate mean intensity
b1 <- read.csv("img 0-1 Background.csv", header=T)
r1 <- read.csv("img 0-1 Results.csv", header=T)
b1avg <- mean(b1$Mean)
r1$Intensity <- r1$Mean-b1avg
r1$Ratio <- r1$Mean/b1avg

#second
b2 <- read.csv("img 2-3 Background.csv", header=T)
r2 <- read.csv("img 2-3 Results.csv", header=T)
b2avg <- mean(b2$Mean)
r2$Intensity <- r2$Mean-b2avg
r2$Ratio <- r2$Mean/b2avg

#third
b3 <- read.csv("img 10-11 Background.csv", header=T)
r3 <- read.csv("img 10-11 Results.csv", header=T)
b3avg <- mean(b3$Mean)
r3$Intensity <- r3$Mean-b3avg
r3$Ratio <- r3$Mean/b3avg

#fourth
b4 <- read.csv("img 6-7 Background.csv", header=T)
r4 <- read.csv("img 6-7 Results.csv", header=T)
b4avg <- mean(b4$Mean)
r4$Intensity <- r4$Mean-b4avg
r4$Ratio <- r4$Mean/b4avg

#fifth
b5 <- read.csv("img 8-9 Background.csv", header=T)
r5 <- read.csv("img 8-9 Results.csv", header=T)
b5avg <- mean(b5$Mean)
r5$Intensity <- r5$Mean-b5avg
r5$Ratio <- r5$Mean/b5avg

r1$data <- c("img 0-1")
r2$data <- c("img 2-3")
r3$data <- c("img 10-11")
r4$data <- c("img 6-7")
r5$data <- c("img 8-9")

#compile both img set results
df <- rbind(r1,r2,r3,r4,r5)
#save as new csv
library(svDialogs)
exp_name <- dlg_input("Enter experiment name:", Sys.info()["ms"])$res
write.csv(df, paste0(exp_name, '_intensities.csv'), row.names=FALSE)

##################################################
############now compile all the files together####
##################################################
setwd("..")
df=NULL
file_names <- list.files(path = ".", full.names = FALSE, recursive = TRUE) #where you have your files

#combines all the csv files and adds a column at the end with the name of the file the data came from
file_names <- file_names[grep("intensities", file_names)]
df <- do.call(rbind, lapply(file_names, function(x) cbind(read.csv(x), genotype=strsplit(x,'\\.')[[1]][1])))
dir_name<-c("258")

#fix genotype column
df$genotype <- sapply(df$genotype, function(x) unlist(strsplit(as.character(x), split = "_"))[1])

write.csv(df, paste0(dir_name, '_intensities_allfiles.csv'), row.names=FALSE)

###########PLOTS#############
library(ggplot2)

#with all
p <- ggplot(df, aes(genotype,Intensity))
p + geom_jitter(aes(colour=data)) + theme_bw() + theme_light()

#no gfp
q <- ggplot(subset(df,genotype!="LS225"), aes(genotype,Intensity))
q + geom_jitter(aes(colour=data)) + theme_bw() + theme_light()
#gfp only
gfp <- ggplot(subset(df,genotype="LS225"), aes(genotype,Intensity))
gfp + geom_jitter(aes(colour=data)) + theme_bw() + theme_light()
