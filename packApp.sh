#!/bin/sh

export name=${1}

cmd1="/Applications/iNalyzer5.app/r30c5.sh ${name}"
cmd2="/Applications/iNalyzer5.app/iNalyzer5 ${name}"

ex1=$( eval ${cmd1} 2>/dev/null )
test1=$( echo ${ex1} |  tr ',' '\n' | grep -c 'iNalyzer done' )
if [[ ${test1} -eq 1 ]]
then
echo ${ex1} | tr ',' '\n' | grep 'file saved at:' | cut -d":" -f2- | sed 's/ /\\ /g'
exit 0
fi


ex2=$( eval ${cmd2} 2>/dev/null )
test2=$( echo ${ex2} |  tr ',' '\n' | grep -c 'iNalyzer done' )
if [[ ${test2} -eq 1 ]]
then
echo ${ex2} | tr ',' '\n' | grep 'file saved at:' | cut -d":" -f2- | sed 's/ /\\ /g'
exit 0
fi

hdir="/"$(ps -ef | grep -v grep | grep -v packApp | grep -i ${name} | head -1 | cut -d"/" -f2-)
if [[ ${hdir} == "/" ]]
then
exit 0
fi

appDir=$( echo ${hdir} | tr '/' '#' | sed 's/\.app#.*/.app#/g' | tr '#' '/' )
cmd3="/Applications/iNalyzer5.app/iNalyzer5 --direct ${appDir}"

ex3=$( eval ${cmd3} 2>/dev/null )
test3=$( echo ${ex3} |  tr ',' '\n' | grep -c 'iNalyzer done' )
if [[ ${test3} -eq 1 ]]
then
echo ${ex3} | tr ',' '\n' | grep 'file saved at:' | cut -d":" -f2- | sed 's/ /\\ /g'
exit 0
fi