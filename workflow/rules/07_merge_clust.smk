# MERGE CLUSTERS
rule merge_clust:
  input:
    folder_prefix+files_prefix+"_R1R2_good_demultiplexed_derepl_basicfilt_cl.fasta"
  output:
    folder_prefix+files_prefix+"_R1R2_good_demultiplexed_derepl_basicfilt_cl_agg.fasta"
  benchmark:
    "benchmarks/"+files_prefix+"/merge_clust.txt" 
  log:
    "log/"+files_prefix+"/merge_clust.log"
  conda:
    "../envs/obi_env.yaml"
  shell:
    """
    obiselect -c cluster -n 1 --merge sample -M -f count {input} > {output} 2> {log}
    """