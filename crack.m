/*
 * iNalyzer5
 * https://github.com/appsec-labs/iNalyzer
 *
 * Security assesment framework for iOS application
 * by Chilik Tamir @_coreDump
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#import "crack.h"
#import <Foundation/Foundation.h>
#import "NSTask.h"
#import "ZipArchive.h"
#include <sys/stat.h>

#define Z_NO_COMPRESSION         0
#define Z_BEST_SPEED             1
#define Z_BEST_COMPRESSION       9
#define Z_DEFAULT_COMPRESSION  (-1)

int overdrive_enabled = 0;
int only_armv7 = 0;
int only_armv6 = 0;
int bash = 0;
int compression_level = -1;


long fsize(const char *file) {
    struct stat st;
    if (stat(file, &st) == 0)
        return st.st_size;
    
    return -1; 
}
ZipArchive * createZip(NSString *file) {
    ZipArchive *archiver = [[ZipArchive alloc] init];
    [archiver CreateZipFile2:file];
    return archiver;
}
void zip(ZipArchive *archiver, NSString *folder) {
    BOOL isDir=NO;	
    NSArray *subpaths;	
    int total = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];	
    if ([fileManager fileExistsAtPath:folder isDirectory:&isDir] && isDir){
        subpaths = [fileManager subpathsAtPath:folder];
        total = [subpaths count];
    }
    int togo = total;
    
    
    for(NSString *path in subpaths){
		togo--;
        PERCENT((int)ceil((((double)total - togo) / (double)total) * 100));
        // Only add it if it's not a directory. ZipArchive will take care of those.
        NSString *longPath = [folder stringByAppendingPathComponent:path];
        if([fileManager fileExistsAtPath:longPath isDirectory:&isDir] && !isDir){
            [archiver addFileToZip:longPath newname:path compression:compression_level];	
            //printf("\nZip:Compressing file %s",[path UTF8String]);
        }
    }
    return;
}

void zip_original(ZipArchive *archiver, NSString *folder, NSString *binary, NSString* zip) {
    return;
    long size;
    BOOL isDir=NO;	
    NSArray *subpaths;	
    int total = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];	
    if ([fileManager fileExistsAtPath:folder isDirectory:&isDir] && isDir){
        subpaths = [fileManager subpathsAtPath:folder];
        total = [subpaths count];
    }
    int togo = total;
    
    
    for(NSString *path in subpaths) {
		togo--;
        if (([path rangeOfString:@".app"].location != NSNotFound) && ([path rangeOfString:@"SC_Info"].location == NSNotFound) && ([path rangeOfString:@"Library"].location == NSNotFound) && ([path rangeOfString:@"tmp"].location == NSNotFound) && ([path rangeOfString:[NSString stringWithFormat:@".app/%@", binary]].location == NSNotFound)) {
            PERCENT((int)ceil((((double)total - togo) / (double)total) * 100));
            // Only add it if it's not a directory. ZipArchive will take care of those.
            NSString *longPath = [folder stringByAppendingPathComponent:path];
            if([fileManager fileExistsAtPath:longPath isDirectory:&isDir] && !isDir){
                size += fsize([longPath UTF8String]);
                if (size > 31457280){
                    VERBOSE("Zip went over 30MB, saving..");
                    //printf("\nZip_original:Zip went over 30MB, in %s Saving..",[longPath UTF8String]);
                    [archiver CloseZipFile2];
                    [archiver release];
                    archiver = [[ZipArchive alloc] init];
                    [archiver openZipFile2:zip];
                }
                [archiver addFileToZip:longPath newname:[NSString stringWithFormat:@"Payload/%@", path] compression:compression_level];
                    //printf("\nZip_original: Compressing file %s",[path UTF8String]);
            }
        }
    }
    return;
}

NSString * crack_application(NSString *application_basedir, NSString *basename, NSString *version) {
    VERBOSE("Creating working directory...");
	NSString *workingDir = [NSString stringWithFormat:@"%@%@/", @"/tmp/iNalyzer5_", genRandStringLength(8)];
	if (![[NSFileManager defaultManager] createDirectoryAtPath:[workingDir stringByAppendingFormat:@"Payload/%@", basename] withIntermediateDirectories:YES attributes:[NSDictionary
			dictionaryWithObjects:[NSArray arrayWithObjects:@"mobile", @"mobile", nil]
			forKeys:[NSArray arrayWithObjects:@"NSFileOwnerAccountName", @"NSFileGroupOwnerAccountName", nil]
			] error:NULL]) {
		printf("error: Could not create working directory\n");
		return nil;
	}
	
    VERBOSE("Performing initial analysis...");
	struct stat statbuf_info;
	stat([[application_basedir stringByAppendingString:@"Info.plist"] UTF8String], &statbuf_info);
	time_t ist_atime = statbuf_info.st_atime;
	time_t ist_mtime = statbuf_info.st_mtime;
	struct utimbuf oldtimes_info;
	oldtimes_info.actime = ist_atime;
	oldtimes_info.modtime = ist_mtime;
	
	NSMutableDictionary *infoplist = [NSMutableDictionary dictionaryWithContentsOfFile:[application_basedir stringByAppendingString:@"Info.plist"]];
	if (infoplist == nil) {
		printf("error: Could not open Info.plist\n");
		goto fatalc;
	}
	
	if ([(NSString *)[iNalyzer5Configuration getValue:@"CheckMinOS"] isEqualToString:@"YES"]) {
		NSString *MinOS;
		if (nil != (MinOS = [infoplist objectForKey:@"MinimumOSVersion"])) {
			if (strncmp([MinOS UTF8String], "2", 1) == 0) {
				printf("notice: added SignerIdentity field (MinOS 2.X)\n");
				[infoplist setObject:@"Apple iPhone OS Application Signing" forKey:@"SignerIdentity"];
				[infoplist writeToFile:[application_basedir stringByAppendingString:@"Info.plist"] atomically:NO];
			}
		}
	}
	
	utime([[application_basedir stringByAppendingString:@"Info.plist"] UTF8String], &oldtimes_info);
	
	NSString *binary_name = [infoplist objectForKey:@"CFBundleExecutable"];
	
	NSString *fbinary_path = init_crack_binary(application_basedir, basename, workingDir, infoplist);
	if (fbinary_path == nil) {
		printf("error: Could not crack binary\n");
		goto fatalc;
	}
	//BEGIN iNalyzer
    //echo "${Meter75}iNalyzer:Dumping Strings"
    //printf("iNalyzer:Dumping Strings\n");
   
    // mkdir -p "$WorkDir/Payload/ReversingFiles"
    if (![[NSFileManager defaultManager] createDirectoryAtPath:[workingDir stringByAppendingFormat:@"Payload/ReversingFiles/"] withIntermediateDirectories:TRUE attributes:nil error:NULL])
    {printf ("error: can't create target directories\n");
        return nil ;}
    
    // mkdir -p "$WorkDir/Payload/ClientFiles"
    if(![[NSFileManager defaultManager] createDirectoryAtPath:[workingDir stringByAppendingFormat:@"Payload/ClientFiles/"] withIntermediateDirectories:TRUE attributes:nil error:NULL])   
    {printf ("error: can't create target directories\n");
        return nil ;}
    
    NSString *cpy_from = @"";
    NSString *cpy_to = @"";
    NSString *cmd = @"";
    NSString *interp = @"";
    NSString *fooStr = @"";
    NSString *string =@"";
    BOOL *cDmpFailed=false;
    printf("\niNalyzer [1/9] Dumping Headers:");
    cmd = [NSString stringWithFormat:@"/Applications/iNalyzer5.app/classdump-dyld -b -o '%@Payload/ReversingFiles/' '%@'",workingDir, fbinary_path ];
    interp =@"/bin/sh";
    string = runCmdString(interp,cmd);
    
    if ([string isEqualToString:@"-1"]){
        //printf ("Failed error dumping headers\n");
        //return nil ;
        cDmpFailed=true;
    }
    
    if(cDmpFailed){
        cmd = [NSString stringWithFormat:@"class-dump-z -k -k -H -o '%@Payload/ReversingFiles/' '%@'",workingDir, fbinary_path ];
        interp =@"/bin/sh";
        string = runCmdString(interp,cmd);
        
        if ([string isEqualToString:@"-1"]){
            printf ("Failed error dumping headers\n");
            return nil ;
            //cDmpFailed=true;
        }
    }
    printf ("Done");

    printf("\niNalyzer [2/9] Creating SnapShot into ClientFiles:");
  
    
    interp = @"/bin/sh";
    cpy_from = application_basedir; 
    cpy_to = [workingDir stringByAppendingFormat:@"Payload/ClientFiles/"] ;
    NSString *pathToFile = @"/var/mobile/Containers/Bundle/Application";
    BOOL isDir = NO;
    BOOL isFile = [[NSFileManager defaultManager] fileExistsAtPath:pathToFile isDirectory:&isDir];
    if(isDir != YES){
    	pathToFile = @"/var/mobile/Applications";
    }
    if ([application_basedir hasPrefix:pathToFile]){
    
        cmd = [NSString stringWithFormat:@"cp -r '%@../' '%@'",cpy_from,cpy_to];

        fooStr =runCmdString(interp,cmd);
        
        if ([fooStr isEqualToString:@"-1"]){
            printf ("\nFailed - error creating SnapShot");
            return nil ;
        }
        printf ("Done");
    }
    
     else
    {
        if ([application_basedir hasPrefix:@"/tmp/"]){
            if(isDir != NO)
            	cmd = [NSString stringWithFormat:@"echo \"$( find /var/mobile/Containers/Bundle/Application/ -type d -name '*.app' | grep -i %@  | tr '\n' '#')\"",basename];
            else
            	cmd = [NSString stringWithFormat:@"echo \"$( find /var/mobile/Applications/ -type d -name '*.app' | grep -i %@  | tr '\n' '#')\"",basename];
            NSString *asd =runCmdString(interp,cmd);
            
            //printf ("\nidentifiyed home dir at %s#", [asd  UTF8String]);
            //debug printf ("\nidentifiyed home dir at %s",[[ asd substringToIndex:([asd length]-2) ] UTF8String ]);
            
            fooStr=[NSString stringWithUTF8String:[[ asd substringToIndex:([asd length]-2) ] UTF8String ] ];
            if ([[NSFileManager defaultManager] fileExistsAtPath:fooStr] )
            {
                cpy_from = fooStr;
                cmd = [NSString stringWithFormat:@"cp -r '%@/../' '%@'",cpy_from,cpy_to];
            }
            else{
                cpy_from = application_basedir;
                cmd = [NSString stringWithFormat:@"cp -r '%@' '%@'",cpy_from,cpy_to];
            }
            fooStr =runCmdString(interp,cmd);
            
            if ([fooStr isEqualToString:@"-1"]){
                printf ("\nFailed - error creating SnapShot");
                return nil ;
            }
            printf ("Done");
    
        }else {
            bash=22;
            //flag for system applications
        }
    }
       //debug printf ("\ncopying %s to %s", [cpy_from  UTF8String],[cpy_to  UTF8String]);
    
    //      mkdir -p "$WorkDir/Payload/Doxigen"
    if (![[NSFileManager defaultManager] createDirectoryAtPath:[workingDir stringByAppendingFormat:@"Payload/Doxygen/"] withIntermediateDirectories:TRUE attributes:nil error:NULL])
    {printf ("error: can't create target directories\n");
        return nil ;}
    
    //d0=$( cp "$HomeDir/footer.html" "$WorkDir/Payload/Doxigen/footer.html" 2>&1>/dev/null )*/
    NSString * homeDir = [[ NSBundle mainBundle] bundlePath ]  ;
    
    if(![[NSFileManager defaultManager] copyItemAtPath:[ homeDir stringByAppendingFormat:@"/footer.html"] toPath:[workingDir stringByAppendingFormat:@"Payload/Doxygen/footer.html"] error:NULL])
    {printf ("error: can't copy footer.html to target directory\n");
        return nil ;}
    
    /*if(![[NSFileManager defaultManager] copyItemAtPath:[ homeDir stringByAppendingFormat:@"/1.png"] toPath:[workingDir stringByAppendingFormat:@"Payload/Doxygen/1.png"] error:NULL])
    {printf ("error: can't copy footer.html to target directory\n");
        return nil ;}*/
    
    if(![[NSFileManager defaultManager] copyItemAtPath:[ homeDir stringByAppendingFormat:@"/logo.gif"] toPath:[workingDir stringByAppendingFormat:@"Payload/Doxygen/logo.gif"] error:NULL])
    {printf ("error: can't copy logo.png to target directory\n");
        return nil ;}
    
    if(![[NSFileManager defaultManager] copyItemAtPath:[ homeDir stringByAppendingFormat:@"/dox.template"] toPath:[workingDir stringByAppendingFormat:@"Payload/Doxygen/dox.template"] error:NULL])
    {printf ("error: can't copy dox.template to target directory\n");
        return nil ;}
    
    if(![[NSFileManager defaultManager] copyItemAtPath:[ homeDir stringByAppendingFormat:@"/doxMe.sh"] toPath:[workingDir stringByAppendingFormat:@"Payload/Doxygen/doxMe.sh"] error:NULL])
    {printf ("error: can't copy doxMe.sh to target directory\n");
        return nil ;}
   
    if(![[NSFileManager defaultManager] copyItemAtPath:[ homeDir stringByAppendingFormat:@"/doxMe.bat"] toPath:[workingDir stringByAppendingFormat:@"Payload/Doxygen/doxMe.bat"] error:NULL])
    {printf ("error: can't copy doxMe.sh to target directory\n");
        return nil ;}
    //d1=$( sed 's/§PNAME§/'$safename'/g' "$WorkDir/Payload/Doxigen/dox.template" > "$WorkDir/Payload/Doxigen/dox.template_")
    
   
   /* NSMutableString * templateHTML = [[NSMutableString alloc]
    initWithContentsOfFile:[workingDir stringByAppendingFormat:@"Payload/Doxygen/dox.template"] ]; 
    fixed for iOS 7
    */
 
    NSString * templateHTML = [NSString stringWithContentsOfFile:[workingDir stringByAppendingFormat:@"Payload/Doxygen/dox.template"] encoding:NSUTF8StringEncoding error:nil  ];
    
    NSString * foo = @"@PNAME@"; 
    NSString * formattedFoo = basename;
    
   // iOS 7 fix [templateHTML replaceOccurrencesOfString:foo withString:formattedFoo options:NSCaseInsensitiveSearch range:NSMakeRange(0, [templateHTML length])]; 
    
    templateHTML=[templateHTML stringByReplacingOccurrencesOfString:foo withString:formattedFoo options:NSCaseInsensitiveSearch range:NSMakeRange(0, [templateHTML length])]; 
    
    foo = @"@OUTDIR@"; 
    formattedFoo = @".";
    
    templateHTML=[templateHTML stringByReplacingOccurrencesOfString:foo withString:formattedFoo options:NSCaseInsensitiveSearch range:NSMakeRange(0, [templateHTML length])]; 
    
    foo = @"@INDIR@"; 
    formattedFoo = @"../ReversingFiles";
    
    templateHTML=[templateHTML stringByReplacingOccurrencesOfString:foo withString:formattedFoo options:NSCaseInsensitiveSearch range:NSMakeRange(0, [templateHTML length])]; 
    
    
    [templateHTML writeToFile:[workingDir stringByAppendingFormat:@"Payload/Doxygen/dox.template"] atomically:YES encoding:NSUTF8StringEncoding error:NULL ] ;
    
    
    
    
    ////d3=$( sed 's/§EXENAME§/'$AppExec'/g' "$WorkDir/Payload/Doxigen/footer.html" > "$WorkDir/Payload/Doxigen/footer.html_" )
    
    
    ////d4=$( mv "$WorkDir/Payload/Doxigen/footer.html_" "$WorkDir/Payload/Doxigen/footer.html" )
    templateHTML = [NSString stringWithContentsOfFile:[workingDir stringByAppendingFormat:@"Payload/Doxygen/footer.html"]  encoding:NSUTF8StringEncoding error:nil   ];
    foo = @"@EXENAME@"; 
    formattedFoo = binary_name;
    
    templateHTML =[templateHTML stringByReplacingOccurrencesOfString:foo withString:formattedFoo options:NSCaseInsensitiveSearch range:NSMakeRange(0, [templateHTML length])];
     
        
    //ios7/
    interp = @"/usr/bin/python";
    //ios7/
    cmd = @"import socket; s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.connect((\"8.8.8.8\", 80)); print(s.getsockname()[0]); s.close()" ;
    
    //interp = @"/bin/bash";
    //cmd = @"ifconfig en0 | head -2 | tail -1 | awk '{print $2;}'" ;
    string = runCmdString(interp, cmd);
    
    foo = @"@IPHONEIP@"; 
    formattedFoo =  [ string stringByReplacingOccurrencesOfString:@"\n" withString:@"" ];
    
    templateHTML=[templateHTML stringByReplacingOccurrencesOfString:foo withString:formattedFoo options:NSCaseInsensitiveSearch range:NSMakeRange(0, [templateHTML length])]; 
    
    [templateHTML writeToFile:[workingDir stringByAppendingFormat:@"Payload/Doxygen/footer.html"] atomically:YES encoding:NSUTF8StringEncoding error:NULL ] ;
    
    [templateHTML release];
    
    //printf ("iNalyzer:IP is \n%s", [ string UTF8String]);
    //printf ("iNalyzer:Population Done\n");
    
    
    foo = [NSString stringWithFormat:@"/*! \\page EMS Embeded Strings \n\\section all strings\n\\code\n" ];
    [ foo writeToFile:[workingDir stringByAppendingFormat:@"Payload/ReversingFiles/__String_dump__.h"] atomically:YES encoding:NSUTF8StringEncoding error:NULL ];
    
    cmd = [NSString stringWithFormat:@"strings - '%@' 2>/dev/null  | sort -iu 2>/dev/null | awk '{print FNR\" \"$0 }'  2>/dev/null 1>> '%@Payload/ReversingFiles/__String_dump__.h' && echo '\\endcode*/' 1>>'%@Payload/ReversingFiles/__String_dump__.h'",fbinary_path,workingDir,workingDir ];     
    interp =@"/bin/sh";
    string = runCmdString(interp,cmd);
    
    //New DatabaseDumper
    printf("\niNalyzer [3/9] Dumping SQLite files:");
       cmd = [NSString stringWithFormat:@"/Applications/iNalyzer5.app/dumpSQLFiles.sh '%@Payload/ClientFiles/' '%@Payload/ReversingFiles/' 2>/dev/null",workingDir,workingDir ];
    //printf([ cmd UTF8String ]);
    interp =@"/bin/sh";
    string = runCmdString(interp,cmd);
    printf("Done");
    
    //echo '~~~~~~~~~~~~~{.xml}' > ../ReversingFiles/Entitlements.md ;  cat WhatsApp | awk '{ if ($0 ~ /<plist/) { flag=1;} if ($0 ~/\/plist>/) {print $0; flag=0; } if (flag==1){print $0; } } ' >> ../ReversingFiles/Entitlements.md ; echo '~~~~~~~~~~~~~' >> ../ReversingFiles/Entitlements.md
    printf("\niNalyzer [4/9] Dumping Entitlements:");
        cmd = [NSString stringWithFormat:@"echo '~~~~~~~~~~~~~{.xml}' > '%@Payload/ReversingFiles/Entitelments.md' && cat '%@' | awk '{ if ($0 ~ /<plist version=/) { flag=1;} if ($0 ~/\\/plist>/) {print $0; flag=0; } if (flag==1){print $0; } } ' >> '%@Payload/ReversingFiles/Entitelments.md' && echo '~~~~~~~~~~~~~' >>'%@Payload/ReversingFiles/Entitelments.md' ",workingDir,fbinary_path,workingDir,workingDir ];
    //printf([ cmd UTF8String ]);
    interp =@"/bin/sh";
    string = runCmdString(interp,cmd);
    printf("Done");
    
    // plistFiles
    printf("\niNalyzer [5/9] Dumping plist files:");
    cmd = [NSString stringWithFormat:@"/Applications/iNalyzer5.app/dumpPlistFiles.sh '%@Payload/ClientFiles/' '%@Payload/ReversingFiles/' 2>/dev/null ",workingDir,workingDir ];
    //printf([ cmd UTF8String ]);
    interp =@"/bin/sh";
    string = runCmdString(interp,cmd);
    printf("Done");
    
    // Binary Cookies
    printf("\niNalyzer [6/9] Dumping binary cookies:");
    cmd=[NSString stringWithFormat:@"ls '%@Payload/ClientFiles/Library/Cookies/Cookies.binarycookies' 2>/dev/null" ,workingDir ];
    interp =@"/bin/sh";
    NSString *ffo = runCmdString(interp,cmd);
    if(![ffo isEqual:@"-1"])
    {
    //printf("\niNalyzer [2/3] found cookies at:%s",[ffo UTF8String]);
    cmd = [NSString stringWithFormat:@"echo '~~~~~~~~~~~~~{.py}' > '%@Payload/ReversingFiles/Cookies.md' && python /Applications/iNalyzer5.app/BinaryCookieReader.py '%@Payload/ClientFiles/Library/Cookies/Cookies.binarycookies'  >>'%@Payload/ReversingFiles/Cookies.md' && echo '~~~~~~~~~~~~~' >>'%@Payload/ReversingFiles/Cookies.md'  ",workingDir,workingDir,workingDir,workingDir ];
    //printf([ cmd UTF8String ]);
    interp =@"/bin/sh";
    string = runCmdString(interp,cmd);
    printf("Done");
    }else
    {
        printf("failed");
    }
    
    //./keychain_dumper | tr '\n' '#' | sed 's/##/~/g' | tr '~' '\n' | grep -i whatsapp | tr '#' '\n'//
   
    printf("\niNalyzer [7/9] Dumping keychain data:");
    cmd = [NSString stringWithFormat:@"/Applications/iNalyzer5.app/dumpKeychain.sh '%@Payload/ReversingFiles/Entitelments.md' '%@Payload/ReversingFiles/' 2>/dev/null ",workingDir,workingDir ];
    //printf([ cmd UTF8String ]);
    interp =@"/bin/sh";
    string = runCmdString(interp,cmd);
    printf("Done");
    
    //protection class
    printf("\niNalyzer [8/9] Dumping File Protection Class:");
    NSString *ps=@"Protection Class\n==========\n<Table>\n<TR><TH>file path</TH><TH>NSFileProtectionKey</TH></TR>\n";
    NSString *name=@"";
    NSString *fPath=@"";
    NSString *pClass=@"";
    NSString *path=[NSString stringWithFormat:@"%@../" ,application_basedir];
    NSFileManager *fm = [ NSFileManager defaultManager ];
    NSDirectoryEnumerator *fin = [ fm enumeratorAtPath:path ];
    
    NSString *pcfile=[workingDir stringByAppendingFormat:@"Payload/ReversingFiles/ProtectionClass.md"];
    
    [ ps writeToFile:pcfile atomically:YES encoding:NSUTF8StringEncoding error:NULL ];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:pcfile];
    if (fileHandle){
        [fileHandle seekToEndOfFile];
       
        
    }
    ps=@"";
    while (name=[fin nextObject] )
    {
        fPath=[ path stringByAppendingString:name] ;
        pClass=[[ fm attributesOfItemAtPath:fPath error:nil ] objectForKey:@"NSFileProtectionKey" ];
        ps=[ ps stringByAppendingFormat:@"\n<TR><TD>%@</TD><TD>%@</TD></TR>",name,pClass];
        
        [fileHandle writeData:[ps dataUsingEncoding:NSUTF8StringEncoding]];
        ps=@"";
    }
    ps=[ ps stringByAppendingString:@"\n</Table>\n"];
    [fileHandle writeData:[ps dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
    
    printf("Done");
    /*
     
     dc=$( printf "/*! \\page InfoPlist Info.Plist Content \n\section data\n" 2>/dev/null 1> "$WorkDir/Payload/ReversingFiles/__InfoPlist__.h" )
     
     dd=$(plutil -show "$AppPath/$AppName/Info.plist" 2>&1 | tr ';' '\n' 1>> "$WorkDir/Payload/ReversingFiles/__InfoPlist__.h" 2>&1 )
     de=$( printf "\\endpage"   2>/dev/null 1>>"$WorkDir/Payload/ReversingFiles/__InfoPlist__.h" )
     */
    
    // Info plist is included in plist file as of version 7.0
    //cmd = @"/*! \\page InfoPlist Info.Plist Content \n\\code" ;
    //[ cmd writeToFile:[workingDir stringByAppendingFormat:@"Payload/ReversingFiles/__InfoPlist__.h"] atomically:YES encoding:NSUTF8StringEncoding error:NULL ];
    
    //cmd = [NSString stringWithFormat:@" plutil -show '%@/Info.plist' 2>&1 | tr ';' ' ' 2>/dev/null >> '%@Payload/ReversingFiles/__InfoPlist__.h' && echo '\\endcode*/' 1>>'%@Payload/ReversingFiles/__InfoPlist__.h'",application_basedir,workingDir,workingDir ];
    //printf([ cmd UTF8String ]);
    //interp =@"/bin/sh";
    //string = runCmdString(interp,cmd);
    
    
    /////#iNalyzer# Creating URI and SQL Dump
    ////echo "${Meter75}iNalyzer:Dumping URI/SQL Strings"
    ////c=$( printf "/*! \\mainpage Strings analysis\nAnalysis of Strings found in the executable\n\section SQL SQL Strings\n" 2>/dev/null 1> "$WorkDir/Payload/ReversingFiles/__iNalyzer__.h" )
 
    cmd = @"/*! \\mainpage Strings analysis\nAnalysis of Strings found in the executable\n\\section SQL SQL Strings\n";
    [cmd writeToFile:[workingDir stringByAppendingFormat:@"Payload/ReversingFiles/__iNalyzer__.h"] atomically:YES encoding:NSUTF8StringEncoding error:NULL ];
    
    /*
     d=$(   -iE  '(DELETE.*FROM)|(INSERT.*TO)|(SELECT.*FROM)|(UPDATE.*WHERE)' "$WorkDir/Payload/ReversingFiles/__String_dump__.h" 2>/dev/null | sort -iu 2>/dev/null | awk '{print FNR" "$0"\n"}' 2>/dev/null 1>> "$WorkDir/Payload/ReversingFiles/__iNalyzer__.h" )

     */
    
    cmd = [NSString stringWithFormat:@" grep -iE  '(DELETE.*FROM)|(INSERT.*TO)|(SELECT.*FROM)|(UPDATE.*WHERE)' '%@Payload/ReversingFiles/__String_dump__.h' 2>/dev/null | sort -iu 2>/dev/null | awk '{print FNR\" \"$0\"\\n\"}' 2>/dev/null 1>>'%@Payload/ReversingFiles/__iNalyzer__.h'",workingDir,workingDir ];     
    
    //printf([ cmd UTF8String ]);
    interp =@"/bin/sh";
    string = runCmdString(interp,cmd);
    
    /*
     printf "\n\section URI URI strings\n" 2>/dev/null 1>> "$WorkDir/Payload/ReversingFiles/__iNalyzer__.h
     */
    
    cmd = [NSString stringWithFormat:@"printf \"\\n\\section URI URI strings\\n\\code\" 2>/dev/null 1>> '%@Payload/ReversingFiles/__iNalyzer__.h'",workingDir];     
    
    //printf([ cmd UTF8String ]);
    interp =@"/bin/sh";
    string = runCmdString(interp,cmd);
  
    
    /*
     grep -iE  '(:\/\/)|(:\/\/)' %@Payload/ReversingFiles/__String_dump__.h 2>/dev/null  | sort -iu 2>/dev/null | awk '{print FNR\" \"$0\"\\n\"}' 2>/dev/null 1>> %@Payload/ReversingFiles/__iNalyzer__.h"
     */
    cmd = [NSString stringWithFormat:@"grep -iE  '(:\\/\\/)|(:\\/\\/)' '%@Payload/ReversingFiles/__String_dump__.h' 2>/dev/null  | sort -iu 2>/dev/null | awk '{print FNR\" \"$0\"\\n\"}' 2>/dev/null 1>> '%@Payload/ReversingFiles/__iNalyzer__.h' && printf \"\\\\\\endcode*/\" 2>/dev/null 1>> '%@Payload/ReversingFiles/__iNalyzer__.h'",workingDir,workingDir,workingDir ];  
    string = runCmdString(interp,cmd);
    
    //printf([ cmd UTF8String ]);
  
   // cmd = [NSString stringWithFormat:@"echo '\\section Application%@ %@<BR>%@<a href=\"javascript:command('UIApp.keyWindow.rootViewController\=new %@\;\[%@ init\]');\">load</a>\n'",vc,vc,vc,vc,vc];
//    string = runCmdString(interp,cmd);
  //  printf("%s",[ string UTF8String ]);
    /*
     echo "${Meter75}iNalyzer:Dumping Headers"
     class-dump-z -H -k -k -o "$WorkDir/Payload/ReversingFiles" "$AppExec"
     */
    
    
     /*
      
      
      cd "$WorkDir/Payload/ReversingFiles"
      echo "${Meter75}iNalyzer:Patching Headers"
      headers=$( ls "$WorkDir/Payload/ReversingFiles/" | grep .h )
      for f in $headers
      do
      b=$( cat ${f} 2>/dev/null | sed 's/__attribute__((visibility("hidden")))//g' > ${f}_fixed )
      a=$( mv ./${f}_fixed ${f} 2>&1> /dev/null)
      done
      
      */
    printf("\niNalyzer [9/9] Patching Headers:");
    cmd = [NSString stringWithFormat:@" cd '%@'/Payload/ReversingFiles ; headers=$( ls '%@'/Payload/ReversingFiles/*.h ); for f in $headers; do cat ${f} 2>/dev/null | sed 's/__attribute__((visibility(\"hidden\")))//g' | sed 's/\\/\\/ declared property setter://g' | sed 's/\\/\\/ declared property getter://g' > ${f}_fixed; done",workingDir,workingDir ];
   
    // FIX 5.5.2b added | sed 's/\\/\\/ declared property setter://g' | sed 's/\\/\\/ declared property getter://g' 
    
    interp =@"/bin/sh";
    string = runCmdString(interp,cmd);
    if ([string isEqualToString:@"-1"]){
        printf ("Failed - error patching headers\n");
        return nil ;}
    
    
    cmd = [NSString stringWithFormat:@" cd '%@'/Payload/ReversingFiles ; for f in $( ls *_fixed) ; do new=$( echo ${f} | sed 's/_fixed//g'); mv ${f} ${new}; done",workingDir ];
    interp =@"/bin/sh";
    string = runCmdString(interp,cmd);
    if ([string isEqualToString:@"-1"]){
        printf ("Failed - error patching headers\n");
        return nil ;}
    printf ("Done\n");
    ////
   
    
    //printf([ cmd UTF8String ]);
  
    

    
    
    

    NSString *resultsFilePath = [NSString stringWithFormat:@"%@Payload/ReversingFiles/__iNalyzer__.h",workingDir];
    

    NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:resultsFilePath];
    
     NSString *content = [NSString stringWithFormat:@"\n/*!\\page Application-Views ViewControllers\n " ];   
    
    NSData * theData=[content dataUsingEncoding:NSUTF8StringEncoding];
    
    [myHandle seekToEndOfFile];
    [myHandle writeData:theData];
    [myHandle closeFile];
    ////newViewControllers///
    ///
    interp =@"/bin/sh";
   // cmd = [NSString stringWithFormat:@"for f in $(class-dump-z -f viewDidLoad %@  | grep @interface | cut -d':' -f1 | awk '{print \$2}' | sort -u ) do echo \"\\section app\${f}asd \${f}\n\${f} click to \\<a href=\"javascript:command\\('UIApp.keyWindow.rootViewController=[[\${f} alloc]init]'\\)\\;\"\\>load\\</a\\>\n\" done  2>/dev/null  1>> %@Payload/ReversingFiles/__iNalyzer__.h",fbinary_path ,workingDir ];  
    cmd = [NSString stringWithFormat:@" for f in $(grep -lia viewDid %@/Payload/ReversingFiles/* | grep -v __.h | sort -u | sed 's/\\.h//g' | awk 'BEGIN {FS=\"/\";} {print $NF;}' ); do echo \"\\section app${f}asd ${f}\n${f} click to <a href=\\\"javascript:command('UIApp.keyWindow.rootViewController=[[${f} alloc]init]');\\\">load</a></div></div>\" ; done 2>/dev/null  1>> '%@Payload/ReversingFiles/__iNalyzer__.h' && echo '*/' >> '%@Payload/ReversingFiles/__iNalyzer__.h'",workingDir ,workingDir,workingDir];
    string = runCmdString(interp,cmd);
    printf("%s",[ string UTF8String ]);
    
    
    
    ///endNewViewControllers//
    /*
    NSString *headersPath = [NSString stringWithFormat:@"%@Payload/ReversingFiles/",workingDir];
    
    NSArray *cvc = [[NSFileManager defaultManager ]  contentsOfDirectoryAtPath:headersPath error:NULL ];
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"self ENDSWITH 'ViewController.h'" ];
    
    
    NSArray * results = [cvc filteredArrayUsingPredicate:filter ];
    for(NSString * name in results)
    {
        NSString *fName = [name stringByReplacingOccurrencesOfString:@".h" withString:@""] ;
        content = [NSString stringWithFormat:@"\\section app%@asd %@\n%@ click to <a href=\"javascript:command\('UIApp.keyWindow.rootViewController=[[%@ alloc]init]');\">load</a>\n",fName,fName,fName,fName ];
        theData=[content dataUsingEncoding:NSUTF8StringEncoding];
        
        //interp =@"/bin/sh";
        //string = runCmdString(interp,cmd);
        //printf("got name %s",[ string UTF8String ]);
        
       // [myHandle seekToEndOfFile];
        [myHandle writeData:theData];
    }
    */
    //cmd = [NSString stringWithFormat:@"printf \"*/\" 2>/dev/null 1>> %@Payload/ReversingFiles/__iNalyzer__.h",workingDir];     
    
    //printf([ cmd UTF8String ]);
    //interp =@"/bin/sh";
   // string = runCmdString(interp,cmd);
    
    //content = @"*/" ;
    //theData=[content dataUsingEncoding:NSUTF8StringEncoding];
    //[myHandle seekToEndOfFile];
    //[myHandle writeData:theData];

    //return nil;
    
    
   // printf ("iNalyzer:Population Done\n%s", [ string UTF8String]);
    
    
    
    //printf("Copying %s to /tmp/ ...\n", [fbinary_path UTF8String]);
   
  //  [[NSFileManager defaultManager] copyItemAtPath:fbinary_path toPath:[[NSString alloc] initWithString:@"/tmp/Binary"  ] error:NULL];
    /*
     */
    // END iNalyzer
    NSString *ipapath;
	if (bash!=22){
    printf("\nModding Info.plist");
    NSMutableDictionary *metadataPlist = [NSMutableDictionary dictionaryWithContentsOfFile:[application_basedir stringByAppendingString:@"/../iTunesMetadata.plist"]];
	
	[[NSFileManager defaultManager] copyItemAtPath:[application_basedir stringByAppendingString:@"/../iTunesArtwork"] toPath:[workingDir stringByAppendingString:@"iTunesArtwork"] error:NULL];
    
	if (![[iNalyzer5Configuration getValue:@"RemoveMetadata"] isEqualToString:@"YES"]) {
        VERBOSE("Censoring iTunesMetadata.plist...");
		struct stat statbuf_metadata;
		stat([[application_basedir stringByAppendingString:@"/../iTunesMetadata.plist"] UTF8String], &statbuf_metadata);
		time_t mst_atime = statbuf_metadata.st_atime;
		time_t mst_mtime = statbuf_metadata.st_mtime;
		struct utimbuf oldtimes_metadata;
		oldtimes_metadata.actime = mst_atime;
		oldtimes_metadata.modtime = mst_mtime;
		
        NSString *fake_email;
        NSDate *fake_purchase_date;
        
        if (nil == (fake_email = [iNalyzer5Configuration getValue:@"MetadataEmail"])) {
            fake_email = @"steve@rim.jobs";
        }
        
        if (nil == (fake_purchase_date = [iNalyzer5Configuration getValue:@"MetadataPurchaseDate"])) {
            fake_purchase_date = [NSDate dateWithTimeIntervalSince1970:1251313938];
        }
        
		NSDictionary *censorList = [NSDictionary dictionaryWithObjectsAndKeys:fake_email, @"appleId", fake_purchase_date, @"purchaseDate", nil];
		if ([[iNalyzer5Configuration getValue:@"CheckMetadata"] isEqualToString:@"YES"]) {
			NSDictionary *noCensorList = [NSDictionary dictionaryWithObjectsAndKeys:
										  @"", @"artistId",
										  @"", @"artistName",
										  @"", @"buy-only",
										  @"", @"buyParams",
										  @"", @"copyright",
										  @"", @"drmVersionNumber",
										  @"", @"fileExtension",
										  @"", @"genre",
										  @"", @"genreId",
										  @"", @"itemId",
										  @"", @"itemName",
										  @"", @"gameCenterEnabled",
										  @"", @"gameCenterEverEnabled",
										  @"", @"kind",
										  @"", @"playlistArtistName",
										  @"", @"playlistName",
										  @"", @"price",
										  @"", @"priceDisplay",
										  @"", @"rating",
										  @"", @"releaseDate",
										  @"", @"s",
										  @"", @"softwareIcon57x57URL",
										  @"", @"softwareIconNeedsShine",
										  @"", @"softwareSupportedDeviceIds",
										  @"", @"softwareVersionBundleId",
										  @"", @"softwareVersionExternalIdentifier",
                                          @"", @"UIRequiredDeviceCapabilities",
										  @"", @"softwareVersionExternalIdentifiers",
										  @"", @"subgenres",
										  @"", @"vendorId",
										  @"", @"versionRestrictions",
										  @"", @"com.apple.iTunesStore.downloadInfo",
										  @"", @"bundleVersion",
										  @"", @"bundleShortVersionString", nil];
			for (id plistItem in metadataPlist) {
				if (([noCensorList objectForKey:plistItem] == nil) && ([censorList objectForKey:plistItem] == nil)) {
					printf("\033[0;37;41mwarning: iTunesMetadata.plist item named '\033[1;37;41m%s\033[0;37;41m' is unrecognized\033[0m\n", [plistItem UTF8String]);
				}
			}
		}
		
		for (id censorItem in censorList) {
			[metadataPlist setObject:[censorList objectForKey:censorItem] forKey:censorItem];
		}
		[metadataPlist removeObjectForKey:@"com.apple.iTunesStore.downloadInfo"];
		[metadataPlist writeToFile:[workingDir stringByAppendingString:@"iTunesMetadata.plist"] atomically:NO];
		utime([[workingDir stringByAppendingString:@"iTunesMetadata.plist"] UTF8String], &oldtimes_metadata);
		utime([[application_basedir stringByAppendingString:@"/../iTunesMetadata.plist"] UTF8String], &oldtimes_metadata);
	}
	
	NSString *crackerName = [iNalyzer5Configuration getValue:@"CrackerName"];
	if ([[iNalyzer5Configuration getValue:@"CreditFile"] isEqualToString:@"YES"]) {
        VERBOSE("Creating credit file...");
		FILE *fh = fopen([[workingDir stringByAppendingFormat:@"_%@", crackerName] UTF8String], "w");
		NSString *creditFileData = [NSString stringWithFormat:@"%@ (%@) Cracked by %@ using %s.", [infoplist objectForKey:@"CFBundleDisplayName"], [infoplist objectForKey:@"CFBundleVersion"], crackerName, iNalyzer5_VERSION];
		fwrite([creditFileData UTF8String], [creditFileData lengthOfBytesUsingEncoding:NSUTF8StringEncoding], 1, fh);
		fclose(fh);
	}
    
    if (overdrive_enabled) {
        VERBOSE("Including overdrive dylib...");
        [[NSFileManager defaultManager] copyItemAtPath:@"/var/lib/iNalyzer5/overdrive.dylib" toPath:[workingDir stringByAppendingFormat:@"Payload/%@/overdrive.dylib", basename] error:NULL];
        
        VERBOSE("Creating fake SC_Info data...");
        // create fake SC_Info directory
        [[NSFileManager defaultManager] createDirectoryAtPath:[workingDir stringByAppendingFormat:@"Payload/%@/SF_Info/", basename] withIntermediateDirectories:YES attributes:nil error:NULL];
        
        // create fake SC_Info SINF file
        FILE *sinfh = fopen([[workingDir stringByAppendingFormat:@"Payload/%@/SF_Info/%@.sinf", basename, binary_name] UTF8String], "w");
        void *sinf = generate_sinf([[metadataPlist objectForKey:@"itemId"] intValue], (char *)[crackerName UTF8String], [[metadataPlist objectForKey:@"vendorId"] intValue]);
        fwrite(sinf, CFSwapInt32(*(uint32_t *)sinf), 1, sinfh);
        fclose(sinfh);
        free(sinf);
        
        // create fake SC_Info SUPP file
        FILE *supph = fopen([[workingDir stringByAppendingFormat:@"Payload/%@/SF_Info/%@.supp", basename, binary_name] UTF8String], "w");
        uint32_t suppsize;
        void *supp = generate_supp(&suppsize);
        fwrite(supp, suppsize, 1, supph);
        fclose(supph);
        free(supp);
    }
    
    VERBOSE("Packaging IPA file...");
    
    // filename addendum
    NSString *addendum = @"";
    
    if (overdrive_enabled)
        addendum = @"-OD";

    
	
//	if ([[iNalyzer5Configuration getValue:@"FilenameCredit"] isEqualToString:@"YES"]) {
//		ipapath = [NSString stringWithFormat:@"/var/root/Documents/iNalyzer/%@-v%@-%@%@.ipa", [[infoplist objectForKey:@"CFBundleDisplayName"] stringByReplacingOccurrencesOfString:@"/" withString:@"_"], [infoplist objectForKey:@"CFBundleVersion"], crackerName, addendum];
//	} else {
		ipapath = [NSString stringWithFormat:@"/var/root/Documents/iNalyzer/%@-v%@%@.ipa", [[infoplist objectForKey:@"CFBundleDisplayName"] stringByReplacingOccurrencesOfString:@"/" withString:@"_"], [infoplist objectForKey:@"CFBundleVersion"], addendum];
//	}
    }else
    {
        
         ipapath = [NSString stringWithFormat:@"/var/root/Documents/iNalyzer/%@-direct.ipa",binary_name];
    }
	[[NSFileManager defaultManager] createDirectoryAtPath:@"/var/root/Documents/iNalyzer/" withIntermediateDirectories:TRUE attributes:nil error:NULL];
	[[NSFileManager defaultManager] removeItemAtPath:ipapath error:NULL];
    
	//NSString *compressionArguments = [[iNalyzer5Configuration getValue:@"CompressionArguments"] stringByAppendingString:@" "];
    
    /*if (bash) {
        //BASH!!11!!
        
        NSDictionary *environment = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ipapath", ipapath,
                                    // @"CompressionArguments", compressionArguments,
                                     @"appname", [infoplist objectForKey:@"CFBundleDisplayName"],
                                     @"appversion", [infoplist objectForKey:@"CFBundleVersion"],
                                     nil];
        
        NSTask * bash = [[NSTask alloc] init];
        [bash setLaunchPath:@"/bin/bash"];
        [bash setCurrentDirectoryPath:@"/"];
        NSPipe * out = [NSPipe pipe];
        [bash setStandardOutput:out];
        [bash setEnvironment:environment];
        
        [bash launch];
        [bash waitUntilExit];
        [bash release];
        
        NSFileHandle * read = [out fileHandleForReading];
        NSData * dataRead = [read readDataToEndOfFile];
        NSString * stringRead = [[[NSString alloc] initWithData:dataRead encoding:NSUTF8StringEncoding] autorelease];
        NSArray* dataArray = [stringRead componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        for (NSString *string in dataArray) {
            NSArray *split = [string componentsSeparatedByString:[NSCharacterSet whitespaceCharacterSet]];
            if ([[split objectAtIndex:0] isEqualToString:@"ipapath"]) {
                ipapath = [split objectAtIndex:1];
            }
            else if ([[split objectAtIndex:0] isEqualToString:@"CompressionArguments"]) {
                //compressionArguments = [split objectAtIndex:1];
            }
        }
        char* output = (char *)[[NSString stringWithFormat:@"Script output: %@", stringRead] UTF8String];
        VERBOSE(output);        
    }
    
	if (compressionArguments == nil)
		compressionArguments = @"";*/
    
    stop_bar();
    NOTIFY("Compressing original application (1/2)...");
    ZipArchive *archiver = [[ZipArchive alloc] init];
    BOOL *ret=[archiver CreateZipFile2:ipapath];
    pause_bar();
    zip_original(archiver, [application_basedir stringByAppendingString:@"../"], binary_name, ipapath);
    stop_bar();
    
    NOTIFY("Compressing decrypted application (2/2)..");
    zip(archiver, workingDir);
    stop_bar();
    /*
    //add symlink
    
    [[NSFileManager defaultManager] moveItemAtPath:[workingDir stringByAppendingString:@"Payload"] toPath:[workingDir stringByAppendingString:@"Payload_1"] error:NULL];
    
     NOTIFY("Compressing second stage payload (2/2)...");
    
    [[NSFileManager defaultManager] createSymbolicLinkAtPath:[workingDir stringByAppendingString:@"Payload"] withDestinationPath:[application_basedir stringByAppendingString:@"/../"] error:NULL];
    zip(archiver, workingDir, compression_level);
    stop_bar();*/
    
    if (![archiver CloseZipFile2]) {
        printf("error: could not save zip file ");
    }
    
    
//    
//	/*system([[NSString stringWithFormat:@"cd %@; zip %@-m -r \"%@\" * 2>&1> /dev/null", workingDir, compressionArguments, ipapath] UTF8String]);*/
//    
//	[[NSFileManager defaultManager] moveItemAtPath:[workingDir stringByAppendingString:@"Payload"] toPath:[workingDir stringByAppendingString:@"Payload_1"] error:NULL];
//    
//    NOTIFY("Compressing second stage payload (2/2)...");
//    
//	[[NSFileManager defaultManager] createSymbolicLinkAtPath:[workingDir stringByAppendingString:@"Payload"] withDestinationPath:[application_basedir stringByAppendingString:@"/../"] error:NULL];
//    
//	system([[NSString stringWithFormat:@"cd %@; zip %@-u -y -r -n .jpg:.JPG:.jpeg:.png:.PNG:.gif:.GIF:.Z:.gz:.zip:.zoo:.arc:.lzh:.rar:.arj:.mp3:.mp4:.m4a:.m4v:.ogg:.ogv:.avi:.flac:.aac \"%@\" Payload/* -x Payload/iTunesArtwork Payload/iTunesMetadata.plist \"Payload/Documents/*\" \"Payload/Library/*\" \"Payload/tmp/*\" \"Payload/*/%@\" \"Payload/*/SC_Info/*\" 2>&1> /dev/null", workingDir, compressionArguments, ipapath, binary_name] UTF8String]);
//	
    [archiver release];
    
    NSMutableDictionary *dict;
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/etc/iNalyzer5_cracked.plist"]) {
        dict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/etc/iNalyzer5_cracked.plist"];
    }
    else {
        [[NSFileManager defaultManager] createFileAtPath:@"/etc/iNalyzer5_cracked.plist" contents:nil attributes:nil];
        dict = [[NSMutableDictionary alloc] init];
    }
    if (bash!=22){
    [dict setObject:version forKey: [infoplist objectForKey:@"CFBundleDisplayName"]];
        [dict writeToFile:@"/etc/iNalyzer5_cracked.plist" atomically:YES];
    }
	[[NSFileManager defaultManager] removeItemAtPath:workingDir error:NULL];
    [dict release];
	return ipapath;
	
fatalc: {
	[[NSFileManager defaultManager] removeItemAtPath:workingDir error:NULL];
	return nil;
}
}

NSString * init_crack_binary(NSString *application_basedir, NSString *bdir, NSString *workingDir, NSDictionary *infoplist) {
    VERBOSE("Performing cracking preflight...");
	NSString *binary_name = [infoplist objectForKey:@"CFBundleExecutable"];
	NSString *binary_path = [application_basedir stringByAppendingString:binary_name];
	NSString *fbinary_path = [workingDir stringByAppendingFormat:@"Payload/%@/%@", bdir, binary_name];
	
	NSString *err = nil;
	
	struct stat statbuf;
	stat([binary_path UTF8String], &statbuf);
	time_t bst_atime = statbuf.st_atime;
	time_t bst_mtime = statbuf.st_mtime;
	
	NSString *ret = crack_binary(binary_path, fbinary_path, &err);
	
	struct utimbuf oldtimes;
	oldtimes.actime = bst_atime;
	oldtimes.modtime = bst_mtime;
	
	utime([binary_path UTF8String], &oldtimes);
	utime([fbinary_path UTF8String], &oldtimes);
	
	if (ret == nil)
		printf("error: %s\n", [err UTF8String]);
	
	return ret;
}

NSString * crack_binary(NSString *binaryPath, NSString *finalPath, NSString **error) {
    //debug// printf ("iNalyzer:crack_binary got %s %s ", [binaryPath  UTF8String] , [finalPath  UTF8String]);
	[[NSFileManager defaultManager] copyItemAtPath:binaryPath toPath:finalPath error:NULL]; // move the original binary to that path
	NSString *baseName = [binaryPath lastPathComponent]; // get the basename (name of the binary)
	NSString *baseDirectory = [NSString stringWithFormat:@"%@/", [binaryPath stringByDeletingLastPathComponent]]; // get the base directory
	
    
    ////
    NSString *isEnc = runCmdString([NSString stringWithString:@"/bin/sh"], [NSString stringWithFormat:@"otool -l '%@' | grep cryptid | grep -c 1",finalPath]);
    if ([isEnc isEqualToString:@"-1"])
    {
     printf("Application is not encrypted");
        return finalPath;
    }else {
        printf("Application is encrypted");
        //return finalPath;
    }
    ////
    
	// open streams from both files
	FILE *oldbinary, *newbinary;
	oldbinary = fopen([binaryPath UTF8String], "r+");
	newbinary = fopen([finalPath UTF8String], "r+");
	
	// the first four bytes are the magic which defines whether the binary is fat or not
	uint32_t bin_magic;
	fread(&bin_magic, 4, 1, oldbinary);
	
	if (bin_magic == FAT_CIGAM) {
		// fat binary
		uint32_t bin_nfat_arch;
		fread(&bin_nfat_arch, 4, 1, oldbinary); // get the number of fat architectures in the file
		bin_nfat_arch = CFSwapInt32(bin_nfat_arch);
		
		// check if the architecture requirements of the fat binary are met
		// should be two architectures
		if (bin_nfat_arch != 2) {
			*error = @"Invalid architectures or headers.";
			goto c_err;
		}
		
		int local_arch = get_local_arch(); // get the local architecture
		
		// get the following fat architectures and determine which is which
		struct fat_arch armv6, armv7;
		fread(&armv6, sizeof(struct fat_arch), 1, oldbinary);
		fread(&armv7, sizeof(struct fat_arch), 1, oldbinary);
		
        //only_armv7 = 1;
        if (local_arch != ARMV6 )
            only_armv7 = 1;
        
        if (only_armv7 == 1) {
            if (local_arch == ARMV6) {
                *error = @"You are not using an ARMV7 device";
                goto c_err;
            }
            VERBOSE("Only dumping ARMV7 portion because you said so");
            NOTIFY("Dumping ARMV7 portion...");
			// we can only crack the armv7 portion
			if (!dump_binary(oldbinary, newbinary, CFSwapInt32(armv7.offset), binaryPath)) {
                stop_bar();
				*error = @"Cannot crack ARMV7 portion.";
				goto c_err;
			}
            stop_bar();
			
            VERBOSE("Performing liposuction of ARMV7 mach object...");
			// lipo out the data
			NSString *lipoPath = [NSString stringWithFormat:@"%@_l", finalPath]; // assign a new lipo path
			FILE *lipoOut = fopen([lipoPath UTF8String], "w+"); // prepare the file stream
			fseek(newbinary, CFSwapInt32(armv7.offset), SEEK_SET); // go to the armv6 offset
			void *tmp_b = malloc(0x1000); // allocate a temporary buffer
			
			uint32_t remain = CFSwapInt32(armv7.size);
			
			while (remain > 0) {
				if (remain > 0x1000) {
					// move over 0x1000
					fread(tmp_b, 0x1000, 1, newbinary);
					fwrite(tmp_b, 0x1000, 1, lipoOut);
					remain -= 0x1000;
				} else {
					// move over remaining and break
					fread(tmp_b, remain, 1, newbinary);
					fwrite(tmp_b, remain, 1, lipoOut);
					break;
				}
			}
			
			free(tmp_b); // free temporary buffer
			fclose(lipoOut); // close lipo output stream
			fclose(newbinary); // close new binary stream
			fclose(oldbinary); // close old binary stream
			
			[[NSFileManager defaultManager] removeItemAtPath:finalPath error:NULL]; // remove old file
			[[NSFileManager defaultManager] moveItemAtPath:lipoPath toPath:finalPath error:NULL]; // move the lipo'd binary to the final path
			chown([finalPath UTF8String], 501, 501); // adjust permissions
			chmod([finalPath UTF8String], 0777); // adjust permissions
			
			return finalPath;

        }
		else if (local_arch != ARMV6) {
            VERBOSE("Application is a fat binary, cracking both architectures...");
            NOTIFY("Dumping ARMV7 portion...");
            
			// crack the armv7 portion
			if (!dump_binary(oldbinary, newbinary, CFSwapInt32(armv7.offset), binaryPath)) {
                stop_bar();
				*error = @"Cannot crack ARMV7 portion of fat binary.";
				goto c_err;
			}
			
			// we need to move the binary temporary as well as the decryption key names
			// this avoids the IV caching problem with fat binary cracking (and allows us to crack
			// the armv6 portion)
			VERBOSE("Preparing to crack ARMV6 portion...");
			// move the binary first
			
			NSString *orig_old_path = binaryPath; // save old binary path
			binaryPath = [binaryPath stringByAppendingString:@"_lwork"]; // new binary path
			[[NSFileManager defaultManager] moveItemAtPath:orig_old_path toPath:binaryPath error:NULL];
			fclose(oldbinary);
			oldbinary = fopen([binaryPath UTF8String], "r+");
			
			// move the SC_Info keys
			
			NSString *scinfo_prefix = [baseDirectory stringByAppendingFormat:@"SC_Info/%@", baseName];
			
			[[NSFileManager defaultManager] moveItemAtPath:[scinfo_prefix stringByAppendingString:@".sinf"] toPath:[scinfo_prefix stringByAppendingString:@"_lwork.sinf"] error:NULL];
			[[NSFileManager defaultManager] moveItemAtPath:[scinfo_prefix stringByAppendingString:@".supp"] toPath:[scinfo_prefix stringByAppendingString:@"_lwork.supp"] error:NULL];
			
			// swap the architectures
			
			uint8_t armv7_subtype = 0x09;
			uint8_t armv6_subtype = 0x06;
			
			fseek(oldbinary, 15, SEEK_SET);
			fwrite(&armv7_subtype, 1, 1, oldbinary);
			fseek(oldbinary, 35, SEEK_SET);
			fwrite(&armv6_subtype, 1, 1, oldbinary);
			
            PERCENT(-1);
            NOTIFY("Dumping ARMV6 portion...");
			// crack armv6 portion now
			BOOL res = dump_binary(oldbinary, newbinary, CFSwapInt32(armv6.offset), binaryPath);
			stop_bar();
            
			// swap the architectures back
			fseek(oldbinary, 15, SEEK_SET);
			fwrite(&armv6_subtype, 1, 1, oldbinary);
			fseek(oldbinary, 35, SEEK_SET);
			fwrite(&armv7_subtype, 1, 1, oldbinary);
			
			// move the binary and SC_Info keys back
			[[NSFileManager defaultManager] moveItemAtPath:binaryPath toPath:orig_old_path error:NULL];
			[[NSFileManager defaultManager] moveItemAtPath:[scinfo_prefix stringByAppendingString:@"_lwork.sinf"] toPath:[scinfo_prefix stringByAppendingString:@".sinf"] error:NULL];
			[[NSFileManager defaultManager] moveItemAtPath:[scinfo_prefix stringByAppendingString:@"_lwork.supp"] toPath:[scinfo_prefix stringByAppendingString:@".supp"] error:NULL];
			
			if (!res) {
				*error = @"Cannot crack ARMV6 portion of fat binary.";
				goto c_err;
			}
		} else {
            VERBOSE("Application is a fat binary, only cracking ARMV6 portion (we are on an ARMV6 device)...");
            NOTIFY("Dumping ARMV6 portion...");
			// we can only crack the armv6 portion
			if (!dump_binary(oldbinary, newbinary, CFSwapInt32(armv6.offset), binaryPath)) {
                stop_bar();
				*error = @"Cannot crack ARMV6 portion.";
				goto c_err;
			}
            stop_bar();
			
            VERBOSE("Performing liposuction of ARMV6 mach object...");
			// lipo out the data
			NSString *lipoPath = [NSString stringWithFormat:@"%@_l", finalPath]; // assign a new lipo path
			FILE *lipoOut = fopen([lipoPath UTF8String], "w+"); // prepare the file stream
			fseek(newbinary, CFSwapInt32(armv6.offset), SEEK_SET); // go to the armv6 offset
			void *tmp_b = malloc(0x1000); // allocate a temporary buffer
			
			uint32_t remain = CFSwapInt32(armv6.size);
			
			while (remain > 0) {
				if (remain > 0x1000) {
					// move over 0x1000
					fread(tmp_b, 0x1000, 1, newbinary);
					fwrite(tmp_b, 0x1000, 1, lipoOut);
					remain -= 0x1000;
				} else {
					// move over remaining and break
					fread(tmp_b, remain, 1, newbinary);
					fwrite(tmp_b, remain, 1, lipoOut);
					break;
				}
			}
			
			free(tmp_b); // free temporary buffer
			fclose(lipoOut); // close lipo output stream
			fclose(newbinary); // close new binary stream
			fclose(oldbinary); // close old binary stream
			
			[[NSFileManager defaultManager] removeItemAtPath:finalPath error:NULL]; // remove old file
			[[NSFileManager defaultManager] moveItemAtPath:lipoPath toPath:finalPath error:NULL]; // move the lipo'd binary to the final path
			chown([finalPath UTF8String], 501, 501); // adjust permissions
			chmod([finalPath UTF8String], 0777); // adjust permissions
			
			return finalPath;
		}
	} else {
        VERBOSE("Application is a thin binary, cracking single architecture...");
        NOTIFY("Dumping binary...");
		// thin binary, portion begins at top of binary (0)
		if (!dump_binary(oldbinary, newbinary, 0, binaryPath)) {
            stop_bar();
			*error = @"Cannot crack thin binary.";
			goto c_err;
		}
        stop_bar();
	}
	
	fclose(newbinary); // close the new binary stream
	fclose(oldbinary); // close the old binary stream

	return finalPath; // return cracked binary path
	
c_err:
	fclose(newbinary); // close the new binary stream
	fclose(oldbinary); // close the old binary stream
	[[NSFileManager defaultManager] removeItemAtPath:finalPath error:NULL]; // delete the new binary
	return nil;
}

NSString * genRandStringLength(int len) {
	NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
	NSString *letters = @"abcdef0123456789";
	
	for (int i=0; i<len; i++) {
		[randomString appendFormat: @"%c", [letters characterAtIndex: arc4random()%[letters length]]];
	}
	
	return randomString;
}

int get_local_arch() {
	int i;
	int len = sizeof(i);
	
	sysctlbyname("hw.cpusubtype", &i, (size_t *) &len, NULL, 0);
	return i;
}

NSString * runCmdString(NSString *interp, NSString *cmd){
    /////////TASK////
    
    //foo = [NSString stringWithFormat:@"strings - %@ 2>/dev/null  | sort -iu 2>/dev/null | awk '{print FNR" "$0 }'  2>/dev/null 1>> %@Payload/ReversingFiles/__String_dump__.h && echo '\endcode*/' 1>>%@Payload/ReversingFiles/__String_dump__.h",fbinary_path,workingDir,workingDir ];     
    
    
    NSTask * task = [[NSTask alloc] init];
    [task setLaunchPath:interp];
    
    //printf([ foo UTF8String ]);
    NSArray * arguments = [NSArray arrayWithObjects: @"-c",cmd, nil];
    [task setArguments: arguments];
    
    NSPipe * pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData * data = [file readDataToEndOfFile];
    
    NSString * string = [[NSString alloc] initWithData: data
                                   encoding: NSUTF8StringEncoding];
    while ([task isRunning]){
        
    }
    if ([task terminationStatus]!=0)
        return @"-1";
    else
        return string;
    /////END TASK////
}
