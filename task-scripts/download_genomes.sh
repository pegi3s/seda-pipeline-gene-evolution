#!/bin/bash

if [ -d ${workingDirectory}/output/getorf_and_blast/${accession} ]; then
    echo "Accession ${accession} has been already processed."
    exit 0
fi

echo "Downloading genome for accession ${accession}"

mkdir -p ${workingDirectory}/output/download-genomes/${accession}

docker run --rm \
    -v ${workingDirectory}:${workingDirectory} \
        pegi3s/ncbi-datasets:18.7.0 \
            datasets download genome accession ${accession} \
                --exclude-atypical \
                --assembly-version latest \
                --filename ${workingDirectory}/output/download-genomes/${accession}/${accession}.zip

unzip ${workingDirectory}/output/download-genomes/${accession}/${accession}.zip \
    -d ${workingDirectory}/output/download-genomes/${accession}/

rm ${workingDirectory}/output/download-genomes/${accession}/${accession}.zip
