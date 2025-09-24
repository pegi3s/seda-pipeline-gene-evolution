# Set the working directory
BLAST_DIR_INPUT="${workingDirectory}/output/rename-header-multipart_1"
BLAST_DIR="${workingDirectory}/output/blast_merge"

# Ensure the folder exists
if [ ! -d "$BLAST_DIR_INPUT" ]; then
     echo "Error: Directory '$BLAST_DIR_INPUT' not found!"
     exit 1
fi

mkdir -p "$BLAST_DIR"
cp "$BLAST_DIR_INPUT"/* "$BLAST_DIR"/

touch /tmp/gene_names.txt

# add gene name to sequence header
for file in "$BLAST_DIR"/*; do
	filename=$(basename "$file")
	gene=$(echo "$filename" | sed 's/.*_\([A-Za-z0-9]\{1,\}\)_GC[AF]_.*/\1/')
	sed -i "/>/ s/$/_$gene/g" $file
	#replace extra '_'
	sed -i "s/_-_/-/g" $file
	sed -i 's/-REPLACE-BACK-/_/g' $file
	echo "$gene" >> /tmp/gene_names.txt
done

cat /tmp/gene_names.txt | sort | uniq > /tmp/gene_names_uniq.txt
mv /tmp/gene_names_uniq.txt /tmp/gene_names.txt

cd "$BLAST_DIR"
cat * > all_blast.fasta

mkdir -p "${workingDirectory}/results/gene_sequences"
rm -rf "${workingDirectory}/results/gene_sequences/*"

while read name; do
	grep -A1 "_$name$" all_blast.fasta > "${workingDirectory}/results/gene_sequences/"$name.fasta
	sed -i "/^--$/d" "${workingDirectory}/results/gene_sequences/"$name.fasta
done < /tmp/gene_names.txt
rm all_blast.fasta /tmp/gene_names.txt

cd "$BLAST_DIR"
