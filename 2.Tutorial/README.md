## Tutorial: genome assembly of diatom Chr 17

### Overview

- Use containers to trim and assemble some Nanopore reads from Chromosome 17 of the diatom *Thalassiosira pseudonana*
- Data and steps are from [Tim Kahlke's](https://www.uts.edu.au/staff/tim.kahlke) great [Introduction to Long-Read Data Analysis](https://timkahlke.github.io/LongRead_tutorials/).
- No software needed other than `singularity`!

### Setup

- Check `-B` arguments in case of weird paths to working directory.
- Get these containers onto computers (don't rely on `shub`).  
The containers should be in the root directory.
    + `porechop_0.2.4.sif`
    + `minimap2_2.17r941.sif`
    + `miniasm_0.3r179.sif`
    + `bbmap_38.76.sif`
    + `funannotate-conda_1.7.4.sif`
- Download data (`data/all_guppy.fastq`), it's stored on GH using Git LFS

### Step 1.

Trim adaptors and chimeric reads

```bash
mkdir run && cd run
```

<!-- shub://TomHarrop/ont-containers:porechop_0.2.4 -->

```bash
singularity exec \
    ../porechop_0.2.4.sif \
    porechop \
    --check_reads 100 \
    -t 8 \
    --discard_middle \
    -i ../data/all_guppy.fastq \
    -o trimmed.fastq
```

Check what we are assembling

```bash
singularity exec \
    ../bbmap_38.76.sif \
    stats.sh \
    in=trimmed.fastq
```

### Step 2.

All-vs-all alignment with `minimap2`

<!-- shub://TomHarrop/singularity-containers:minimap2_2.17r941 -->

```bash
singularity exec \
    ../minimap2_2.17r941.sif \
    minimap2 \
    -x ava-ont \
    trimmed.fastq trimmed.fastq \
    | pigz -1 > minimap.paf.gz
```

Unitig assembly with `miniasm`

<!-- shub://TomHarrop/singularity-containers:miniasm_0.3r179 -->

## look up -f
## show versions

```bash
singularity exec \
    ../miniasm_0.3r179.sif \
    miniasm -f \
    trimmed.fastq \
    minimap.paf.gz > miniasm.gfa
```

Extract fasta

```bash
awk '/^S/{print ">"$2"\n"$3}' miniasm.gfa > miniasm.fasta
```

### Step 3.

Assembly QC

<!-- shub://TomHarrop/seq-utils:bbmap_38.76 -->

```bash
singularity exec \
    ../bbmap_38.76.sif \
    stats.sh \
    in=miniasm.fasta
```

### Using containers with workflow managers

Example rule to run miniasm inside a singularity container

```python3
rule miniasm:
    input:
        fq = 'output/trimmed.fastq',
        paf = 'output/minimap.paf.gz'
    output:
        'output/miniasm.gfa'
    singularity:
        # usually a URL for a container stored remotely, e.g
        # shub://TomHarrop/miniasm_0.3r176
        # docker://TomHarrop/miniasm_0.3r176
        'miniasm_0.3r179.sif'
    shell:
        'miniasm -f '
        '{input.fq} '
        '{input.paf} '
        '> {output}'
```

Run the same workflow with containers

```bash
cd ../2.Tutorial/
cp ../data/all_guppy.fastq .
ls -lhrt

snakemake --cores 8         # doesn't run because missing porechop
snakemake --cores 8 --use-singularity
```

### Further steps

![](../img/screenshot-funannotate.readthedocs.io-2020.06.25-16_11_20.png "Funannotate dependencies")

<!-- shub://TomHarrop/funannotate-singularity:funannotate-conda_1.7.4 -->

```bash
singularity exec \
    ../funannotate-conda_1.7.4.sif \
    bash -c ' \
    funannotate mask \
    -i miniasm.fasta \
    -o masked.fasta \
    --cpus 8 '
```


