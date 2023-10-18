# DEMULTIPLEXING
rule demultiplex:
    input:
        config["resultsfolder"]+"{run}/{run}_R1R2_good.fastq"
    output:
        demultiplexed=config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed.fasta",
        unassigned=config["resultsfolder"]+"{run}/{run}_R1R2_good_unassigned.fasta"
    params:
        ngs=config["resourcesfolder"]+"{run}/{run}_ngsfilter.tab"
    benchmark:
        "benchmarks/{run}/deml.txt"
    log:
        "log/{run}/demultiplex.log"
    conda:
        "../envs/obi_env.yaml"
    shell:
        """
        obiannotate --without-progress-bar --sanger -S 'Avgqphred:-int(math.log10(sum(sequence.quality)/len(sequence))*10)' {input} | ngsfilter --fasta-output -t {params.ngs} -u {output.unassigned} > {output.demultiplexed} 2> {log}
        """