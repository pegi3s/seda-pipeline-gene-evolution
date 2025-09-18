#!/bin/bash

echo "Performing cleanup"

rm -rf ${workingDirectory}/output

# Make sure all results are accessible
chmod -R 777 "${workingDirectory}/results"
