SEDA-Compi gene-evolution - Working directory quickstart
========================================================

This directory is ready to run the gene-evolution pipeline (getorf/BLAST and ProSplign-ProCompart).

Contents:
- compi.params   -> Pipeline parameters (edit this before running).
- run.sh         -> Script to launch the pipeline (do not move).
- pipeline.png   -> Pipeline graph.
- params/        -> Default SEDA operation parameters.
- input/         -> Place input data here (see below).
- query          -> FASTA used for BLAST (required).
- query1         -> FASTA used for ProSplign-ProCompart.


1) Prepare inputs
-----------------
There are two ways to start the pipeline (choose ONE):

A) Using downloaded NCBI files (extract_files path)
   - Put the CGA/CGF ZIP files exactly as downloaded from NCBI under:
       input/extract_files/
   - The pipeline will extract and process them.

B) Downloading genomes on-the-fly (download_genomes path)
   - Create a text file with accessions (one per line) at:
       input/accessions_list.txt
   - To limit concurrent genomes on disk, set 'max_tasks' in compi.params
     (default = 1 keeps disk usage low).

Also, you must provide these query FASTA files:
- query (BLAST): headers MUST be in the form ">Gene Description".
  Example:
    >FOXD2 XP_016006825_2
    >D1B XP_015992634_2
    >mesogenin1 XP_016009398_2
- query1 (ProSplign-ProCompart).


2) Configure the pipeline
-------------------------
- Open compi.params and review parameters.
  Tips:
  - Set 'skip_prosplign_procompart' to skip the ProSplign-ProCompart branch.
  - Adjust 'max_tasks' to control how many genomes are processed simultaneously
    when using download_genomes.
  - Review other parameters in params/ as needed.


3) Run the pipeline
-------------------
From this directory, run one of the following:

- Basic run:
    ./run.sh "$(pwd)"

- Run a single task with 2 parallel executions (example):
    ./run.sh "$(pwd)" "--single-task extract-files --num-tasks 2"

- Partial execution between two tasks (example):
    ./run.sh "$(pwd)" "--from getorf --until blast_merge"

Notes for download_genomes mode:
- If input/accessions_list.txt has X lines, run with --num-tasks X so all
  accessions are processed.
- 'max_tasks' in compi.params limits how many genomes are downloaded/processed
  at once to save disk space.


4) Outputs
----------
- Final results:   results/
- Intermediate:    output/
