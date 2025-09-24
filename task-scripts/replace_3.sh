#!/bin/bash

mkdir -p ${workingDirectory}/output/replace_3 >/dev/null 2>&1
cp ${workingDirectory}/output/merge_2/* ${workingDirectory}/output/replace_3 >/dev/null 2>&1

sed -i 's/-REPLACE-BACK-/_/g' ${workingDirectory}/output/replace_3/*
