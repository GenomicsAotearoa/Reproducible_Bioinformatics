accessions = [ ["Psa_M228", "SRR8177059"],
               ["Psa_C10", "SRR5196223"],
               ["Psa_C3", "SRR5196224"],
               ["Psa_C11", "SRR5196222"],
               ["Psa_C12", "SRR5196221"],
               ["Psa_C12", "SRR5196220"],
               ["Psa_C14", "SRR5196219"],
               ["Ps_AC811", "SRR10199044"],
               ["Ps_Cucurbits", "SRR8452644"],
               ["Ps_DC3000", "SRR10199043"],
               ["Pst", "SRR9943114"]]

accessions_ch = Channel.from(accessions)

process downloadAndRename {

    publishDir "./sequences", mode: 'copy'

    input: 
        set val(name), val(SRR) from accessions_ch

    output: 
        file("*.gz")

    """
    echo ${name}
    echo ${SRR}
    /home/josephguhlin/software/sratoolkit.2.10.8-ubuntu64/bin/fasterq-dump ${SRR}
    mv ${SRR}_1.fastq ${name}_1.fastq
    mv ${SRR}_2.fastq ${name}_2.fastq
    pigz ${name}_1.fastq
    pigz ${name}_2.fastq
    """
}
