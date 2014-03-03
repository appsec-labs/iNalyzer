#!/bin/sh
#
# Usage: dumpKeychain.sh EntitlementsFile outputdir
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


outfile="${2}/Keychain.md"
echo "Keychain Data" >${outfile}
echo "=============" >>${outfile}
echo "~~~~~~~~~~~~~{.py}" >>${outfile}

entFile=${1}
ids=$( cat ${1} | tr '\n' '@' | sed 's/.*keychain-access-groups<\/key>//g' | tr '@' '\n' | grep -ia string | awk 'BEGIN {FS="<";} {print $2;}' | cut -d'>' -f2-)
for id in ${ids}
do
data=$( /Applications/iNalyzer5.app/keychain_dumper | tr '\n' '#' | sed 's/##/~/g' | tr '~' '\n' | grep -ia ${id} | tr '#' '\n' )

echo "${data}" >>${outfile}
done
echo "~~~~~~~~~~~~~" >>${outfile}

echo "\n" >>${outfile}
