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
- Download data

### Data

Download from?

```bash
wget 
```

### Step 1. 

- [adaptor removal](https://github.com/jguhlin/nextflow-training/blob/master/scripts/1_processing.nf)

```
singularity exec adapterremoval_2.1.3.sif \
    AdapterRemoval \
        --file1 ${reads[0]} \
        --file2 ${reads[1]} \
        --threads 6 \
        --basename ${strain} \
        --gzip \
        --collapse
```

### Step 2.

- [assembly](https://github.com/jguhlin/nextflow-training/blob/master/scripts/2_assemble.nf)

```
singularity exec spades_3.14.1.sif \
    spades.py \
        -o output \
        -1 ${pair1} -2 ${pair2} \
        --merged ${collapsed} \
        -s ${singletons} \
        -t 4 \
        -m 64 \
        --careful
```

### Step 3.

- annotation?

### Step 4.

Comparison

