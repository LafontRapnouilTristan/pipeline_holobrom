# BASIC FILTRATION
rule basicfilt:
    input:
        config["resultsfolder"]+"{run}/{run}"+"_R1R2_good_demultiplexed_derepl.fasta"
    output:
        config["resultsfolder"]+"{run}/{run}"+"_R1R2_good_demultiplexed_derepl_basicfilt.fasta"
    params:
        minlength=config["basicfilt"]["minlength"],
        mincount=config["basicfilt"]["mincount"]
    log:
        "log/"+"{run}"+"/basicfilt.log"
    conda:
        "../envs/obi_env.yaml"
    shell:
        """
        obiannotate --length -S 'GC_content:len(str(sequence).replace("a","").replace("t",""))*100/len(sequence)' {input} | obigrep -l {params.minlength} -s '^[acgt]+$' > {output} 2> {log}
        """
