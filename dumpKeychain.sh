
#!/bin/sh
#
# Usage: dumpKeychain.sh path/to/Info.plist outputdir
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

id=$( plutil -v "${1}" | grep -i CFBundleIdentifier | cut -d'"' -f2 )
echo "Keychain data" >${outfile}
echo "~~~~~~~~~~~~~{.xml}" >>${outfile}

data=$( /Applications/iNalyzer5.app/keychain_dumper | tr '\n' '#' | sed 's/##/~/g' | tr '~' '\n' | grep -i ${id} | tr '#' '\n' )

echo "${data}" >>${outfile}
echo "~~~~~~~~~~~~~" >>${outfile}

echo "\n" >>${outfile}
