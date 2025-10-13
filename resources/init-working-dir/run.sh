#!/bin/bash

WORKING_DIR=${1}
COMPI_PARAMS=${2:-""}

function info() {
    tput setaf 2
	echo -e "[INFO] [run.sh] ${1}"
	tput sgr0
}

function show_error() {
	tput setaf 1
	echo -e "${1}"
	tput sgr0
}

if [ $# -ne 1 ] && [ $# -ne 2 ]; then
	show_error "[ERROR]: This script requires one or two arguments (working directory and, optionally, Compi CLI parameters)"
	exit 1
fi

info "Running SEDA-Compi pipeline at ${WORKING_DIR}"

if [ ! -d "${WORKING_DIR}" ]; then
    show_error "[ERROR]: Working directory ${WORKING_DIR} does not exist"
    exit 1
fi

PIPELINE_PARAMS_FILE=""
if [ -f "${WORKING_DIR}/compi.params" ]; then
    PIPELINE_PARAMS_FILE="--params ${WORKING_DIR}/compi.params"
    info "Pipeline parameters found at ${WORKING_DIR}/compi.params"
fi

DOCKER_ENV_PARAMS=""
if [ ! -z "${SEDA_JAVA_MEMORY}" ]; then
    DOCKER_ENV_PARAMS="-e SEDA_JAVA_MEMORY=${SEDA_JAVA_MEMORY}"
    info "Docker environment parameters: ${DOCKER_ENV_PARAMS}"
fi

# Check for accessions_list.txt and --num-tasks parameter
ACCESSIONS_FILE="${WORKING_DIR}/input/accessions_list.txt"
if [ -f "${ACCESSIONS_FILE}" ]; then
    info "Found accessions file at ${ACCESSIONS_FILE}"
    
    # Check if --num-tasks is specified in COMPI_PARAMS
    if [[ ! "${COMPI_PARAMS}" =~ --num-tasks[[:space:]]+([0-9]+) ]]; then
        show_error "[ERROR]: accessions_list.txt found but --num-tasks parameter is missing in COMPI_PARAMS"
        show_error "Please include --num-tasks X where X is the number of tasks"
        exit 1
    fi
    
    # Extract the number from --num-tasks
    NUM_TASKS=$(echo "${COMPI_PARAMS}" | grep -oP '(?<=--num-tasks\s)[0-9]+')
    
    # Count non-empty lines in accessions_list.txt
    NON_EMPTY_LINES=$(grep -c -v '^[[:space:]]*$' "${ACCESSIONS_FILE}")
    
    info "Number of non-empty lines in accessions_list.txt: ${NON_EMPTY_LINES}"
    info "Number of tasks specified: ${NUM_TASKS}"
    
    if [ "${NUM_TASKS}" -lt "${NON_EMPTY_LINES}" ]; then
        show_error "[ERROR]: --num-tasks value (${NUM_TASKS}) must be equal or greater than the number of non-empty lines in accessions_list.txt (${NON_EMPTY_LINES})"
        exit 1
    fi
    
    info "Validation passed: --num-tasks (${NUM_TASKS}) >= accessions count (${NON_EMPTY_LINES})"
fi

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /tmp:/tmp \
    -v "${WORKING_DIR}:${WORKING_DIR}" \
    -w "${WORKING_DIR}" \
    ${DOCKER_ENV_PARAMS} \
    --name seda-compi-gene-evolution \
    pegi3s/gene-evolution:0.2.0 \
        /compi run -p /pipeline.xml -o -r /pipeline-runner.xml ${COMPI_PARAMS} ${PIPELINE_PARAMS_FILE} -- \
            --workingDirectory ${WORKING_DIR}
