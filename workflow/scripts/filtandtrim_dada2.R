# filter and trim
log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")
str(snakemake)

ToBeFiltered <- list.files(snakemake@input[[1]], pattern=".fastq", full.names = TRUE)
Filtered <- file.path(snakemake@output[[1]],basename(ToBeFiltered))
library(dada2)
filterAndTrim(ToBeFiltered,
              Filtered,
              truncLen=snakemake@params[[1]],
              maxN=snakemake@params[[2]],
              maxEE=snakemake@params[[3]],
              truncQ=snakemake@params[[4]],
              matchIDs=snakemake@params[[5]],
              verbose=snakemake@params[[6]],
              multithread=snakemake@params[[7]],
              compress=FALSE)