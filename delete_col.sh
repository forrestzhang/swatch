for i in $(ls *.txt)

do

awk '!($1="")' ${i} OFS='\t'> ${i}.fixed.txt

done

