function ls(a){ var x={}; for(i in *a){ try{ x[i] = (*a)[i]; } catch(e){} } return x; }

function ftxt(a){
return [UIApp.keyWindow recursiveDescription].toString().split(a)[0].split("|").pop().split(";")[0].split(": ")[1]; }

function lsl(a) { var x = []; for (i in *a) { x.push(i); } return x;}

function met(a) { var count = new new Type("I"); var methods = class_copyMethodList(objc_getClass(a->isa), count); var methodsArray = []; for(var i = 0; i < *count; i++) {
var method = methods[i]; methodsArray.push({selector:method_getName(method),
implementation:method_getImplementation(method)});
} free(methods); free(count); return methodsArray; }

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


f=fopen("/tmp/list","w")
SubjC_set_file(f);
SubjC_clear_filters();
SubjC_set_maximum_depth(35);
SubjC_set_print_arguments(YES);
SubjC_set_print_return_value(NO);
SubjC_set_print_timestamp(YES);
//SubjC_default_filter_type(SubjC_Allow);
SubjC_filter_class(SubjC_Allow,UIApplication);
//SubjC_filter_class(SubjC_Deny,UIWindow);
//SubjC_filter_class(SubjC_Deny,UIButton);
//SubjC_filter_class(SubjC_Deny,UITouch);
//SubjC_filter_class(SubjC_Deny,UIView);
//SubjC_filter_class(SubjC_Deny,NSCondition);
