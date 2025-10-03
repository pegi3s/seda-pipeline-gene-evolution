#!/bin/bash
# Replace spaces by underscores

mkdir -p ${workingDirectory}/${output}/replace_1 >/dev/null 2>&1
cp ${workingDirectory}/${output}/rename-ncbi_1/* ${workingDirectory}/${output}/replace_1 >/dev/null 2>&1

# Some accessions have an inconvenient "_" between letters and numbers in the second accession part, e.g. 
# GCF_014176215.1_NW_023416291.1. We temporarily replace such "_"s by "-REPLACE-BACK-" to avoid problems in the next steps
# and put them back in blast_merge
sed -i -E 's/(_GC[AF]_[0-9]+\.[0-9]+_[A-Z]+)_([0-9]+)/\1-REPLACE-BACK-\2/g' ${workingDirectory}/${output}/replace_1/* >/dev/null 2>&1

sed -i 's/ /_/g' ${workingDirectory}/${output}/replace_1/* >/dev/null 2>&1
sed -i 's/\./_/g' ${workingDirectory}/${output}/replace_1/* >/dev/null 2>&1
