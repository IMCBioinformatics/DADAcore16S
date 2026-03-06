rule fasta_file:
    input:
        seqtab =rules.removeChimeras.output.rds
    output:
        seqfasta=config["output_dir"]+"/fasta_files/ASVs_seqs.fasta"
    threads:
        config['threads']
    singularity:
        "apptainer/dada2-1.0.0.sif"
    script:
        "../scripts/dada2/fastaGeneration.R"
