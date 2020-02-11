# 1. Reproducible bioinformatics

- Bionformaticians incl.
    + Biologists doing computational analysis
    + Mathemeticians writing algorithms
    + CompSci implementing algorithms
    + etc.
- Aim: give an overview of a software stack that makes it easier for users (not computer scientists) to make their research reproducible

# 2. Is there a reproducibility crisis?

- Intro lifted from Jenny Bryan's talk on code maintenance
- Nature news survey of 1500 "researchers" in 2016
- Most researchers think there is a crisis in reproducibility
- Many labs aren't doing anything about it
- It's up to us users to try to use good practices

# 3. What is reproducibility?

- **For this talk**: ability to re-run the analysis and get the exact same result
- This is sometimes called "replicability"
- For bioinformatics, ability to run the same analysis on the same data and get the same result
- In bioinformatics we are doing calculations which means we should be able to get the **exact same answer**, not just qualitatively but quantitatively too
- even randomness in algorithms can be captured by setting the seed for the random number generator
- *e.g.* not just the same list of differentially expressed genes, but the same L2FC values down to *n* decimal places
- I think of it as "correctness" for my analysis: if I can't get the same answer from the same data, am I sure my analysis was correct?
- There are three guidelines that I think go a long way to doing reproducibly bioinformatics
- Will go over my approach (a user!)

# 4. Take care peeking at the data

- "Don't modify the raw data" is probably easy enough
- I think most people are chucking their raw data on long-term storage and not working on it directly
- Worth noting that sometimes even *looking* at the data can modify it
- Classic paper describing the well-known phenomenon of MS Excel (and other spreadsheet software) **changes gene names when the file is opened**. If you accidentally save changes, your gene names are lost forever! 

# 5. Point-and-click software

- In terms of recording the analysis, anything point-and-click is unlikely to be reproducible
- This is because mouse clicks and interactive keyboard input are not usually recorded
- This example is NCBI's online local alignment search server
- Unless we document which dropdown items we select, and any custom Entrez queries, we may not be able to reproduce the same results
- This is not meant to discourage the use of this software! I use BLAST to explore my results every day. But, we may be unable to reproduce the results

# 6. Running ad-hoc analysis

- Similarly if we run our analysis without recording it and/or without capturing the environment, we may not be able to reproduce the results
- For example if we install software on our personal machines, or in our `$HOME` on shared machines, it may not run elsewhere
- Similarly if the sysadmins install software for us on a compute node or make it available as a module, will it be possible to run elsewhere?
- In terms of recording the steps
- If we run our analysis interactively, i.e. just type the commands into the console, we may not have full documentation of which commands and arguments we ran
- Most bioinformaticians have probably been in the situation where someone has shown some results, been asked "did you use argument X or Y", and been unable to remember or not had a record
- I guess most bioinformaticians have had that colleague *and* been that colleague
- I think a common solution is to save commands in text files, but then we have to be sure we copy and paste the commands or run the scripts in the correct order, or record any interactive hacking we do when our initial attempts don't run

# 7. Workflow managers

- This is an overview of how workflow managers work
- The steps of the workflow are defined in a workflow file
- The workflow manager reads the file and determines which steps to run to produce the desired output
- Generally, each step is described by the input files, the output files, and the command needed to make the transformation
- In this toy example (pseudocode), when I run the workflow\_manager, I tell it to use the workflow file my\_workflow to do the job run\_assembly,  the workflow manager determines that it needs the output of `trim\_adaptors` before it can `run\_assembly`, so it runs steps in that order
- Ideally the workflow manager monitors dependencies so if the input data or an intermediate file or the input data changes, steps are re-run as necessary

# 8. Reproducibility and convenience

- if the code is recorded in this way the results are actually disposable: we can just trash the output and run the workflow again to regenerate it
- there is no need to document the code because it is recorded in the workflow file
- convenience gain: the workflows can be written so the same step is run identically on different inputs
- in general workflow managers are so convenient that i don't teach bash to students coming into the lab, any more.
- if we put the workflow file under version control (e.g. git), then we can keep a versioned copy of the results
- plenty of good workflow managers to chose from, we can pick one we are comfortable with

# 9. Reproducible computing environment 1

- capturing the computing environment is the next layer of reproducibility
- a lot of software depends on other software
- e.g. DESeq2, for differential gene expression analysis, relies on the R Bioconductor suite (3.10.1 on my computer), and the Basic Linear Algebra system library (v.3.8.0 on my computer)
- it's not just a theoretical problem, e.g. samtools (extremely widely used) changed its UI in the past, and cuffdiff (differential expression algorithm) famously changed under-the-hood between versions, leading to completely different results

# 10. Software containers

- Compute environment can be captured using software containers, which essentially act like a mini operating system, bundling up the software with all its dependencies
- Running software in containers gives you mobility (can use the container anywhere) and reproducibility (results always the same because dependencies are contained)
- Docker is popular for cloud computing, Singularity is also popular with academic users and can run securely on traditional hardware

# 11. Getting software in containers

- Best case is when the developers provide an "official" container, as with Salmon read quantification tool
- Singularity also supports Docker containers

# 12. Getting software in containers

- More often we have to build our own containers
- This is essentially the same as installing it locally
- We write the steps to install the software in a "recipe" file
- In this case I am starting with the base Ubuntu image from Docker hub, and in the `%post` section we just install the Burrows-Wheeler Alignment software from the software repository
- The recipe file gets uploaded to a third-party builder which stores the built container, and provides a hash, meaning we can use the same container every time

# 14. Workflow managers support containers and clusters

- the big payoff is that workflow managers support running inside containers
- in this toy `snakemake` workflow, we're using a docker hub image for the trim\_adaptors software and a singularity hub image for the choice\_assembler software
- snakemake will automatically and transparently handle pulling the containers and running the shell command inside the container


# 13. Some barriers to container usage

- Some bioinformatics software is really hard to install
- I guess installing it in a container is no harder than installing it locally, but it can be slower when we incrementally build the container and it fails repeatedly
- At the moment it's **mainly** up to users to build containers, which means there are probably many `bwa` containers out there
- A better model would be encouraging developers to provide official Docker builds. I think this is achievable as uptake increases, and maybe with some direct action. 
- DTU (University of Technology Denmark) and Georgia Tech have released software with home-made licenses that prohibit distributing them in containers
- Some commercial products like the "Genetic Information Research Institute" RepeatMasker database simply cannot be put in a container, leading to a choice between reproducibility and the software
- Singularity is actually very easy to install but you may have to convince sysadmins to install it


# 15. Reproducible analysis stack

- I'm borrowing some out of context silicon valley jibberish and calling this a reproducible analysis stack
- To summarise:
    + you don't need anything to not modify the raw data
    + it's not a terrible idea to record the checksum, or make sure the data is read only
    + `snakemake` and `git` provide versioned record of the code
    + software containers capture the environment
- should allow the analysis to be fully reproducible
- only external dependencies for this particular stack are python3, singularity and git





- convenience of WF managers (reuse the same code for all data)

- check academic twitter for complaints about conda

- workflow managers allow you to run singularity transparently

**Reproducible analysis stack**
- requirements: singularity + python3 + git

# Pain points of reproducible genomics

- Slow initially
- Convince the sysadmins to install Singularity
- Getting software in containers
- Duplication of effort

# Who cares / why

- most of the time you are the only one who reproduces your results
- bonus to containers is easy installation / portability

**DO NOT SAY YOU**