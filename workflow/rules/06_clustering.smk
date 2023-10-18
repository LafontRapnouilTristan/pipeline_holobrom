if config["tomerge"]:
  # MERGE LIBRARIES
  rule merge_demultiplex:
    input:
      expand(config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_derepl_basicfilt.fasta", run=config["fastqfiles"])
    output:
        config["resultsfolder"]+config["mergedfile"]+"/"+config["mergedfile"]+"_R1R2_good_demultiplexed_derepl_basicfilt.fasta"
    log:
        "log/merge_demultiplex_"+config["mergedfile"]+".log"
    shell:
      """
      cat {input} > {output} 2> {log}
        """

# CLUSTERING
rule otu_clust:
  input:
    folder_prefix+files_prefix+"_R1R2_good_demultiplexed_derepl_basicfilt.fasta"
  output:
    folder_prefix+files_prefix+"_R1R2_good_demultiplexed_derepl_basicfilt_cl.fasta"
  params:
    minsim = config["clustering"]["minsim"],
    threads = config["clustering"]["cores"]
  benchmark:
    "benchmarks/"+files_prefix+"/clust.txt" 
  log:
    "log/"+files_prefix+"/clustering.log"
  conda:
    "../envs/suma_env.yaml"
  shell:
    """
    sumaclust -t {params.minsim} -p {params.threads} {input} > {output}
    """