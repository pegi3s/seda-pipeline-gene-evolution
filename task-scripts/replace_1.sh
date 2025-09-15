# Replace spaces by underscores

mkdir -p ${workingDirectory}/output/replace_1 ${workingDirectory}/input/replace_1 >/dev/null 2>&1
cp ${workingDirectory}/output/rename-ncbi_1/* ${workingDirectory}/output/replace_1 >/dev/null 2>&1
sed -i 's/ /_/g' ${workingDirectory}/output/replace_1/* >/dev/null 2>&1
sed -i 's/\./_/g' ${workingDirectory}/output/replace_1/* >/dev/null 2>&1

# Copying files to the right places

cp ${workingDirectory}/output/replace_1/* ${workingDirectory}/input/replace_1 >/dev/null 2>&1
chmod -R 777 ${workingDirectory}/input >/dev/null 2>&1
