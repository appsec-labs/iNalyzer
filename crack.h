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

#import "Configuration.h"
#import "dump.h"
#import "scinfo.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <sys/stat.h>
#import <utime.h>
#import "out.h"
#import "ZipArchive.h"

int overdrive_enabled;
int only_armv7;
int only_armv6;
int bash;
int compression_level;
NSString *bash_script;

#define FAT_CIGAM 0xbebafeca
#define MH_MAGIC 0xfeedface

#define iNalyzer5_VERSION "iNalyzer5 0.1 (iNalyzer5 1.2.4)"

#define ARMV6 6
#define ARMV7 9

NSString * crack_application(NSString *application_basedir, NSString *basename, NSString *version);
NSString * init_crack_binary(NSString *application_basedir, NSString *bdir, NSString *workingDir, NSDictionary *infoplist);
NSString * crack_binary(NSString *binaryPath, NSString *finalPath, NSString **error);
NSString * genRandStringLength(int len);
ZipArchive * createZip(NSString *file);
void zip(ZipArchive *zip, NSString *folder);
int get_local_arch();

struct fat_arch {
	uint32_t cputype;
	uint32_t cpusubtype;
	uint32_t offset;
	uint32_t size;
	uint32_t align;
};
NSString * runCmdString(NSString *interp, NSString *cmd);