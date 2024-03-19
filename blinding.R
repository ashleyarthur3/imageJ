#first make random list of words for blinding, and save it as random.csv
#have one random word for each file you want to rename
#https://www.randomlists.com/random-words

#change dir to location of files
files <- list.files()
wd <- getwd()
#go up one level where all the new filenames are saved in csv called "random.csv"
setwd("..")
random <- read.csv("random.csv",header=FALSE)$V1
#change back to dir of files to blind
setwd(wd)
#rename files
file.rename(files,paste0(random,".tiff"))

#save names of files + random name as key
df <- ""
df$File <- files
df$RandomName <- random[1:68]
setwd("..")
write.csv(df,"Key.csv")
