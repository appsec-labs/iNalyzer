#!/bin/sh
t=$(date +%H%M%S)


first=0
lastRun=$(grep 'free' /tmp/iNalyzer5.run | tail -1 | cut -d ' ' -f2)
if [[ -z ${lastRun} ]]
then
echo "${$} is first run - removing lock" >>/tmp/iNalyzer5.run
rm -fr "/tmp/iNalyzer5.lock"
first=1
fi

if ! mkdir /tmp/iNalyzer5.lock 2>/dev/null; then
echo "${$} ${t} is already running. exiting" >>/tmp/iNalyzer5.run
exit 1
fi

last1Run="1"${lastRun}
t1="1"${t}


if [[  $(( t1 - last1Run)) -lt 0  ]]
then
testTime=$(( last1Run - t1 ))
else
testTime=$(( t1 - last1Run ))
fi


if [[  ${first} != 1  ]]
then
if [[  ${testTime} -lt 3  ]]
then
echo "${$} was running in $(( t - lastRun)) exiting" >>/tmp/iNalyzer5.run
rm -fr "/tmp/iNalyzer5.lock"
sleep 3
exit 1
fi
fi
#touch /tmp/now
echo "${$} ${t} free">> /tmp/iNalyzer5.run
r=$( ls -irt /Applications/iNalyzer5.app/ | grep proc | tail -1 | cut -d' ' -f1)
proc=$( ls -irt /Applications/iNalyzer5.app/| grep proc | tail -1 | cut -d' ' -f2)

pexec=$( ls /Applications/iNalyzer5.app/ | grep proc | grep -v $proc )
echo "${$} touching ${pexec} ">> /tmp/iNalyzer5.run
touch "/Applications/iNalyzer5.app/${pexec}"


if [[ $( echo ${pexec} | grep -c "proc.run" ) -eq 1 ]]
then
message="msgR.txt"
else
message="msgD.txt"
#rm /tmp/up
fi
/usr/bin/cycript -p SpringBoard "/Applications/iNalyzer5.app/${message}"
echo "${$} fixing Tag ${message} ">> /tmp/iNalyzer5.run
/usr/bin/cycript -p SpringBoard "/Applications/iNalyzer5.app/${message}"
/usr/bin/cycript -p SpringBoard "/Applications/iNalyzer5.app/${message}"
/usr/bin/cycript -p SpringBoard "/Applications/iNalyzer5.app/${message}"
rm -fr "/tmp/iNalyzer5.lock"
echo "${$} finished cleanup ">> /tmp/iNalyzer5.run
