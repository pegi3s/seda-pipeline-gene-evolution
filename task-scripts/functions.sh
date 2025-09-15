#! /bin/bash

message() {
	echo "[seda/pipeline-runner] [${task_id}] $1"
}

get_params() {
	local task_name="$1"
	local cli_params=""
	local params=""
	if [ -f "${workingDirectory}/${paramsDir}/${task_name}.cliParams" ]; then
		cli_params=$(head -1 "${workingDirectory}/${paramsDir}/${task_name}.cliParams" | tr -d '\n' | tr -d '\r')
	fi
	if [ -f "${workingDirectory}/${paramsDir}/${task_name}.sedaParams" ]; then
		params="${cli_params} --parameters-file ${workingDirectory}/${paramsDir}/${task_name}.sedaParams"
	else
		params="${cli_params}"
	fi
	echo "$params"
}

run_seda() {
	local op_name="$1"
	local input_file="$2"
	local output_dir="$3"
	local params="$4"
	mkdir -p "${output_dir}"
	message "Running ${sedaCli} ${op_name} -if ${input_file} -od ${output_dir} ${params}"
	${sedaCli} ${op_name} -if ${input_file} -od ${output_dir} ${params}
	if [ $? -gt 0 ]; then
		message "Error runing batch, saving it into ${workingDirectory}/${output}/_failed/${task_id}"
		mkdir -p "${workingDirectory}/${output}/_failed/${task_id}"
		echo "${input_file}" >> "${workingDirectory}/${output}/_failed/${task_id}/failed_accessions.txt"
	fi
}