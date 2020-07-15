# Things to do before the Workshop

## Install Singularity or make sure you can access it
[On NeSI](https://support.nesi.org.nz/hc/en-gb/articles/360001107916-Singularity)
[Windows](https://sylabs.io/guides/3.0/user-guide/installation.html#install-on-windows-or-mac)
[Mac](https://sylabs.io/guides/3.0/user-guide/installation.html#install-on-windows-or-mac)
[Linux](https://sylabs.io/guides/3.0/user-guide/installation.html#install-on-linux)

## Download Containers
Containers are available on NeSI at: ...path...
If working remote, you can download them from [Google Drive](https://drive.google.com/drive/folders/1QpyTKDd4FIBoRaNKieCCbySyNVGvzGkv?usp=sharing)

## Download Data
[from Google Drive](https://drive.google.com/drive/folders/1RQ2PxqP7y8REgPbBqMEikn25fhBwSxw3?usp=sharing)

And also from SRA

Download SRA SRR8452644 and rename to Psa_M228_1.fastq.gz and Psa_M228_2.fastq.gz
```bash
mkdir Sequence
cd Sequence
fasterq-dump SRR8177059
mv SRR8177059_1.fastq Psa_M228_1.fastq
mv SRR8177059_2.fastq Psa_M228_2.fastq
pigz Psa_M228_1.fastq
pigz Psa_M228_2.fastq
```

** 
* Check that you can run containers

* Check md5sum of downloaded data

# Refresher
Have a refresher in [BASH](https://linuxconfig.org/bash-scripting-tutorial-for-beginners)