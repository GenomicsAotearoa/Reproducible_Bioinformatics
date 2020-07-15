## Why use containers

- **portability**: run your analysis without installing software
- **reproducibility**: capture the software required to repeat your work

## Container software

![Docker](https://www.docker.com/sites/default/files/d8/2019-07/horizontal-logo-monochromatic-white.png)

![Singularity](https://sylabs.io/assets/svg/singularity-logo.svg)

## Singularity or Docker

- singularity is HPC-friendly and compatible with docker containers


## Use software without installing it

- example?
- don't need admin rights to install

```bash
singularity exec funnanotate.sif \
    funannotate predict \
    -i my_assembly.fasta
```

## Use software without compiling it

- 

## Use software that has a lot of dependencies

- HPC admins may not be willing / able to install messy software
- *e.g.* `funannotate` has dozens of dependencies (this is a subset)

```bash
singularity exec funnanotate.sif \
    funannotate predict \
    -i my_assembly.fasta
```

## Use software that needs newer libraries (or newer than in repos?)

```bash
$ apt policy spades
spades:
  Installed: (none)
  Candidate: 3.13.0+dfsg2-2
  Version table:
     3.13.0+dfsg2-2 500
        500 http://nz.archive.ubuntu.com/ubuntu eoan/universe amd64 Packages
```

- example?

## Use software on unsupported systems

- *e.g.* `MinKNOW` on unsupported versions of Linux

## Live demo goes here

## Where to find containers

### shub

### docker hub, quay.io

- singularity is compatible with docker containers

![](../img/screenshot-hub.docker.com-2020.02.11-13_39_25.png)

### biocontainers

### build them yourself

```bash
Bootstrap: docker
From: ubuntu:18.10

%post
    apt-get update
    apt-get install -y bwa
%runscript
    exec /usr/bin/bwa "$@"
```

## How to use containers transparently (workflow managers)

```
nextflow example here
```


```python3
rule trim_adaptors:
    input:          'data/raw_reads/{sample}.fastq'
    output:         'output/trimmed/{sample}.fastq'
    singularity:    'docker://my_repos/trim_adaptors:2.9'
    shell:          'trim_adaptors --raw_reads={input} > {output}'
```


## What is a container

Ultra brief, maybe show a recipe

##

*More information*: <a href="https://github.com/GenomicsAotearoa/Reproducible_Bioinformatics/blob/master/1.Introduction/slides.pdf">Presentation</a> by Tom Harrop at eResearch2020.
