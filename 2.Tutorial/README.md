## Live demo

### Overview

- Use containers to assemble, annotate and compare genomes
- No software needed other than `singularity`

### Setup

- Dini to handle this?
- Check `-B` arguments in case of weird paths to working directory.
- Get these containers onto computers (don't rely on `shub`):
    + `shub://TomHarrop/seq-utils:adapterremoval_2.1.3`
    + [Prodigal](https://github.com/hyattpd/Prodigal)
- Download data

### Step 1. 
Adapter Removal and Collapsing

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
Assemble with MegaHit

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

### Step 3.
Predict Genes with Prodigal

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
Compare Assemblies with QUAST
```
singularity run ../quast_latest.sif quast Assemblies/*fa --glimmer -t 32
```


### Step 5.
Compare Proteomes with OrthoFinder
```
singularity run ../orthofinder_latest.sif orthofinder -t 32 -f proteins/

less -S \
    proteins/OrthoFinder/Results_Jul13_1/Comparative_Genomics_Statistics/Statistics_Overall.tsv

less -S \
    proteins/OrthoFinder/Results_Jul13_1/Comparative_Genomics_Statistics/   Statistics_PerSpecies.tsv

cat proteins/OrthoFinder/Results_Jul13_1/Species_Tree/SpeciesTree_rooted.txt 
```
Copy the newick tree. It will look like: ```((Pst.contigs:0.0247923,Ps_Cucurbits.contigs:0.0371305)0.9008:0.0203521,((Psa_M228.contigs:0.00120068,(Psa_C3.contigs:0.000848172,(Psa_C14.contigs:0.000135925,((Psa_C10.contigs:0.000169986,Psa_C11.contigs:0.000140465)0.661419:4.6123e-05,Psa_C12.contigs:0.000226006)0.646677:7.04282e-06)0.651174:0.000926819)0.63943:0.000758788)0.772864:0.0223033,Ps_DC3000.contigs:0.0162112)0.9008:0.0203521);
```
Go to [icytree](icytree.org) and press *e*
Paste in your tree and click *Done*

Output:
```
OrthoFinder version 2.3.12 Copyright (C) 2014 David Emms

2020-07-13 14:32:24 : Starting OrthoFinder
64 thread(s) for highly parallel tasks (BLAST searches etc.)
1 thread(s) for OrthoFinder algorithm

Checking required programs are installed
----------------------------------------
Test can run "mcl -h" - ok
Test can run "fastme -i /home/josephguhlin/development/Reproducible_Bioinformatics/2.Tutorial/0.Preparation/do_prep/proteins/OrthoFinder/Results_Jul13_1/WorkingDirectory/SimpleTest.phy -o /home/josephguhlin/development/Reproducible_Bioinformatics/2.Tutorial/0.Preparation/do_prep/proteins/OrthoFinder/Results_Jul13_1/WorkingDirectory/SimpleTest.tre" - ok

Dividing up work for BLAST for parallel processing
--------------------------------------------------
2020-07-13 14:32:25 : Creating diamond database 1 of 9
2020-07-13 14:32:25 : Creating diamond database 2 of 9
2020-07-13 14:32:25 : Creating diamond database 3 of 9
2020-07-13 14:32:25 : Creating diamond database 4 of 9
2020-07-13 14:32:25 : Creating diamond database 5 of 9
2020-07-13 14:32:25 : Creating diamond database 6 of 9
2020-07-13 14:32:25 : Creating diamond database 7 of 9
2020-07-13 14:32:25 : Creating diamond database 8 of 9
2020-07-13 14:32:25 : Creating diamond database 9 of 9

Running diamond all-versus-all
------------------------------
Using 64 thread(s)
2020-07-13 14:32:25 : This may take some time....
2020-07-13 14:32:25 : Done 0 of 81
2020-07-13 14:33:02 : Done 10 of 81
2020-07-13 14:34:33 : Done all-versus-all sequence search

Running OrthoFinder algorithm
-----------------------------
2020-07-13 14:34:34 : Initial processing of each species
2020-07-13 14:34:40 : Initial processing of species 0 complete
2020-07-13 14:34:46 : Initial processing of species 1 complete
2020-07-13 14:35:00 : Initial processing of species 2 complete
2020-07-13 14:35:13 : Initial processing of species 3 complete
2020-07-13 14:35:38 : Initial processing of species 4 complete
2020-07-13 14:35:54 : Initial processing of species 5 complete
2020-07-13 14:36:07 : Initial processing of species 6 complete
2020-07-13 14:36:14 : Initial processing of species 7 complete
2020-07-13 14:36:19 : Initial processing of species 8 complete
2020-07-13 14:36:29 : Connected putative homologues
2020-07-13 14:36:30 : Written final scores for species 0 to graph file
2020-07-13 14:36:32 : Written final scores for species 1 to graph file
2020-07-13 14:36:34 : Written final scores for species 2 to graph file
2020-07-13 14:36:37 : Written final scores for species 3 to graph file
2020-07-13 14:36:41 : Written final scores for species 4 to graph file
2020-07-13 14:36:45 : Written final scores for species 5 to graph file
2020-07-13 14:36:48 : Written final scores for species 6 to graph file
2020-07-13 14:36:49 : Written final scores for species 7 to graph file
2020-07-13 14:36:51 : Written final scores for species 8 to graph file
Exception RuntimeError: RuntimeError('cannot join current thread',) in <Finalize object, dead> ignored

WARNING: program called by OrthoFinder produced output to stderr

Command: mcl /home/josephguhlin/development/Reproducible_Bioinformatics/2.Tutorial/0.Preparation/do_prep/proteins/OrthoFinder/Results_Jul13_1/WorkingDirectory/OrthoFinder_graph.txt -I 1.5 -o /home/josephguhlin/development/Reproducible_Bioinformatics/2.Tutorial/0.Preparation/do_prep/proteins/OrthoFinder/Results_Jul13_1/WorkingDirectory/clusters_OrthoFinder_I1.5.txt -te 1 -V all

stdout
------

stderr
------
[mcl] cut <95> instances of overlap

2020-07-13 14:37:07 : Ran MCL

Writing orthogroups to file
---------------------------
OrthoFinder assigned 79628 genes (92.1% of total) to 9551 orthogroups. Fifty percent of all genes were in orthogroups with 9 or more genes (G50 was 9) and were contained in the largest 3008 orthogroups (O50 was 3008). There were 4002 orthogroups with all species present and 2290 of these consisted entirely of single-copy genes.

2020-07-13 14:37:10 : Done orthogroups

Analysing Orthogroups
=====================

Calculating gene distances
--------------------------
2020-07-13 14:38:54 : Done

Inferring gene and species trees
--------------------------------
2020-07-13 14:38:54 : Done 0 of 7197
2020-07-13 14:38:54 : Done 1000 of 7197
2020-07-13 14:38:55 : Done 2000 of 7197
2020-07-13 14:38:55 : Done 3000 of 7197
2020-07-13 14:38:56 : Done 4000 of 7197
2020-07-13 14:38:56 : Done 5000 of 7197
2020-07-13 14:38:57 : Done 6000 of 7197
2020-07-13 14:38:57 : Done 7000 of 7197

4002 trees had all species present and will be used by STAG to infer the species tree

Best outgroup(s) for species tree
---------------------------------
2020-07-13 14:40:02 : Starting STRIDE
2020-07-13 14:40:04 : Done STRIDE
Observed 10 well-supported, non-terminal duplications. 10 support the best root and 0 contradict it.
Best outgroup for species tree:
  Ps_Cucurbits.contigs, Pst.contigs

Reconciling gene trees and species tree
---------------------------------------
Outgroup: Ps_Cucurbits.contigs, Pst.contigs
2020-07-13 14:40:04 : Starting Recon and orthologues
2020-07-13 14:40:04 : Starting OF Orthologues
Exception RuntimeError: RuntimeError('cannot join current thread',) in <Finalize object, dead> ignored
2020-07-13 14:40:06 : Done 0 of 7197
2020-07-13 14:40:25 : Done 1000 of 7197
2020-07-13 14:40:30 : Done 2000 of 7197
2020-07-13 14:40:34 : Done 3000 of 7197
2020-07-13 14:40:39 : Done 4000 of 7197
2020-07-13 14:40:43 : Done 5000 of 7197
2020-07-13 14:40:46 : Done 6000 of 7197
2020-07-13 14:40:48 : Done 7000 of 7197
2020-07-13 14:40:48 : Done OF Orthologues
2020-07-13 14:40:49 : Done Recon

Writing results files
=====================
2020-07-13 14:40:49 : Done orthologues

Results:
    /home/josephguhlin/development/Reproducible_Bioinformatics/2.Tutorial/0.Preparation/do_prep/proteins/OrthoFinder/Results_Jul13_1/

CITATION:
 When publishing work that uses OrthoFinder please cite:
 Emms D.M. & Kelly S. (2019), Genome Biology 20:238

 If you use the species tree in your work then please also cite:
 Emms D.M. & Kelly S. (2017), MBE 34(12): 3267-3278
 Emms D.M. & Kelly S. (2018), bioRxiv https://doi.org/10.1101/267914

________________________________________________________
Executed in  508.02 secs   fish           external 
   usr time   57.13 mins  714.00 micros   57.13 mins 
   sys time    3.05 mins   59.00 micros    3.05 mins 

```
