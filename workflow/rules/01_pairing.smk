# SPLIT FASTQ
checkpoint split_fastq:
    input:
        R1=config["resourcesfolder"]+"{run}/{run}_R1.fastq",
        R2=config["resourcesfolder"]+"{run}/{run}_R2.fastq"
    output:
        directory(config["resultsfolder"]+"{run}/splitted_fastq")
    params:
        folder=config["resultsfolder"]+"{run}/splitted_fastq",
        nfiles=config["split_fastq"]["nfiles"],
        R1=config["resultsfolder"]+"{run}/splitted_fastq/{run}_R1",
        R2=config["resultsfolder"]+"{run}/splitted_fastq/{run}_R2"
    conda:
        "../envs/obi_env.yaml"
    shell:
        """
        mkdir -p {params.folder}
        obidistribute -n {params.nfiles} -p {params.R1} {input.R1}
        obidistribute -n {params.nfiles} -p {params.R2} {input.R2}
        """


# PAIRING
rule pairing:
    input:
        R1=config["resultsfolder"]+"{run}/splitted_fastq/{run}_R1_{n}.fastq",
        R2=config["resultsfolder"]+"{run}/splitted_fastq/{run}_R2_{n}.fastq"
    output:
        temp(config["resultsfolder"]+"{run}/splitted_fastq/{run}_R1R2_{n}.fastq")
    conda:
        "../envs/obi_env.yaml"
    shell:
        """
        illuminapairedend -r {input.R2} {input.R1} > {output}
        """


# AGGREGATE
def aggregate_R1R2(wildcards):
    checkpoint_output=checkpoints.split_fastq.get(**wildcards).output[0]
    file_names=temp(expand(config["resultsfolder"]+"{{run}}/splitted_fastq/{{run}}_R1R2_{n}.fastq", n=glob_wildcards(os.path.join(checkpoint_output, "{run}_R1_{n}.fastq")).n))
	# print('in_def_aggregate_R1R2')
	# print(checkpoint_output)
	# print(glob_wildcards(os.path.join(checkpoint_output, "{run}_R1_{n}.fastq")).n)
	# print(file_names)
    return file_names
	

# MERGE PAIRED FILES
rule merge_paired:
    input:
        aggregate_R1R2
    output:	
        config["resultsfolder"]+"{run}/{run}_R1R2.fastq"
    params:
        splittedfastq=config["resultsfolder"]+"{run}/splitted_fastq"
    shell:
        """
        cat {input} > {output}
        rm -r {params.splittedfastq}
        """
