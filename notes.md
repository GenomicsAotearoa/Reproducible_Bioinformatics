# 1. Reproducible bioinformatics

- Bionformaticians incl.
    + Biologists doing computational analysis
    + Mathemeticians writing algorithms
    + CompSci implementing algorithms
    + etc.

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
- How users (not computer scientists) can use a software stack to make their research reproducible

# 4. Take care peeking at the data

- "Don't modify the raw data" is probably easy enough
- I think most people are chucking their raw data on long-term storage and not working on it directly
- Worth noting that sometimes even *looking* at the data can modify it
- Classic paper describing the well-known phenomenon of MS Excel (and other spreadsheet software) **changes gene names when the file is opened**. If you accidentally save changes, your gene names are lost forever! 

# 5. Point-and-click software

- In terms of recording the analysis, anything point-and-click is unlikely to be reproducible
- This is because mouse clicks and interactive keyboard input are not usually recorded
- This example is NCBI's online local alignment search server
- Unless you document which dropdown items you select, and any custom Entrez queries you may not be able to reproduce the same results
- This is not meant to discourage the use of this software! I use BLAST to explore my results every day. But, be aware you may be unable to reproduce the results

# 6. Running ad-hoc analysis

- Similarly if you run your analysis without recording it and/or without capturing the environment, you may not be able to reproduce your results
- For example if you install software on your personal machine, or in your `$HOME` on shared machines, it may not run for others
- Similarly if the sysadmins install software for you on a compute cluster or make it available as a module, will it be possible to run the same elsewhere?
- In terms of recording the steps
- If we run our analysis interactively, i.e. just type the commands into the console, we may not have full documentation of which commands and arguments we ran
- Most bioinformaticians have probably been in the situation where someone has shown some results, been asked "did you use argument X or Y", and been unable to remember or not had a record
- I guess most bioinformaticians have had that colleague *and* been that colleague
- I think a common solution is to save commands in text files, but then we have to be sure we copy and paste the commands or run the scripts in the correct order, or record any interactive hacking we do when our initial attempts don't run

# 7. Workflow managers

- This is an overview of how workflow managers work
- 


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