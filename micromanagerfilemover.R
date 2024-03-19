from.dir <- "~/Desktop/8-20-19 p22 P149A nuclei count/P149A"
to.dir   <- "~/Desktop/8-20-19 p22 P149A nuclei count/p149acompressed"
files    <- list.files(path = from.dir, full.names = FALSE, recursive = TRUE, pattern = ".tif$")
for (f in files) file.copy(from = f, to = to.dir)

