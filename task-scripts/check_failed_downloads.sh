#!/bin/bash

# Function to check for failed accessions in a specific task
check_failed_accessions() {
    local task_id="$1"
    accessions_file="${workingDirectory}/${output}/_failed/${task_id}/failed_accessions.txt"

    if [ -d "${workingDirectory}/${output}/_failed/${task_id}/" ]; then
        if [ -f ${accessions_file} ]; then
            if [ -s ${accessions_file} ]; then
                echo "The following accessions failed in the ${task_id} task:"
                cat ${accessions_file}
                echo "Please check the error logs for more details."
                exit 1
            fi
        fi
    fi
}

if [ -f "${workingDirectory}/${output}/download-genomes/failed_downloads.txt" ]; then
    if [ -s "${workingDirectory}/${output}/download-genomes/failed_downloads.txt" ]; then
        echo "The following accessions failed to download in the download_genomes task:"
        cat "${workingDirectory}/${output}/download-genomes/failed_downloads.txt"
        echo "Please check the error logs for more details."
        exit 1
    else
        echo "No failed downloads detected in the download_genomes task."
    fi
else
    echo "No failed downloads detected in the download_genomes task."
fi

check_failed_accessions "getorf_and_blast"
check_failed_accessions "prosplign_procompart"
echo "No failed downloads or processing detected."
