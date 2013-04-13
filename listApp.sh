#!/bin/sh

ls /var/mobile/Applications/*/*.app/Info.plist | cut -d"/" -f6 | cut -d. -f1 | sort 
