#open libraries
library(zoo)
library(tools)

#define function
find_peaks <- function (x, m = 3){
  shape <- diff(sign(diff(x, na.pad = FALSE)))
  pks <- sapply(which(shape < 0), FUN = function(i){
    z <- i - m + 1
    z <- ifelse(z > 0, z, 1)
    w <- i + m + 1
    w <- ifelse(w < length(x), w, length(x))
    if(all(x[c(z : i, (i + 2) : w)] <= x[i + 1])) return(i + 1) else return(numeric(0))
  })
  pks <- unlist(pks)
  pks
}
#a 'peak' is defined as a local maxima with m points either side of it being smaller than it

# Choose file location
path <- file.choose() #select one raw data file
DIR  <- dirname(path)

# create directories
dir.create(file.path(DIR, "normalized"))
DIROUT_normalized <- file.path(DIR, "normalized", "/") 

fileNames <- dir(DIR, full.names=TRUE, pattern =".csv")

for (fileName in fileNames) {
  p = file_path_sans_ext(basename(fileName))
  df <- read.csv(fileName) 
df <- na.omit(df)
#find brightest local maxima
tip.index <- min(find_peaks(df[,2], m = 3))
cell.index <- max(find_peaks(df[,2], m = 3))

####next we normalize the distance between maxima to 5uM

df$newX <- NA
#find number of cells (n) between tip and cell
n <- cell.index - tip.index
step <- 5/n

#save avg intensity of cell body (last five points)
cellintensity <- mean(df[(nrow(df)-5):nrow(df) , 2])

#subset to remove uneccessary rows before tip and after cell index
df <- df[(tip.index-2) : (cell.index+2) , ]

#first row should have newX = 0-2*step
df[1,3] <- 0 - 2*step
#every subsequent row should have newX = (row-1) + step
for (i in 2:nrow(df)) {
  df[i,3] <- df[i-1,3] + step 
}

####next we normalize the intensity to the cell body (which we saved before we trimmed)
df$newY <- NA
row <- nrow(df)

df$newY <- df$Y / cellintensity

#save df columns newX and Y as csv in new sub directory
keep <- c("newX","newY")
d <- df[keep]

#save new csv file
if (any(is.na(df)) == FALSE) {
write.csv(d, file=paste(DIROUT_normalized,p,"_nml.csv", sep=""), row.names = F)
}
}
#GO TO BIN INTENSITIES