# TAB FORMATTING
rule tab_format:
  input:
    folder_prefix+files_prefix+"_R1R2_good_demultiplexed_derepl_basicfilt_cl_agg.fasta"
  output:
    folder_prefix+files_prefix+"_R1R2_good_demultiplexed_derepl_basicfilt_cl_agg.tab"
  benchmark:
    "benchmarks/"+files_prefix+"/tabformat.txt"   
  log:
    "log/"+files_prefix+"/tab_format.log"
  conda:
    "../envs/obi_env.yaml"
  shell:
    """
    obitab -n NA -d -o {input} > {output} 2> {log}
    """