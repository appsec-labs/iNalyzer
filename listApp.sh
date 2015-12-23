#!/bin/sh
if [ -d /var/mobile/Containers/Bundle/Application/ ]; then
	ls /var/mobile/Containers/Bundle/Application/*/*.app/Info.plist | sed 's/.app$//g' | sort
else
	ls /var/mobile/Applications/*/*.app/Info.plist | cut -d"/" -f6 | sed 's/\.app$//g' | sort 
fi
