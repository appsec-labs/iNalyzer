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

static NSMutableDictionary *configurationDictionary = nil;
static NSString *configPath = nil;

@implementation iNalyzer5Configuration

+ (id) getValue:(NSString *)key {
	return [configurationDictionary objectForKey:key];
}

+ (BOOL) setValue:(id)value forKey:(NSString *)key {
	[configurationDictionary setValue:value forKey:key];
	[configurationDictionary writeToFile:configPath atomically:YES];
	return YES;
}	

+ (BOOL) configWithFile:(NSString *)filename {
	configurationDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
	configPath = filename;
	return TRUE;
}

@end
