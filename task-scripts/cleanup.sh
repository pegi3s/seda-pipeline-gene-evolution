#!/bin/bash

# Make sure all results are accessible
chmod -R 777 "${workingDirectory}/results"

echo "Performing cleanup of temporary files and directories (/tmp)"

rm -rf /tmp/seda*
rm -rf /tmp/slot-file-download_genomes-*

if [ ! -v ${skip_cleanup} ]; then
    echo "Skipping cleanup as skip_cleanup=true"
    exit 0
fi

echo "Performing cleanup of intermediate files and directories (work_dir/output)"

rm -rf ${workingDirectory}/output
