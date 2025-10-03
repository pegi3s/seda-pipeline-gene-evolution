#!/bin/bash

if [ -f "${workingDirectory}/${output}/download-genomes/failed_downloads.txt" ]; then
    if [ -s "${workingDirectory}/${output}/download-genomes/failed_downloads.txt" ]; then
        echo "The following accessions failed to download in the download_genomes task:"
        cat "${workingDirectory}/${output}/download-genomes/failed_downloads.txt"
        echo "Please check the error logs for more details."
        exit 1
    else
        echo "No failed downloads detected."
    fi
else
    echo "No failed downloads detected."
fi