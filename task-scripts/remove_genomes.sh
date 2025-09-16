#!/bin/bash

echo "Removing genome for accession ${accession}"

rm -rf ${workingDirectory}/output/download-genomes/${accession}
