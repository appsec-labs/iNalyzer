/*
 Introducing iNalyzer5, the fastest and most advanced cracking utility for the iPhone, iPod Touch, and iPad.
 
 Created by dissident at Hackulo.us (<http://hackulo.us/>)
  Credit: Nighthawk, puy0, rwxr-xr-x, Flox, Flawless, FloydianSlip, Crash-X, MadHouse, Rastignac, aulter, icefire
*/

#import "Configuration.h"
#import "applist.h"
#import "crack.h"
#import <unistd.h>

int main(int argc, char *argv[]) {
    int retVal = 0;
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	if (getuid() != 0) {
		printf("You must be root to use iNalyzer5Mod.\n");
		goto endMain;
	}
	
	// we need to import the configuration file
	[iNalyzer5Configuration configWithFile:@"/etc/iNalyzer5.conf"];
    
	if (argc < 2) {
		NSArray *applist = get_application_list(TRUE, FALSE);
		if (applist == NULL) {
			printf("There are no encrypted applications on this device.\n");
			goto endMain;
		}
		printf("usage: %s [application name] [...]\n", argv[0]);
		printf("Applications available: ");
		NSEnumerator *e = [applist objectEnumerator];
		NSDictionary *applicationDetails;
		NSString *compareWith;
		if ([(NSString *)[iNalyzer5Configuration getValue:@"ListWithDisplayName"] isEqualToString:@"YES"]) {
			compareWith = @"ApplicationDisplayName";
		} else if ([(NSString *)[iNalyzer5Configuration getValue:@"ListWithDisplayName"] isEqualToString:@"DIRECTORY"]) {
			compareWith = @"RealUniqueID";
		} else {
			compareWith = @"ApplicationName";
		}

		int cindex = 0;
		
		BOOL numberMenu = [(NSString *)[iNalyzer5Configuration getValue:@"NumberBasedMenu"] isEqualToString:@"YES"];
		if (numberMenu) {
			printf("\n");
		}
		
		while (applicationDetails = [e nextObject]) {
			if (numberMenu) {
				printf("%d ) \033[1;3%dm%s\033[0m ", cindex, 5 + ((cindex++) % 2), [[applicationDetails objectForKey:compareWith] UTF8String]);
			} else {
				printf("\033[1;3%dm%s\033[0m ", 5 + ((cindex++) % 2), [[applicationDetails objectForKey:compareWith] UTF8String]);
			}
		}
		
		printf("\n");
		
		goto endMain;
	}
	
	if (strncmp(argv[1], "--", 3) == 0) {
		NSArray *applist = get_application_list(FALSE, FALSE);
		if (applist == NULL) {
			printf("There are no encrypted applications on this device.\n");
			goto endMain;
		}
		NSEnumerator *e = [applist objectEnumerator];
		printf("Cracking all encrypted applications on this device.\n");
		
		NSDictionary *applicationDetails;
		NSString *ipapath;
		
		while (applicationDetails = [e nextObject]) {
			printf("iNalyzer is anlyzing %s...\n", [[applicationDetails objectForKey:@"ApplicationName"] UTF8String]);
            
			ipapath = crack_application([applicationDetails objectForKey:@"ApplicationDirectory"] , [applicationDetails objectForKey:@"ApplicationBasename"], [applicationDetails objectForKey:@"ApplicationVersion"]);
			if (ipapath == nil) {
				printf("Failed.\n");
			} else {
				printf("\t%s\n", [ipapath UTF8String]);
			}
		}
	} else if (strncmp(argv[1], "-u", 2) == 0) {
        NSArray *applist = get_application_list(FALSE, TRUE);
        if (applist == NULL) {
            printf("There are no new applications on this device that aren't cracked.\n");
            goto endMain;
        }
        NSEnumerator *e = [applist objectEnumerator];
        printf("Cracking all updated applications on this device.\n");
        
        NSDictionary *applicationDetails;
        NSString *ipapath;
        
        while (applicationDetails = [e nextObject]) {
            printf("iNalyzer is iNalyzing %s...\n", [[applicationDetails objectForKey:@"ApplicationName"] UTF8String]);
            ipapath = crack_application([applicationDetails objectForKey:@"ApplicationDirectory"], [applicationDetails objectForKey:@"ApplicationBasename"], [applicationDetails objectForKey:@"ApplicationVersion"]);
            if (ipapath == nil) {
                printf("Failed.\n");
            } else {
                printf("\t%s\n", [ipapath UTF8String]);
            }
        }
    } else if (strncmp(argv[1], "-f", 2) == 0) {
		[[NSFileManager defaultManager] removeItemAtPath:@"/var/cache/iNalyzer5.plist" error:NULL];
		printf("Caches cleared.\n");
	} else if (strncmp(argv[1], "-v", 2) == 0) {
		printf("%s\n", iNalyzer5_VERSION);
	} 
    else if (strncmp(argv[1], "-update", 7) == 0) {
        
    } else if (strncmp(argv[1], "-h", 2) == 0) {
        goto help;
    } else {
		BOOL numberMenu = [(NSString *)[iNalyzer5Configuration getValue:@"NumberBasedMenu"] isEqualToString:@"YES"];
		NSArray *applist;
		if (numberMenu)
			applist = get_application_list(TRUE, FALSE);
		else
			applist = get_application_list(FALSE, FALSE);

		if (applist == NULL) {
			printf("There are no encrypted applications on this device.\n");
			goto endMain;
		}
		NSString *compareWith;
		
		if ([(NSString *)[iNalyzer5Configuration getValue:@"ListWithDisplayName"] isEqualToString:@"YES"]) {
			compareWith = @"ApplicationDisplayName";
		} else if ([(NSString *)[iNalyzer5Configuration getValue:@"ListWithDisplayName"] isEqualToString:@"DIRECTORY"]) {
			compareWith = @"RealUniqueID";
		} else {
			compareWith = @"ApplicationName";
		}
		
		NSString *ipapath;
		NSDictionary *applicationDetails;
		BOOL cracked = FALSE;
		for (int i = 1; i<argc; i++) {
			NSEnumerator *e = [applist objectEnumerator];
			int cindex = 0;
			while (applicationDetails = [e nextObject]) {
				cindex++;
				if (!numberMenu && ([(NSString *)[applicationDetails objectForKey:compareWith] caseInsensitiveCompare:[NSString stringWithCString:argv[i] encoding:NSASCIIStringEncoding]] == NSOrderedSame)) {
					inCrackRoutine:
					cracked = TRUE;
					printf("got params %s %s %s ",[[applicationDetails objectForKey:@"ApplicationDirectory"] UTF8String],[ [applicationDetails objectForKey:@"ApplicationBasename"]UTF8String], [[applicationDetails objectForKey:@"ApplicationVersion"]UTF8String]);
                    printf("iNalyzer is iNalyzing %s...\n", [[applicationDetails objectForKey:compareWith] UTF8String]);
					ipapath = crack_application([applicationDetails objectForKey:@"ApplicationDirectory"], [applicationDetails objectForKey:@"ApplicationBasename"], [applicationDetails objectForKey:@"ApplicationVersion"]);
					if (ipapath == nil) {
						printf("Failed.\n");
					} else {
						printf("\t%s\n", [ipapath UTF8String]);
					}
					break;
				} else {
					if (numberMenu && (0 == strcmp([[NSString stringWithFormat:@"%d", cindex] UTF8String], argv[i]))) {
						goto inCrackRoutine;
					}
				}
			}
			if (!cracked) {
                if (!strcmp(argv[i], "--overdrive")) {
                    printf("Overdrive is enabled.\n");
                    overdrive_enabled = 1;
                }
                else if (!strcmp(argv[i], "--armv7")) {
                    only_armv7 = 1;
                }
                else if (!strcmp(argv[i], "--script")) {
                    bash = 1;
                    NSLog(@"%@", argv[i]);
                    //bash_script = (NSString*) argv[i + 1];
                    NSLog(@"script %@", bash_script); 
                    if (![[NSFileManager defaultManager] fileExistsAtPath:bash_script]) {
                        printf("error: %s does not exist", [bash_script UTF8String]);
                        goto endMain;
                    }
                }
                else if (!strcmp(argv[i], "--no-compression")) {
                    compression_level = 0;
                }
                else if (!strcmp(argv[i], "--fast-compression")) {
                    compression_level = 1;
                }
                else if (!strcmp(argv[i], "--best-compression")) {
                    compression_level = 9;
                    printf("maximum compression set, might be slow!");
                }
                else if (strncmp(argv[i], "--direct", 7) == 0) {
                    bash=2;
                    NSString *dir = [NSString stringWithCString:argv[i+1] encoding:NSASCIIStringEncoding];
                    NSString *name = [[dir 
                                       stringByReplacingOccurrencesOfString:
                                       [dir stringByDeletingLastPathComponent ]
                                       withString:@""] stringByReplacingOccurrencesOfString:@"/"  withString:@"" ];
                    //name=[name stringByReplacingOccurrencesOfString:@" " withString:@"\ " ];
                    printf("iNalyzer is iNalyzing %s...\n", [ name UTF8String]);
                    // NSString *dir = [NSString stringWithCString:argv[2] encoding:NSASCIIStringEncoding];
                    // NSString *name = [NSString stringWithCString:argv[3] encoding:NSASCIIStringEncoding];
                    NSString *ver = @"1";
                    NSString *ipapath = crack_application(dir,name,ver);
                    if (ipapath == nil) {
                        printf("Failed.\n");
                    } else {
                        printf("\t%s\n", [ipapath UTF8String]);
                    }
                }
                else {
                    /*
                     NSString * basePath = [NSString stringWithFormat:@"%@","/var/mobile/Applications/AA6EAC16-56B4-4D50-AA89-EA8BEB15EAFD/pg2.app/" ];
                    
                    NSString * bundleVersionString = [[[NSDictionary dictionaryWithContentsOfFile:[basePath stringByAppendingFormat:@"/Info.plist" ]] objectForKey:@"CFBundleVersion"] stringByReplacingOccurrencesOfString:@"." withString:@""];
                    
					NSString * applicationRealname = [[[NSDictionary dictionaryWithContentsOfFile:[basePath stringByAppendingFormat:@"/Info.plist" ]] objectForKey:@"CFBundleExecutable"] stringByReplacingOccurrencesOfString:@"." withString:@""];
                    printf("iNalyzer is iNalyzing %s...\n", [applicationRealname UTF8String]);
                    ipapath = crack_application(basePath, applicationRealname, bundleVersionString);
                    if (ipapath == nil) {
                        printf("Failed.\n");
                    } else {
                        printf("\t%s\n", [ipapath UTF8String]);
                        printf("error: Unrecognized application \"%s\"\n", argv[i]);
                    }*/
                    printf("error: Unrecognized application \"%s\"\n", argv[i]);
                }
			}
			cracked = FALSE;
		}
	}
	
endMain:
	return retVal;
    [pool release];
help:
    printf("iNalyzer5Mod help\n");
    printf("---------------------------------\n");
    printf("--          Cracks all applications\n");
    printf("-u          Cracks updated applications\n");
    printf("-f          Clears cache\n");
     printf("--dircet  <app full path >       Analyze this app\n");
    printf("-v          Shows version\n");
    printf("\n");
    printf("--[no|fast|best]-compression       Set the compression level\n");
    printf("--armv7     Only cracks armv7 portion of fat binary\n");
    
    [pool release];
}