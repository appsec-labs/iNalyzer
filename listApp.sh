#!/bin/sh

ls /var/mobile/Applications/*/*.app/Info.plist | cut -d"/" -f6 | sed 's/\.app$//g' | sort 
