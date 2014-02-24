#!/bin/sh
#
# Usage: dumpSQLfiels.sh lookupdir outputdir
#
#

if [[ -z ${1} ]]
then
return;
fi;
if [[ -z ${2} ]]
then
return;
fi;
dblist=$(find ${1} -type f -exec grep -ali sqlite {} \;)
outfile="${2}/TABLE_List.md"
echo "Database Files" >${outfile}
echo "=======" >>${outfile}
i=0
for source in ${dblist} 
do 
tlist=$(echo '.tables' | sqlite3 ${source} )
dbname=$(echo ${source} | tr '/' '\n' | tail -1)
echo "\section Table${i} ${dbname}" >> ${outfile}
#echo "=======" >> ${outfile}
i=$(( i+1 ))
emptyList=""
for t in ${tlist} 
do 
#echo "=======" >> ${outfile}
header=$(printf ".head on\n.mode html\nselect * from ${t};" | sqlite3 ${source} )
if [[ ! -z ${header} ]];
then
echo "\subsection ${t}${i} ${t}"  >> ${outfile}
#Row="|$(echo "${header}" | head -1)|"
echo "" >> ${outfile}
echo '<Table>' >>${outfile}
echo "${header}" >>${outfile}
echo '</Table>' >>${outfile}
#Row="|"$( echo "${header}" | head -1 | sed 's/[a-zA-Z0-9\._]/-/g')"|"
#echo "${Row}" >>${outfile}
#Row="|"$(printf ".head off\n.mode html\nselect * from ${t};" | sqlite3 ${source} )"|"
#echo "${Row}" >>${outfile}
else
emptyList="${emptyList} ${t}"
fi
done
if [[ ! -z ${emptyList} ]];
then
echo "\subsection Empty${i} Empty Tables"  >> ${outfile}
echo "${emptyList}" >> ${outfile}
fi
done
echo "\n" >>${outfile}
