#!/bin/bash
#SBATCH -p workq

#Author: Lucie Zinger
#Last update: 11.12.2019

#What does it do?
        #coun tnumber of reasd and otus in each sample from several fasta files with dereplicated reads
#How to run it?
        #sbatch /home/lzinger/work/SCRIPTS/samplestat.sh myfile.fasta derepl myfile

#Variable definition
file=$1 #input file
op=$2   #filtering operation for column names
out=$3 #outputfile prefix

opreads=`echo $op.reads` #column names for reads
opotus=`echo $op.otus` #colum names for otus

reads=`echo $out.reads`
otus=`echo $out.otus`

echo sample "${opreads}" > ${reads}  # define colnames
grep '^>' $file | awk 'BEGIN {FS="{"} {print $2}' | \
        awk 'BEGIN {FS="}"}{print $1}' | tr , '\n' | sed -e 's/://g' -e s/\'//g -e 's/^ //g' | \
        awk -v var="${opreads}" '{a[$1]+=$2}END{for (i in a){print i,a[i]}}' | sort -k 1 >> ${reads}
echo sample "${opotus}" > ${otus}
grep '^>' "${file}" | awk 'BEGIN {FS="{"} {print $2}' | \
        awk 'BEGIN {FS="}"}{print $1}' | tr , '\n' | sed -e 's/://g' -e s/\'//g -e 's/^ //g' | \
        sort | awk '{print $1}' | uniq -c | awk -v var="${opotus}" '{print $2, $1}' >> ${otus}

if [ -f "${out}".sampstat ]; then
        awk 'NR==FNR{a[$1]=$2; next}{print $0, a[$1]}' ${reads} ${otus} > tmp
        awk 'NR==FNR{a[$1]=$2 FS $3; next}{print $0, a[$1]}' tmp "${out}".sampstat > $$
        mv $$ "${out}".sampstat
        rm tmp
else
        awk 'NR==FNR{a[$1]=$2; next}{print $0, a[$1]}' ${reads} ${otus} > "${out}".sampstat
fi

rm ${reads} ${otus}
