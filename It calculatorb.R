## Summarizes data.
## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)

summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
  library(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean" = measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}

setwd(choose.dir(default = "S:/Groups/LAB-titus004/AshleyArthur/Microscopy/1-100", caption = "Select folder"))

library(svDialogs)
#open cortical band
cortex <- read.csv("CorticalResults.csv", header=T)
#open cytoplasm
cyto <- read.csv("CytoplasmResults.csv", header=T)
#open background
bkgd <- read.csv("BackgroundResults.csv", header=T)
fps <- 417#as.numeric(dlg_input("Enter frame interval in milliseconds: ", Sys.info()["ms"])$res)
stimtime <- 0#as.numeric(dlg_input("Enter stimulation time in seconds: ", Sys.info()["10"])$res)
expt <- strsplit(getwd(), "/")[[1]][[length(test2[[1]])]]# dlg_input("Enter experiment number or ID: ", Sys.info()[""])$res




#calculate It for each object
df <- cortex
df$It <- (cortex$Mean - bkgd$Mean) / (cyto$Mean - bkgd$Mean)
df$Time <- (df$Slice) * fps/1000 - stimtime
dfstats<- summarySE(df, measurevar="It", groupvars=c("Time"))
#dfstats

############################################
######Plot recruitment for each cell########
############################################
library(ggplot2)
ggplot(df, aes(x=X, y=Y)) + geom_point()
ggsave(paste(expt,"_intensity_xyscatter.png"))


ggplot(dfstats, aes(x=Time, y=It, color=c("pink"))) + 
  geom_errorbar(aes(ymin=It-se, ymax=It+se), width=.1) +
  geom_line() +
  geom_point() +
  theme_bw() +
  theme_light() +
  ggtitle("Cortical recruitment") + theme(plot.title = element_text(hjust = 0.5,size=18,face="bold"), axis.title=element_text(size=14,face="bold"))+
  xlab("Time(s)") +
  ylab("Cortex/Cell Intensity") +theme(legend.position = "none")

write.csv(df,paste(expt,"_It_results.csv"), row.names = F)
write.csv(dfstats,paste(expt,"_It_stats.csv"), row.names = F)
ggsave(paste(expt,"_Recruitment.png"))