for i in $(ls *.fixed.txt) 
do
awk '$1=$1' FS=" " OFS='\t' ${i} > ${i}.col.txt
done
