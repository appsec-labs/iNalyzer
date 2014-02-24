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

#import <sys/ioctl.h>
#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#import "Configuration.h"

// print something verbose
#define VERBOSE(x) if ([[iNalyzer5Configuration getValue:@"VerboseLogging"] isEqualToString:@"YES"]) { progress_event(x); };
// output some data
#define NOTIFY(x) progress_message(x);
// update percentage of currently running task
#define PERCENT(x) progress_percent(x);

int determine_screen_width (void);
void progress_percent(int percent);
void progress_message(char *msg);
void progress_event(char *text);

void print_bar(void);
void stop_bar(void);
void pause_bar(void);