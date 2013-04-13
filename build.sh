COMPILER="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/llvm-gcc-4.2"
SDKDIR="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.1.sdk"

FILES="applist.m
crack.m
dump.m
main.m
out.m
scinfo.m
sha1.c"

for file in $FILES; do
	echo $file
	name=$(echo "$file" | tr '.' ' ' | awk '{print $1}')
	$COMPILER $file -o "$name".o -c -arch armv7 -I Classes/ -isysroot $SDKDIR -std=c99 
	echo "$name".o >> files
done
$COMPILER *.o -o iNalyzer5 -arch armv7 -isysroot $SDKDIR -framework CoreFoundation
