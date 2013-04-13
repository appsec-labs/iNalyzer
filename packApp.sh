#!/bin/sh

export name=${1}

cmd="/Applications/iNalyzer5.app/iNalyzer5 ${name}"

z=$( eval ${cmd} 2>/dev/null | grep ".ipa" 2>/dev/null )
echo ${z}
