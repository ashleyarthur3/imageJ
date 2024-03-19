# set WD and load in data
rm(list=ls())
library(ggplot2)
library(dplyr)
library(tidyr)
library(readxl)
library(ggpubr)
library(plyr)
setwd(choose.dir(default = "S:/LAB-titus004/LiviaSongster/Microscopy", caption = "Select folder"))

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
  datac <- rename(datac, c("mean" = measurevar))  # Rename the "mean" column    
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  # Confidence interval multiplier for standard error; Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  return(datac)
}

# read in data
data <- read_excel("data.xlsx")
# omit NA rows for analysis
data2 <- data[complete.cases(data),]

# add column for slope and direction in gradient (up or down)
data2$d <- ""
data2$direction <- ""

#now loop through all rows...
for (i in 1:nrow(data2)) {
  
  # OUTER PRODUCT: calculate which side of a straight line a point is located:
  # https://math.stackexchange.com/questions/274712/calculate-on-which-side-of-a-straight-line-is-a-given-point-located
 
   # x1 y1 will be cell body
  x1 <- unlist(data2[i,"cell.X"])
  y1 <- unlist(data2[i,"cell.Y"])
  # x2 y2 will be vertical line upwards from cell body
  x2 <- unlist(data2[i,"cell.X"])
  y2 <- unlist(data2[i,"cell.Y"]) + 10
  # x y will be filo point
  x <- unlist(data2[i,"filo.X"])
  y <- unlist(data2[i,"filo.Y"])
  
  # calculate outer product (d)
  data2[i,"d"] <-(x-x1)*(y2-y1)-(y-y1)*(x2-x1)
  
  # then assign filo as either up or down gradient
  if (data2[i,"d"] > 0) {
    data2[i,"direction"] <- "down"   # d > 0 is on right (down gradient)
  } else if (data2[i,"d"] < 0) {
    data2[i,"direction"] <- "up"     # d < 0 is on left (up gradient)
  } else {
    data2[i,"direction"] <- "middle" # d = 0 is on the line
  }
  rm(x1,y1,x2,y2,x,y,i)
}
# end loop
# save data2 as csv file
# draw diagram: set all cell xy to be an origin by subtracting cell xy from filo xy and cell xy
data3 <- data2 # first duplicate dataframe
# now subtract everything
data3$filo.X <- data3$filo.X - data3$cell.X
data3$filo.Y <- data3$filo.Y - data3$cell.Y
data3$cell.X <- data3$cell.X - data3$cell.X
data3$cell.Y <- data3$cell.Y - data3$cell.Y

# plot filos on same graph... color by direction
t <- ggplot(data3, aes(x=filo.X, y=filo.Y, color=direction)) + geom_point()
t
ggsave("filo_distribution.png")

# facet by experiment 
t + facet_grid(rows = vars(movie))
ggsave("bymovie_filo_distribution.png")

# find number filos up vs down per cell
#data.bycell <- count(data3, cell.ID, direction)
#data.bycell <- spread(data.bycell,cell.ID,direction)

# find angles for filopodia VS gradient (-x axis line)
data3$angle <- ""
data3$bin <- ""
data3$filo.X <- as.numeric(data3$filo.X)
data3$filo.Y <- as.numeric(data3$filo.Y)

# link to source code
# https://stackoverflow.com/questions/1897704/angle-between-two-vectors-in-r
for (i in 1:nrow(data3)) {
  
  # xy is the origin
  x <- 0
  y <- 0
  
  # x1y1 is filo point
  x1 <- unname(unlist(data3[i,"filo.X"]))
  y1 <- unname(unlist(data3[i,"filo.Y"]))
    # calculate the angle
  data3[i,"angle"] <- abs(as.numeric(atan2((y1-y),(x1-x)) * 180/pi))
  
  # then assign filo to bins
  if (between(abs(as.numeric(unname(unlist(data3[i,"angle"])))),0,60)) {
    data3[i,"bin"] <- "rear"
  } else if (between(abs(as.numeric(unname(unlist(data3[i,"angle"])))),60,120)) {
    data3[i,"bin"] <- "lateral"
  } else {
    data3[i,"bin"] <- "front"
  }
  rm(x1,y1,x,y,i)
}
# end loop
write.csv(data3,"binned_data.csv",row.names = F)

# plot data and save
s <- ggplot(data3, aes(x=filo.X, y=filo.Y, color=bin)) + geom_point()
s
ggsave("binned_filo_distribution.png")
# facet plot
s + facet_grid(rows = vars(movie))
ggsave("bymovie_binned_filo_distribution.png")

# now summarize data to find number in each bin for each cell
# http://www.cookbook-r.com/Manipulating_data/Summarizing_data/
cdata <- ddply(data3, c("cell.ID","bin"), summarise, .drop=FALSE,
               N    = length(angle)
              )

# now move bin types to column names so we can do some more fun math
spread.data <- spread(cdata,bin,N)
# find fraction of filos in each bin per cell
spread.data$n.filos <- ""
spread.data$fraction.front <- ""
spread.data$fraction.lateral <- "" 
spread.data$fraction.rear <- ""
for (i in 1:nrow(spread.data)) {
  spread.data[i,"n.filos"] <- spread.data[i,"front"] + spread.data[i,"lateral"] + spread.data[i,"rear"] 
  spread.data[i,"fraction.front"] <- as.numeric(spread.data[i,"front"]) / as.numeric(spread.data[i,"n.filos"])
  spread.data[i,"fraction.lateral"] <- as.numeric(spread.data[i,"lateral"]) / as.numeric(spread.data[i,"n.filos"])
  spread.data[i,"fraction.rear"] <- as.numeric(spread.data[i,"rear"]) / as.numeric(spread.data[i,"n.filos"])
  }
write.csv(spread.data,"binned_data_fractions.csv")
# plot boxplot with SE for fraction filos in each bin 
data4 <- gather(spread.data,"bin","fraction",6:8)
data4$fraction <- as.numeric(data4$fraction)
# plot it now
f <- ggplot(data4,aes(bin,fraction,color=bin)) + geom_boxplot()
f 

# add significance tests
# http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/76-add-p-values-and-significance-levels-to-ggplots/

compare_means(fraction ~ bin,  data = data4)
# specify comparisons for ggplot
plot_comparisons <- list(c("fraction.front","fraction.lateral"),
                       c("fraction.front","fraction.rear"),
                       c("fraction.lateral","fraction.rear"))

f + stat_compare_means(comparisons = plot_comparisons,size=4) +
  labs(x="Bin",y="Fraction of filopodia per cell") +
  geom_jitter(width = .1, alpha = .4) +
  theme(legend.position = "none")

ggsave("boxplot_with_anova.png")
write.csv(data4,"binned_data_fractions_forggplot.csv")
