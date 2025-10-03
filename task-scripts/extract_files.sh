# Extract files

mkdir -p ${workingDirectory}/output
unzip -j "${workingDirectory}/${input}/extract_files/*.zip" "ncbi_dataset/data/GCA_*/GCA_*" -d "${workingDirectory}/${input}/getorf" >/dev/null 2>&1
unzip -j "${workingDirectory}/${input}/extract_files/*.zip" "ncbi_dataset/data/GCF_*/GCF_*" -d "${workingDirectory}/${input}/getorf" >/dev/null 2>&1

# Extract filenames
for file in "${workingDirectory}/${input}/getorf"/*; do
     filename=$(basename "$file")

     # Extract the pattern (GCF/GCA followed by numbers)
     match=$(echo "$filename" | sed -n 's/.*\(GCF_[0-9]\+\(\.[0-9]\+\)\?\|GCA_[0-9]\+\(\.[0-9]\+\)\?\).*/\1/p')
     sed -i "/>/ s/>/>${match}_/g" "${workingDirectory}/${input}/getorf"/$filename
done

# Copying files to the right places

mkdir ${workingDirectory}/${input}/prosplign-procompart ${workingDirectory}/${output}/extract_files >/dev/null 2>&1
cp ${workingDirectory}/${input}/getorf/* ${workingDirectory}/${input}/prosplign-procompart >/dev/null 2>&1
cp ${workingDirectory}/${input}/getorf/* ${workingDirectory}/${output}/extract_files >/dev/null 2>&1
chmod -R 777 ${workingDirectory}/${input}
chmod -R 777 ${workingDirectory}/${output}


