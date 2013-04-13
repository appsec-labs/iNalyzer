#import <Foundation/Foundation.h>



@interface CrackApp : NSObject {
    int overdrive_enabled;
    NSString *ipapath;
    NSDictionary *applicationDetails;
    BOOL cracked;
    
    NSString *application_basedir;
    NSString *workingDir;
    
}
/*
 TODO: Move cracking to a class
 
- (NSString*) crack_application;
- (NSString*) init_crack_binary;
 */
@end