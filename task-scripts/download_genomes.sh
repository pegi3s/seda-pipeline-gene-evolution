#!/bin/bash

if [ -d ${workingDirectory}/${output}/getorf_and_blast/${accession} ]; then
    echo "Accession ${accession} has been already processed."
    exit 0
fi

echo "Downloading genome for accession ${accession}"

mkdir -p ${workingDirectory}/${output}/download-genomes/${accession}

# Retry mechanism for download
attempt=1
max_retries=${max_download_retries:-3}  # Default to 3 retries if parameter not set
zip_file="${workingDirectory}/${output}/download-genomes/${accession}/${accession}.zip"

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
    
    # Check if the zip file was successfully created and is valid
    if [ -f "$zip_file" ] && [ -s "$zip_file" ] && unzip -t "$zip_file" >/dev/null 2>&1; then
        echo "Successfully downloaded and verified ${accession}.zip on attempt $attempt"
        break
    else
        if [ -f "$zip_file" ]; then
            echo "Download failed on attempt $attempt. File exists but is corrupted or incomplete."
        else
            echo "Download failed on attempt $attempt. File not created or is empty."
        fi
        if [ $attempt -eq $max_retries ]; then
            echo "ERROR: Failed to download ${accession}.zip after $max_retries attempts"
            echo ${accession} >> ${workingDirectory}/${output}/download-genomes/failed_downloads.txt
            rm -rf ${workingDirectory}/${output}/download-genomes/${accession}
            exit 0
        fi
        attempt=$((attempt + 1))
        echo "Retrying download in 60 seconds..."
        sleep 60
    fi
done

echo "Extracting ${accession}.zip"
if unzip -q "$zip_file" -d ${workingDirectory}/${output}/download-genomes/${accession}/; then
    echo "Successfully extracted ${accession}.zip"
    rm "$zip_file"
    echo "Genome download and extraction completed successfully for accession ${accession}"

    # Extract filenames
    for file in $(find ${workingDirectory}/${output}/download-genomes/${accession}/ -name "*fna"); do
        filename=$(basename "$file")

        # Extract the pattern (GCF/GCA followed by numbers)
        match=$(echo "$filename" | sed -n 's/.*\(GCF_[0-9]\+\(\.[0-9]\+\)\?\|GCA_[0-9]\+\(\.[0-9]\+\)\?\).*/\1/p')
        sed -i "/>/ s/>/>${match}_/g" "${file}"
    done
    exit 0
else
    echo "ERROR: Failed to extract ${accession}.zip"
    exit 1
fi
