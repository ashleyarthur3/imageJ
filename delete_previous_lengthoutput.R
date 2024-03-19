slices <- list.files(path = ".", full.names = FALSE, recursive = TRUE)
slices <- slices[grep("tips_results.txt", slices)]
for (i in 1:length(slices)){
  file.remove(slices[i])
}
