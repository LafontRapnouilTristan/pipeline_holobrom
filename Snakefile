# Snakemake workflow

__author__ = "Tristan Lafont Rapnouil"
__email__ = "tristan.lafontrapnouil@gmail.com"

"""
DESCRIPTION

This is a snakemake workflow that analyzes DNA metabarcoding data with the OBITools and SUMACLUST.

"""
configfile:"config/config.yml"
report:"report/workflow.rep"

if config["tomerge"]:
  folder_prefix=config["resultsfolder"]+config["mergedfile"]+"/"
  folder_prefix2=folder_prefix
  files_prefix=config["mergedfile"]
else:
  folder_prefix=config["resultsfolder"]+"{run}/"
  folder_prefix2=config["resultsfolder"]+"{{run}}/"
  files_prefix="{run}"


# GET FINAL OUTPUT(S)
def get_input_all():
        if config["tomerge"]:
                inputfiles=[folder_prefix+files_prefix+"_R1R2_good_demultiplexed_derepl_basicfilt_cl_agg.fasta",
                folder_prefix+files_prefix+"_R1R2_good_demultiplexed_derepl_basicfilt_cl_agg.tab",
                folder_prefix+files_prefix+"_taxassigned.csv"]
        else:
                inputfiles=[expand("{folder}{run}/{run}_R1R2_good_demultiplexed_derepl_basicfilt_cl_agg.fasta", run=config["fastqfiles"], folder=config["resultsfolder"]),
                expand("{folder}{run}/{run}_R1R2_good_demultiplexed_derepl_basicfilt_cl_agg.tab", run=config["fastqfiles"], folder=config["resultsfolder"]),
                expand("{folder}{run}/{run}_taxassigned.csv", run=config["fastqfiles"], folder=config["resultsfolder"])]
        return inputfiles



rule all:
        input:
                get_input_all()

include: "workflow/rules/01_pairing.smk"
include: "workflow/rules/02_sort_alignments.smk"
include: "workflow/rules/03_demultiplexing.smk"
include: "workflow/rules/04_derep.smk"
include: "workflow/rules/05_basic_filtration.smk"
include: "workflow/rules/06_clustering.smk"
include: "workflow/rules/07_merge_clust.smk"
include: "workflow/rules/08_taxassign.smk"
include: "workflow/rules/08_format_out.smk"
