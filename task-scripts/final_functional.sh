# Save final results for reference phylogeny

mkdir -p ${workingDirectory}/results/functional
touch ${workingDirectory}/${output}/filtering_1/merged.fasta >/dev/null 2>&1
cp ${workingDirectory}/${output}/filtering_1/merged.fasta ${workingDirectory}/results/functional >/dev/null 2>&1
mv ${workingDirectory}/results/functional/merged.fasta ${workingDirectory}/results/functional/functional.fasta >/dev/null 2>&1
