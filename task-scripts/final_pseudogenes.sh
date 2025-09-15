# Save final results for reference phylogeny

mkdir -p ${workingDirectory}/results/pseudogenes
touch ${workingDirectory}/output/filtering_3/merged.fasta >/dev/null 2>&1
cp ${workingDirectory}/output/filtering_3/merged.fasta ${workingDirectory}/results/pseudogenes >/dev/null 2>&1
mv ${workingDirectory}/results/pseudogenes/merged.fasta ${workingDirectory}/results/pseudogenes/pseudogenes.fasta 


