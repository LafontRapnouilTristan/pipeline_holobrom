#!/bin/bash
#SBATCH -p workq

#Author: Lafont Rapnouil Tristan
#Last update: 01.17.2023

#Variable definition
file=$1 #input file
op=$2   #filtering operation for column names
out=$3 #outputfile prefix

opreads=`echo $op.reads` #column names for reads
opotus=`echo $op.otus` #colum names for otus

reads2=`echo $out.reads2`
otus2=`echo $out.otus2`


echo sample "${opreads}" > ${reads2}  # define colnames
grep '^>' $file | grep -P -o '(?<=merged_sample={).*?(?=})' | tr , '\n' | sed -e 's/://g' -e s/\'//g -e 's/^ //g' | awk -v var="${opreads}" '{a[$1]+=$2}END{for (i in a){print i,a[i]}}' | sort -k 1 >> ${reads2}
                
echo sample "${opotus}" > ${otus2}
                
grep '^>' ${file} | grep -P -o '(?<=merged_sample={).*?(?=})' | tr , '\n' | sed -e 's/://g' -e s/\'//g -e 's/^ //g' | sort | awk '{print $1}' | uniq -c | awk -v var="${opotus}" '{print $2, $1}' >> ${otus2}
                
if [ -f "${out}".sampstat2 ]; then
        awk 'NR==FNR{a[$1]=$2; next}{print $0, a[$1]}' ${reads2} ${otus2} > tmp2
        awk 'NR==FNR{a[$1]=$2 FS $3; next}{print $0, a[$1]}' tmp2 "${out}".sampstat2 > $$
        mv $$ "${out}".sampstat2
        rm tmp2
else
        awk 'NR==FNR{a[$1]=$2; next}{print $0, a[$1]}' ${reads2} ${otus2} > "${out}".sampstat2
fi

rm ${reads2} ${otus2}
