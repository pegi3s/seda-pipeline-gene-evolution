#!/bin/bash
# Replace spaces by underscores

mkdir -p ${workingDirectory}/output/replace_1 >/dev/null 2>&1
cp ${workingDirectory}/output/rename-ncbi_1/* ${workingDirectory}/output/replace_1 >/dev/null 2>&1
sed -i 's/ /_/g' ${workingDirectory}/output/replace_1/* >/dev/null 2>&1
sed -i 's/\./_/g' ${workingDirectory}/output/replace_1/* >/dev/null 2>&1
