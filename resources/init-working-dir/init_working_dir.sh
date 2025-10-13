#!/bin/bash
set -o nounset
set -o errexit

#
# Initializes the working directory.
#
# INPUTS:
# $1 : path to working dir.
#

if [ $# -ne 1 ]; then
	echo '[ERROR]: This script requires one argument (the path to the working dir)'
	exit 1
fi

sslash () {
  echo ${1} | tr -s '/'
}

wd=$(sslash "$1/")

if [[ -d "${wd}" && ! -z "$(ls -A "${wd}")" ]];then
	echo '[WARNING]: Selected working dir already exist and it is not empty'
	echo '           Please select another location or remove the existing one'
	exit 1
fi

if [ ! -d "${wd}" ]; then
	mkdir -p "${wd}"
fi

cp "/resources/init-working-dir/compi.params" "${wd}/compi.params"
cp "/resources/init-working-dir/run.sh" "${wd}/run.sh"
cp "/resources/init-working-dir/README.txt" "${wd}/README.txt"
cp "/resources/init-working-dir/pipeline.png" "${wd}/pipeline.png"
cp -R "/resources/init-working-dir/params" "${wd}/params"
mkdir -p "${wd}/input"
touch "${wd}/query"
touch "${wd}/query1"

echo "Working directory initialized at: ${wd}"
echo "Have a look at the README.txt file inside for further instructions."
