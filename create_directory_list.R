directories <- list.dirs(path = ".", full.names = TRUE, recursive = TRUE)
files <- list.files(path = ".", full.names = TRUE, recursive = TRUE)

write.csv(directories, "Kieke.csv")

write.csv(files, "Kiekefiles.csv")
