# rm bimera
log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(dada2)
library(stringr)

cleaned_seq <- getSequences(snakemake@input[[1]])
tab <- data.frame(seq_id = str_extract(names(cleaned_seq),"seq[0-9]+"),sequence=cleaned_seq, abundance=str_extract(names(cleaned_seq),"(?<= count=)[0-9]"))

tabseq<- makeSequenceTable(tab)
tabseqnochim <- removeBimeraDenovo(tabseq,
                                   verbose=T,
                                   multithread=snakemake@params[[1]])
tabseqnochim <- getUniques(tabseqnochim)

fasta_headers <- NULL
for (i in 1:length(tabseqnochim)){
  fasta_headers <- c(fasta_headers,names(cleaned_seq)[which(cleaned_seq==names(tabseqnochim)[i])] )
} 

uniquesToFasta(unqs=tabseqnochim,
               fout=snakemake@output[[1]],
               ids=fasta_headers)