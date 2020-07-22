# Preparation

You'll need the following if you want to follow along with the tutorial:

## Install Singularity

Instructions for using singularity on

- [NeSI](https://support.nesi.org.nz/hc/en-gb/articles/360001107916-Singularity)
- [Windows](https://sylabs.io/guides/3.0/user-guide/installation.html#install-on-windows-or-mac)
- [Mac](https://sylabs.io/guides/3.0/user-guide/installation.html#install-on-windows-or-mac)
- [Linux](https://sylabs.io/guides/3.0/user-guide/installation.html#install-on-linux)

## Download required containers

The containers are available on NeSI (Mahuika) at `/opt/nesi/containers/training`:

- `porechop_0.2.4.sif`
- `minimap2_2.17r941.sif`
- `miniasm_0.3r179.sif`
- `gfatools_0.4r165`
- `bbmap_38.76.sif`

## Download tutorial data

Download the raw data for the tutorial [from this github repo](https://github.com/GenomicsAotearoa/Reproducible_Bioinformatics/raw/master/data/all_guppy.fastq), or from your terminal:

```bash
wget \
    https://github.com/GenomicsAotearoa/Reproducible_Bioinformatics/raw/master/data/all_guppy.fastq
```

Make sure the download worked:

```bash
md5sum all_guppy.fastq 
# 457b8aecf94bb285e5bb672c8d7e182f  all_guppy.fastq
```

## Refresher

[bash refresher](https://linuxconfig.org/bash-scripting-tutorial-for-beginners)
