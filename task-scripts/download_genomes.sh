#!/bin/bash

if [ -d ${workingDirectory}/output/getorf_and_blast/${accession} ]; then
    echo "Accession ${accession} has been already processed."
    exit 0
fi

echo "Downloading genome for accession ${accession}"

mkdir -p ${workingDirectory}/output/download-genomes/${accession}

# Retry mechanism for download
attempt=1
max_retries=${max_download_retries:-3}  # Default to 3 retries if parameter not set
zip_file="${workingDirectory}/output/download-genomes/${accession}/${accession}.zip"

while [ $attempt -le $max_retries ]; do
    echo "Download attempt $attempt of $max_retries for accession ${accession}"
    
    # Remove any partial download from previous attempts
    [ -f "$zip_file" ] && rm "$zip_file"
    
    docker run --rm \
        -v ${workingDirectory}:${workingDirectory} \
            pegi3s/ncbi-datasets:18.7.0 \
                datasets download genome accession ${accession} \
                    --exclude-atypical \
                    --assembly-version latest \
                    --filename ${zip_file}
    
    # Check if the zip file was successfully created
    if [ -f "$zip_file" ] && [ -s "$zip_file" ]; then
        echo "Successfully downloaded ${accession}.zip on attempt $attempt"
        break
    else
        echo "Download failed on attempt $attempt. File not created or is empty."
        if [ $attempt -eq $max_retries ]; then
            echo "ERROR: Failed to download ${accession}.zip after $max_retries attempts"
            exit 1
        fi
        attempt=$((attempt + 1))
        echo "Retrying download in 60 seconds..."
        sleep 60
    fi
done

echo "Extracting ${accession}.zip"
if unzip -q "$zip_file" -d ${workingDirectory}/output/download-genomes/${accession}/; then
    echo "Successfully extracted ${accession}.zip"
    rm "$zip_file"
    echo "Genome download and extraction completed successfully for accession ${accession}"
    exit 0
else
    echo "ERROR: Failed to extract ${accession}.zip"
    exit 1
fi
