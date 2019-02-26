
# exact file names that depend on other software, might be error prone in case
# files are named wrong

grep -nr "import " | grep -v '%' | grep -v '=' | cut -f 3 -d ':' | cut -f 1 -d ';' | sed 's/\<import\>//g' | tr -d '  ' |sed 's/^/+/' | sed 's:\.:\\\+:g' | grep -vw "+Hca"  | grep -v "'" | sort | uniq | sed 's/\(.*\)+/\1/' | tr -d '  '

# This copies all the required files from the big repository
'''bash
cat files.txt | while read line; do \
mkdir -p bin/$line \
directory='somepathonyourpc'
cp -R 'directory$line'.m' \
bin/$line'.m'; done
'''

 cat files.txt | while read line; do line2=$(echo $line | cut -f1 -d '/'); cat $line2;mkdir -p bin/$line2; cp -R '/home/albyback/git/Projects/hca/lldev/src/MATLAB/'$line'.m' bin/$line'.m'; done

