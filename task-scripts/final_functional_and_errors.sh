# Save final results for reference phylogeny

mkdir -p ${workingDirectory}/results/functional_and_errors
touch ${workingDirectory}/${output}/filtering_2/merged.fasta >/dev/null 2>&1
cp ${workingDirectory}/${output}/filtering_2/merged.fasta ${workingDirectory}/results/functional_and_errors >/dev/null 2>&1
mv ${workingDirectory}/results/functional_and_errors/merged.fasta ${workingDirectory}/results/functional_and_errors/functional_and_errors.fasta >/dev/null 2>&1
