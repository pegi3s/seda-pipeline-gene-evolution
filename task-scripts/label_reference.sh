# Define file paths
REFERENCE_DIR="${workingDirectory}/results/gene_sequences"
FUNCTIONAL="${workingDirectory}/results/functional/functional.fasta"
FUNCTIONAL_ERRORS="${workingDirectory}/results/functional_and_errors/functional_and_errors.fasta"
PSEUDOGENES="${workingDirectory}/results/pseudogenes/pseudogenes.fasta"

# Function to update a single reference file
update_reference() {
     local ref_file=$1
     local fasta_file=$2
     local suffix=$3
     local exclude_suffix=$4  # Optional argument

     TEMP_FILE="${ref_file}.tmp"
     cp "$ref_file" "$TEMP_FILE"

     while read -r line; do
         if [ "$(echo "$line" | cut -c1)" = ">" ]; then  # Process only header lines
             # Extract the first six fields separated by "_"
             key=$(echo "$line" | cut -d'_' -f1-6)

             # Check if the key exists in the reference file
             if grep -q "^$key" "$TEMP_FILE"; then
                 if [ -n "$exclude_suffix" ]; then
                     sed -i "/^$key/!b; /${exclude_suffix}\$/b; s/$/${suffix}/" "$TEMP_FILE"
                 else
                     sed -i "s/^$key.*/& ${suffix}/" "$TEMP_FILE"
                 fi
             fi
         fi
     done < "$fasta_file"

     # Remove spaces added during suffixing
     sed -i 's/ //g' "$TEMP_FILE"

     # Overwrite original file with updated version
     mv "$TEMP_FILE" "$ref_file"
}

# Apply updates to each reference file
for ref_file in "${REFERENCE_DIR}"/*.fasta; do
     update_reference "$ref_file" "$FUNCTIONAL" "_functional" "_functional"
     update_reference "$ref_file" "$FUNCTIONAL_ERRORS" "_functional_and_errors" "_functional"
     update_reference "$ref_file" "$PSEUDOGENES" "_pseudogene" "_pseudogene"
done

