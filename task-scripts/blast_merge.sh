# Set the working directory
BLAST_DIR="${workingDirectory}/output/rename-header-multipart_1"

# Ensure the folder exists
if [ ! -d "$BLAST_DIR" ]; then
     echo "Error: Directory '$BLAST_DIR' not found!"
     exit 1
fi

# add gene name to sequence header
for file in "$BLAST_DIR"/*; do
	filename=$(basename "$file")
	gene=$(echo "$filename" | sed 's/.*_\([A-Za-z0-9]\{1,\}\)_GC[AF]_.*/\1/')
	sed -i "/>/ s/$/_$gene/g" $file
	#replace extra '_'
	sed -i "s/_-_/-/g" $file
done



cd "$BLAST_DIR"
cat * > tmp
grep ">" tmp | cut -f10 -d'_' > tmp1

mkdir -p "${workingDirectory}/results/gene_sequences"
while read name; do
	grep -A1 "_$name$" tmp > "${workingDirectory}/results/gene_sequences/"$name.fasta
	sed -i "/^--$/d" "${workingDirectory}/results/gene_sequences/"$name.fasta
done < tmp1
rm tmp tmp1

cd "$BLAST_DIR"


