Channel.fromFilePairs("../sequences/*_{1,2}.fastq.gz")
        .into { fastqc_input_ch; trimming_input_ch }

process fastQC {
    conda 'bioconda::fastqc'
    cpus 6
    time '30m'
    memory '16 GB'
    queue 'large'

    input:
        set strain, file(reads) from fastqc_input_ch

    output:
        file("*_fastqc.zip") into fastqc_output_ch
    
    """
        mkdir output
        fastqc -o . \
        -f fastq \
        -t 6 \
        ${reads}
    """
}

process MultiQC_fastq {
    conda 'bioconda::multiqc'
    publishDir './MultiQC_output'

    cpus 1
    time '10m'
    memory '8 GB'
    queue 'large'

    input:
        file(fastqc_out) from fastqc_output_ch.collect()

    output:
        file("multiqc_report.html")
        file("multiqc_data")

    """
    multiqc .
    """
}

process AdapterRemovalV2 {
    conda 'bioconda::adapterremoval'
    cpus 6
    time '30m'
    memory '32 GB'
    queue 'large'

    publishDir './processed/', mode: 'copy'
    input: 
        set strain, file(reads) from trimming_input_ch

    output:
        set val(strain), file("${strain}.*") into processed_reads_ch
        file("${strain}.settings") into qc_report_ch

    """
    AdapterRemoval \
        --file1 ${reads[0]} \
        --file2 ${reads[1]} \
        --threads 6 \
        --basename ${strain} \
        --gzip \
        --collapse
    """
}

process MultiQC_trimmed {
    conda 'bioconda::multiqc'
    publishDir './Processing_MultiQC_output'

    cpus 1
    time '20m'
    memory '8 GB'
    queue 'large'

    input:
        file(settings_out) from qc_report_ch.collect()

    output:
        file("multiqc_report.html")
        file("multiqc_data")

    """
    multiqc .
    """
}

process runMegahitAssembler {
    conda 'bioconda::megahit'
    cpus 6
    time '20m'
    memory '8 GB'
    queue 'large'
    publishDir "./Assemblies", mode: 'copy'
    input: 
        set sequence_id, file(files) from processed_reads_ch
    
    output:
        file("${sequence_id}.contigs.fa") into assemblies_ch

    // collapsed, pair1, pair2, singletons

    // TODO: Get the error, then come back and add the renaming...

    """
    zcat *collapsed*gz > merged.fq
    mv ${sequence_id}.pair1.truncated.gz pair1.fq.gz
    mv ${sequence_id}.pair2.truncated.gz pair2.fq.gz
    mv ${sequence_id}.singleton.truncated.gz singles.fq.gz
    
    megahit -1 pair1.fq.gz -2 pair2.fq.gz \
        -r merged.fq,singles.fq.gz \
        -t 6 \
        -o output \
        --out-prefix ${sequence_id}
    mv output/${sequence_id}.contigs.fa ${sequence_id}.contigs.fa
    """
}

process ProdigalAnnotate {

        cpus 1
        time '15m'
        memory '12 GB'
        queue 'large'
	container '/home/josephguhlin/development/Reproducible_Bioinformatics/2.Tutorial/0.Preparation/prodigal_latest.sif'
	publishDir "proteins"

        tag { "${assembly.baseName}" }
        input:
              	file(assembly) from assemblies_ch
        output:
               	file("*.faa") into proteins_ch


"""
prodigal -f gff -a ${assembly.baseName}.faa -i ${assembly}
"""

}
