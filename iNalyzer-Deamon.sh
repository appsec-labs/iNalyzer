#!/bin/sh


if [[ -w /tmp/up ]]
then
sleep 4
exit 0
else
touch /tmp/up 
fi

cycript -p SpringBoard /Applications/iNalyzer5.app/utills.cy

if [[ $(ps -ef | grep -c python  ) == "2" ]] 
then
touch /Applications/iNalyzer5.app/proc.kill
message="msgD.txt"
else
touch /Applications/iNalyzer5.app/proc.run
message="msgR.txt"
fi

cycript -p SpringBoard "/Applications/iNalyzer5.app/${message}"

rm /tmp/up