#!/bin/sh
#
# Usage: dumpPlistfiels.sh lookupdir outputdir
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

dblist=$(find ${1} -type f -exec grep -ali plist {} \;)
outfile="${2}/Plist_List.md"

echo "Plist Files" >${outfile}
echo "=======" >>${outfile}
i=0
for source in ${dblist}
do
#tlist=$(echo '.tables' | sqlite3 ${source} )
dbname="$(echo ${source} | tr '/' '\n' | tail -1)"
#echo "=======" >> ${outfile}
i=$(( i+1 ))
emptyList=""
#for t in ${tlist}
#do
#echo "=======" >> ${outfile}
data=$(plutil -v "${source}" )
if [[ $( echo ${data} | grep -c '"$archiver" = NSKeyedArchiver;') -ne 1 ]]
then
if [[ ! -z ${data} ]];
then
echo "\section Plist${i} ${dbname} " >> ${outfile}
echo "~~~~~~~~~~~~~{.xml}" >>${outfile}
echo "${data}" >>${outfile}
echo "~~~~~~~~~~~~~" >>${outfile}
#Row="|"$( echo "${header}" | head -1 | sed 's/[a-zA-Z0-9\._]/-/g')"|"
#echo "${Row}" >>${outfile}
#Row="|"$(printf ".head off\n.mode html\nselect * from ${t};" | sqlite3 ${source} )"|"
#echo "${Row}" >>${outfile}
else
emptyList="${emptyList} ${t}"
fi
fi
done

echo "\n" >>${outfile}
