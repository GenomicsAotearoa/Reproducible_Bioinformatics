## Live demo

### Overview

- Use containers to assemble, annotate and compare genomes
- No software needed other than `singularity`

### Setup

- Dini to handle this?
- Check `-B` arguments in case of weird paths to working directory.
- Get these containers onto computers (don't rely on `shub`):
    + `shub://TomHarrop/seq-utils:adapterremoval_2.1.3`
    + `shub://TomHarrop/assembles:spades_3.14.1`
    + TODO: Make into a container [Prodigal](https://github.com/hyattpd/Prodigal)
- Download data

### Data

Download SRA SRR8452644 and rename to Ps_Cucurbits_1.fastq.gz and Ps_Cucurbits_2.fastq.gz

```bash
mkdir Sequence
cd Sequence
fasterq-dump SRR8177059
mv SRR8177059_1.fastq Psa_M228_1.fastq
mv SRR8177059_2.fastq Psa_M228_2.fastq
pigz Psa_M228_1.fastq
pigz Psa_M228_2.fastq
```

### Step 1. 

- [adaptor removal](https://github.com/jguhlin/nextflow-training/blob/master/pieces/tutorial.md)

```
singularity exec adapterremoval_2.1.3.sif \
    AdapterRemoval \
        --file1 Sequence/Psa_M228_1.fastq \
        --file2 Sequence/Psa_M228_2.fastq \
        --threads 12 \
        --basename Psa_M228 \
        --gzip \
        --collapse
```

### Step 2.
*Use megahit instead?*
- [assembly](https://github.com/jguhlin/nextflow-training/blob/master/pieces/tutorial.md)

```
zcat *collapsed*gz > Psa_M228_merged.fq
pigz Psa_M228_merged.fq
singularity run megahit_latest.sif \
    -1 Psa_M228.pair1.truncated.gz -2 Psa_M228.pair2.truncated.gz \
    -r Psa_M228_merged.fq.gz,Psa_M228.singleton.truncated.gz \
    -t 12 \
    -o Psa_M228_assembly \
    --out-prefix Psa_M228
```

Output:
```
singularity run ~/megahit_latest.sif \
    -1 Psa_M228.pair1.truncated.gz -2 Psa_M228.pair2.truncated.gz \
    -r Psa_M228_merged.fq.gz,Psa_M228.singleton.truncated.gz \
    -t 12 \
    -o Psa_M228_assembly \
    --out-prefix Psa_M228
2020-07-13 13:28:27 - MEGAHIT v1.2.9
2020-07-13 13:28:27 - Using megahit_core with POPCNT and BMI2 support
2020-07-13 13:28:27 - Convert reads to binary library
2020-07-13 13:28:44 - INFO  sequence/io/sequence_lib.cpp  :   77 - Lib 0 (/home/josephguhlin/development/Reproducible_Bioinformatics/2.Tutorial/0.Preparation/Psa_M228/Psa_M228.pair1.truncated.gz,/home/josephguhlin/development/Reproducible_Bioinformatics/2.Tutorial/0.Preparation/Psa_M228/Psa_M228.pair2.truncated.gz): pe, 16546326 reads, 100 max length
2020-07-13 13:28:46 - INFO  sequence/io/sequence_lib.cpp  :   77 - Lib 1 (/home/josephguhlin/development/Reproducible_Bioinformatics/2.Tutorial/0.Preparation/Psa_M228/Psa_M228_merged.fq.gz): se, 1025515 reads, 189 max length
2020-07-13 13:28:46 - INFO  sequence/io/sequence_lib.cpp  :   77 - Lib 2 (/home/josephguhlin/development/Reproducible_Bioinformatics/2.Tutorial/0.Preparation/Psa_M228/Psa_M228.singleton.truncated.gz): se, 139078 reads, 100 max length
2020-07-13 13:28:46 - INFO  utils/utils.h                 :  152 - Real: 19.7988	user: 15.7158	sys: 2.0564	maxrss: 277400
2020-07-13 13:28:46 - k-max reset to: 141 
2020-07-13 13:28:46 - Start assembly. Number of CPU threads 12 
2020-07-13 13:28:46 - k list: 21,29,39,59,79,99,119,141 
2020-07-13 13:28:46 - Memory used: 121610833920
2020-07-13 13:28:46 - Extract solid (k+1)-mers for k = 21 
2020-07-13 13:29:52 - Build graph for k = 21 
2020-07-13 13:29:54 - Assemble contigs from SdBG for k = 21
2020-07-13 13:29:59 - Local assembly for k = 21
2020-07-13 13:30:17 - Extract iterative edges from k = 21 to 29 
2020-07-13 13:30:25 - Build graph for k = 29 
2020-07-13 13:30:26 - Assemble contigs from SdBG for k = 29
2020-07-13 13:30:28 - Local assembly for k = 29
2020-07-13 13:30:44 - Extract iterative edges from k = 29 to 39 
2020-07-13 13:30:49 - Build graph for k = 39 
2020-07-13 13:30:50 - Assemble contigs from SdBG for k = 39
2020-07-13 13:30:52 - Local assembly for k = 39
2020-07-13 13:31:09 - Extract iterative edges from k = 39 to 59 
2020-07-13 13:31:14 - Build graph for k = 59 
2020-07-13 13:31:15 - Assemble contigs from SdBG for k = 59
2020-07-13 13:31:17 - Local assembly for k = 59
2020-07-13 13:31:33 - Extract iterative edges from k = 59 to 79 
2020-07-13 13:31:38 - Build graph for k = 79 
2020-07-13 13:31:38 - Assemble contigs from SdBG for k = 79
2020-07-13 13:31:41 - Local assembly for k = 79
2020-07-13 13:31:58 - Extract iterative edges from k = 79 to 99 
2020-07-13 13:32:01 - Build graph for k = 99 
2020-07-13 13:32:01 - Assemble contigs from SdBG for k = 99
2020-07-13 13:32:04 - Local assembly for k = 99
2020-07-13 13:32:20 - Extract iterative edges from k = 99 to 119 
2020-07-13 13:32:22 - Build graph for k = 119 
2020-07-13 13:32:23 - Assemble contigs from SdBG for k = 119
2020-07-13 13:32:25 - Local assembly for k = 119
2020-07-13 13:32:40 - Extract iterative edges from k = 119 to 141 
2020-07-13 13:32:42 - Build graph for k = 141 
2020-07-13 13:32:42 - Assemble contigs from SdBG for k = 141
2020-07-13 13:32:44 - Merging to output final contigs 
2020-07-13 13:32:44 - 429 contigs, total 6368447 bp, min 202 bp, max 229945 bp, avg 14844 bp, N50 51753 bp
2020-07-13 13:32:44 - ALL DONE. Time elapsed: 257.920622 seconds
```

*Ignore Spades I think*
```
singularity exec spades_3.14.1.sif \
    spades.py \
        -o output \
        -1 Psa_M228.pair1.truncated.gz -2 Psa_M228.pair2.truncated.gz \
        --merged Psa_M228_merged.fq.gz \
        -s Psa_M228.singleton.truncated.gz \
        -t 12 \
        -m 64 \
        --careful
```

### Step 3.

```
singularity run prodigal_latest.sif \
    prodigal \
    -f gff \
    -a Psa_M228.faa \
    -i Psa_M228_assembly/Psa_M228.contigs.fa > Psa_M228.gff3
```

Output:
```
-------------------------------------
PRODIGAL v2.6.3 [February, 2016]         
Univ of Tenn / Oak Ridge National Lab
Doug Hyatt, Loren Hauser, et al.     
-------------------------------------
Request:  Single Genome, Phase:  Training
Reading in the sequence(s) to train...6373595 bp seq created, 58.35 pct GC
Locating all potential starts and stops...394836 nodes
Looking for GC bias in different frames...frame bias scores: 0.69 0.16 2.14
Building initial set of genes to train from...done!
Creating coding model and scoring nodes...done!
Examining upstream regions and training starts...done!
-------------------------------------
Request:  Single Genome, Phase:  Gene Finding
Finding genes in sequence #1 (243 bp)...done!
Finding genes in sequence #2 (282 bp)...done!
Finding genes in sequence #3 (286 bp)...done!
Finding genes in sequence #4 (582 bp)...done!
Finding genes in sequence #5 (625 bp)...done!
... and more
```

### Step 4.



