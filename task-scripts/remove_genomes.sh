#!/bin/bash

echo "Removing genome for accession ${accession}"

if [ -d ${workingDirectory}/output/download-genomes/${accession} ]; then
    echo "Genome directory for accession ${accession} found. Proceeding with removal."
else
    echo "No genome directory found for accession ${accession}. Nothing to remove."
    exit 0
fi

rm -rf ${workingDirectory}/output/download-genomes/${accession}

rm -rf /tmp/${accession}*fasta
