#!/bin/bash

if [ -d "${workingDirectory}/${output}/${task_id}/${accession}/prosplign-procompart" ]; then
	echo "Output directory for prosplign-procompart already exists. Skipping execution to avoid overwriting existing data."
	exit 0
fi

if [ ! -d "${workingDirectory}/${output}/download-genomes/${accession}/ncbi_dataset/data/${accession}" ]; then
	echo "ERROR: Genome data for accession ${accession} not found. Please run the download_genomes task first or check error logs."
	exit 0
fi

. ${scriptsDir}/functions.sh

message "Running ${task_id} for accession ${accession}"

# Run prosplign-procompart
SEDA_OPERATION_NAME="prosplign-procompart"
INPUT_FILE=$(ls ${workingDirectory}/${output}/download-genomes/${accession}/ncbi_dataset/data/${accession}/* | head -1)
OUTPUT=${workingDirectory}/${output}/${task_id}/${accession}/prosplign-procompart
PARAMS=$(get_params "prosplign-procompart")
run_seda "${SEDA_OPERATION_NAME}" "${INPUT_FILE}" "${OUTPUT}" "${PARAMS}"

mkdir -p ${workingDirectory}/${input}/lists
# TODO: check if ${OUTPUT} is not empty so that it does not fail and guarantee that exists with 0 exit code always
ls -1 ${OUTPUT}/* >> ${workingDirectory}/${input}/lists/remove-redundant_2.txt
