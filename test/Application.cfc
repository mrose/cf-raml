component hint="included so that running the mxunit html test runner does not use an Application.cfc|cfm higher up the directory tree" {

	this['name'] = "cf-raml.test";
	this['sessionManagement'] = FALSE;
	this['clientManagement'] = FALSE;
	this['applicationTimeout'] = createTimeSpan(0,1,0,0);
	this['sessionTimeout'] = createTimeSpan(0,0,20,0);
	this['setClientCookies'] = FALSE;
	this['scriptProtect'] = FALSE;

}