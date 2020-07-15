## Live demo

### Overview

- Use containers to trim and assemble some Nanopore reads from a diatom
- No software needed other than `singularity`

### Setup

- Dini to handle this?
- Check `-B` arguments in case of weird paths to working directory.
- Get these containers onto computers (don't rely on `shub`):
    + `porechop_0.2.4.sif`
    + `minimap2_2.17r941.sif`
    + `miniasm_0.3r179.sif`
    + `bbmap_38.76.sif`
- Download data (`data/all_guppy.fastq`)

### Step 1.

Trim adaptors and chimeric reads

```
singularity exec \
    porechop_0.2.4.sif \
    porechop \
    --check_reads 100 \
    -t 8 \
    --discard_middle \
    -i all_guppy.fastq \
    -o trimmed.fastq
```

### Step 2.

All-vs-all alignment with `minimap2`

```
singularity exec \
    minimap2_2.17r941.sif \
    minimap2 \
    -x ava-ont \
    trimmed.fastq trimmed.fastq \
    | pigz -1 > minimap.paf.gz
```

Unitig assembly with `miniasm`

```
singularity exec \
    miniasm_0.3r179.sif \
    miniasm -f \
    trimmed.fastq \
    minimap.paf.gz > miniasm.gfa
```

Extract fasta

```
awk '/^S/{print ">"$2"\n"$3}' miniasm.gfa > miniasm.fasta
```

### Step 3.

Assembly QC

```
singularity exec \
    bbmap_38.76.sif \
    stats.sh \
    in=miniasm.fasta
```


