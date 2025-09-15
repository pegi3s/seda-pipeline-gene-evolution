# Replace spaces by underscores

mkdir -p ${workingDirectory}/output/replace_2 ${workingDirectory}/input/replace_2 >/dev/null 2>&1
cp ${workingDirectory}/output/remove-redundant_2/* ${workingDirectory}/output/replace_2 >/dev/null 2>&1
sed -i 's/_/ /g' ${workingDirectory}/output/replace_2/* >/dev/null 2>&1
sed -i 's/GCA /_GCA_/g' ${workingDirectory}/output/replace_2/* >/dev/null 2>&1
sed -i 's/GCF /_GCF_/g' ${workingDirectory}/output/replace_2/* >/dev/null 2>&1
sed -i -E 's/\.([0-9]+) /_\1_/g' ${workingDirectory}/output/replace_2/* >/dev/null 2>&1
sed -i -E 's/ \(from ([0-9]+) ([0-9]+)\) /_\(\1-\2\)_/g' ${workingDirectory}/output/replace_2/* >/dev/null 2>&1

# Copying files to the right places

cp ${workingDirectory}/output/replace_2/* ${workingDirectory}/input/replace_2 >/dev/null 2>&1
chmod -R 777 ${workingDirectory}/input >/dev/null 2>&1
