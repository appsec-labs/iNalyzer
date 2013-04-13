/*

libsubjc.cy ... Use libsubjc in cycript.
Copyright (C) 2009  KennyTM~ <kennytm@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

dlopen("libsubjc.dylib", 10);
if (!dlfun) {
	function dlfun(fn, encoding, altname) { var f = new Functor(dlsym(RTLD_DEFAULT, fn), encoding); if (f) this[altname || fn] = f; return f; }
}

dlfun("SubjC_start", "v");
dlfun("SubjC_end", "v");

dlfun("SubjC_set_file", "v^{sFILE=}");
dlfun("SubjC_set_maximum_depth", "vI");
dlfun("SubjC_set_print_arguments", "vB");
dlfun("SubjC_set_print_return_value", "vB");
dlfun("SubjC_set_print_timestamp", "vB");

SubjC_Deny = 0, SubjC_Allow = 1;

dlfun("SubjC_clear_filters", "v");
dlfun("SubjC_filter_method", "vi#:");
dlfun("SubjC_filter_class", "vi#");
dlfun("SubjC_filter_selector", "vi:");
dlfun("SubjC_default_filter_type", "vi");
dlfun("SubjC_filter_class_prefixes", "viI^*");
dlfun("SubjC_filter_class_prefix", "vi*");

dlfun("fopen", "^{sFILE=}**");
dlfun("fclose", "i^{sFILE=}");

