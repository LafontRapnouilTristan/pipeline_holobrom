# dereplication
log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(dada2)

input <- snakemake@input[[1]]
uniques <- derepFastq(input,
                    #  n=snakemake@params[[1]],
                      verbose=TRUE)

seqtab <- makeSequenceTable(uniques)
rownames(seqtab) <- gsub(rownames(seqtab),pattern = ".fastq", replacement = "")

ids <- NULL
ids_per_seq <- list()
for (i in 1:ncol(seqtab)){
  ids <- NULL
  count <- sum(seqtab[,i] )
  for (j in 1:nrow(seqtab)){
    if (seqtab[j,i]!=0){
      ids <- c(ids, paste0("'",rownames(seqtab)[j],"'",": ",seqtab[j,i],", ", collapse = ""))
    } 
  } 
  ids_per_seq[[i]]  <- paste0("seq",i," count=",count,"; merged_sample={",gsub(paste0(ids,collapse = ""),pattern=",\\s$",replacement=""),"} ")
}
names(ids_per_seq) <- colnames(seqtab)

uniquesToFasta(unqs=getUniques(seqtab),
               fout=snakemake@output[[1]],
               ids=unlist(ids_per_seq))