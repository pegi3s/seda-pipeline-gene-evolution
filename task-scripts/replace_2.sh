#!/bin/bash

# Replace spaces by underscores

mkdir -p ${workingDirectory}/${output}/replace_2 >/dev/null 2>&1
cp ${workingDirectory}/${output}/remove-redundant_2/* ${workingDirectory}/${output}/replace_2 >/dev/null 2>&1

# Some accessions have an inconvenient "_" between letters and numbers in the second accession part, e.g. 
# GCF_014176215.1_NW_023416291.1. We temporarily replace such "_"s by "-REPLACE-BACK-" to avoid problems in the next steps
# and put them back in replace_3
sed -i -E 's/(GC[AF]_[0-9]+\.[0-9]+_[A-Z]+)_([0-9]+)/\1-REPLACE-BACK-\2/g' ${workingDirectory}/${output}/replace_2/* >/dev/null 2>&1

sed -i 's/_/ /g' ${workingDirectory}/${output}/replace_2/* >/dev/null 2>&1
sed -i 's/GCA /_GCA_/g' ${workingDirectory}/${output}/replace_2/* >/dev/null 2>&1
sed -i 's/GCF /_GCF_/g' ${workingDirectory}/${output}/replace_2/* >/dev/null 2>&1
sed -i -E 's/\.([0-9]+) /_\1_/g' ${workingDirectory}/${output}/replace_2/* >/dev/null 2>&1
sed -i -E 's/ \(from ([0-9]+) ([0-9]+)\) /_\(\1-\2\)_/g' ${workingDirectory}/${output}/replace_2/* >/dev/null 2>&1
