
f=fopen("/tmp/list","w")
SubjC_set_file(f);
SubjC_clear_filters();
SubjC_set_maximum_depth(135);
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
SubjC_start()
//SubjC_end()
