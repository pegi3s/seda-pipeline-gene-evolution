#!/bin/bash

if [ -d "${workingDirectory}/${output}/${task_id}/${accession}/getorf" ]; then
	echo "Output directory for getorf and BLAST already exists. Skipping execution to avoid overwriting existing data."
	exit 0
fi

if [ ! -d "${workingDirectory}/${output}/download-genomes/${accession}/ncbi_dataset/data/${accession}" ]; then
	echo "ERROR: Genome data for accession ${accession} not found. Please run the download_genomes task first or check error logs."
	exit 0
fi

. ${scriptsDir}/functions.sh

message "Running ${task_id} for accession ${accession}"

# Run getorf
SEDA_OPERATION_NAME="getorf"
INPUT_FILE=$(ls ${workingDirectory}/${output}/download-genomes/${accession}/ncbi_dataset/data/${accession}/* | head -1)
OUTPUT=${workingDirectory}/${output}/${task_id}/${accession}/getorf
PARAMS=$(get_params "getorf")
run_seda "${SEDA_OPERATION_NAME}" "${INPUT_FILE}" "${OUTPUT}" "${PARAMS}"

# Run blast
SEDA_OPERATION_NAME="blast"
INPUT_FILE=$(ls ${OUTPUT}/* | head -1)
OUTPUT=${workingDirectory}/${output}/${task_id}/${accession}/blast
PARAMS=$(get_params "blast_1")
run_seda "${SEDA_OPERATION_NAME}" "${INPUT_FILE}" "${OUTPUT}" "${PARAMS}"

mkdir -p ${workingDirectory}/${input}/lists
ls -1 ${OUTPUT}/* >> ${workingDirectory}/${input}/lists/remove-redundant_1.txt
