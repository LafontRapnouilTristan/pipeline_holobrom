# taxassign
rule taxassign:
  input:
    folder_prefix+files_prefix+"_R1R2_good_demultiplexed_derepl_basicfilt_cl_agg.fasta"
  output:
    folder_prefix+files_prefix+"_taxassigned.csv"
  params:
    config["taxassign"]["multithread"],
    config["taxassign"]["tax_file_"+files_prefix]
  benchmark:
    "benchmarks/"+files_prefix+"/taxassign.txt" 
  log:
    "log/"+files_prefix+"/taxassign.log"
  conda:
    "../envs/R_env.yaml"
  script:
    "../scripts/taxassign_dada2.R"