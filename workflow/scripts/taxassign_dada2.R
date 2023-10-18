# taxassign
log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(dada2)
library(stringr)

cleaned_seq <- getSequences(snakemake@input[[1]])
tab <- data.frame(seq_id = str_extract(names(cleaned_seq),"(?<=; cluster=).+(?=;)"),
                  sequence=cleaned_seq,
                  abundance=str_extract(names(cleaned_seq),"(?<= count=)[0-9]"))

tabseq<- makeSequenceTable(tab)

to_split <- seq(1, ncol(tabseq), by = 15000)
to_split2 <- c(to_split[2:length(to_split)]-1, ncol(tabseq))

taxtab = NULL

for(i in 1:length(to_split)){
  seqtab2 <- tabseq[, to_split[i]:to_split2[i]]
  taxtab2 <- assignTaxonomy(seqtab2, 
                            refFasta = snakemake@params[[2]], 
                            multithread = snakemake@params[[1]],
                            outputBootstraps = T)
  if(!is.null(taxtab)){taxtab <- rbind(taxtab, taxtab2)}
  if(is.null(taxtab)){taxtab <- taxtab2}
}


final_out <- NULL
for(i in 1:(length(taxtab)/2)){
  tax_out <- cbind(sequences=rownames(taxtab[[i]]),taxtab[[i]])
  boot_out <- taxtab[[i+length(taxtab)/2]]
  colnames(boot_out) <- paste0(colnames(boot_out),"_boots")
  tmp_out <- cbind(tax_out,boot_out)
  final_out <- rbind(final_out,tmp_out)
}

write.csv2(final_out, snakemake@output[[1]],row.names = F)