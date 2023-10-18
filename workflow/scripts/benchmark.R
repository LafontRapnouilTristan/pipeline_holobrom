# Benchmark plotting
log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(ggplot2)
library(ggpubr)

#bench_files <- list.files(path = ,full.names = T)
bench <- do.call(rbind, lapply(unlist(snakemake@input), read.table, sep="\t",header=T))
bench$steps <- gsub(basename(unlist(snakemake@input)),pattern=".txt",replacement = "")


plot_list <- list()
log_list <- list()
for (i in 1:(ncol(bench)-1)){
  log_list[[i]] <- local({
    i <- i
    if (i>2&&i<7){
      val <- log(bench[,i]+1)
      name <- paste0("log_",names(bench)[i])
    }
    else{
      val <- bench[,i]
      name <- names(bench)[i]
    } 
    
    ggplot(bench,aes(y=val, x=steps,color=steps)) +
      geom_point()+
      theme(panel.grid.major.x = element_blank()) +
      theme(axis.text.x = element_text(angle = 45))+
      theme(axis.title.x = element_blank())+
      ylab(name)
    
  })  
  
  
  plot_list[[i]] <- local({
    i <- i
    val <- bench[,i]
    name <- names(bench)[i]
    ggplot(bench,aes(y=val, x=steps,color=steps)) +
      geom_point()+
      theme(panel.grid.major.x = element_blank()) +
      theme(axis.text.x = element_text(angle = 45))+
      theme(axis.title.x = element_blank())+
      ylab(name)
  })
}

plot_bench <- ggarrange(plotlist = plot_list,ncol = 3,nrow=ceiling(i/3))
plot_log <- ggarrange(plotlist = log_list,ncol = 3,nrow=ceiling(i/3))
ggsave(plot_bench,filename = snakemake@output[[1]], device = "png", height = 10, width = 10)
ggsave(plot_log,filename = snakemake@output[[2]], device = "png", height = 10, width = 10)
write.csv2(bench,snakemake@output[[3]],row.names = F)