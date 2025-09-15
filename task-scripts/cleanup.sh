#!/bin/bash

echo "Performing cleanup"

rm -rf ${workingDirectory}/output ${workingDirectory}/input/getorf ${workingDirectory}/input/replace_1 ${workingDirectory}/input/replace_2 ${workingDirectory}/input/prosplign-procompart ${workingDirectory}/input/reformat_2

# Make sure all results are accessible
chmod -R 777 "${workingDirectory}/results"
