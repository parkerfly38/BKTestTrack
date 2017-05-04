<cfcomponent extends="taffy.core.api">
	
	<cfscript>
		OrmReload();
		this.sessionManagement = true;
		this.name = hash(getCurrentTemplatePath());

		this.mappings["/resources"] = listDeleteAt(cgi.script_name, listLen(cgi.script_name, "/"), "/") & "/resources";
	</cfscript>
	<cfset this.ormEnabled = true />
	<cfset this.datasource = "voterdb" />
	<cfset this.ormSettings.datasource = "voterdb" />
	<cfset this.ormSettings.eventhandling = true />
	<cfset this.ormSettings.dbCreate = "update" />
	<cfset this.ormSettings.dialect = "MicrosoftSQLServer" />
	<cfset this.ormSettings.useDBForMapping = "false" />
	<!---<cfset this.mappings["/db"] = "#ExpandPath('../cfc/db/')#" />--->
	<cfset this.ormSettings.cfclocation = "#ExpandPath('../cfc/db')#" />
	<cfscript>
		variables.framework = {};
		variables.framework.debugKey = "debug";
		variables.framework.reloadKey = "reload";
		variables.framework.reloadPassword = "true";
		variables.framework.serializer = "taffy.core.nativeJsonSerializer";
		variables.framework.returnExceptionsAsJson = true;
		variables.framework.docs.APIName = "CrucibleAPI";
		variables.framework.docs.APIVersion = "1.1.0";
		variables.framework.dashboardHeaders = {};

		function onApplicationStart(){
			return super.onApplicationStart();
		}

		function onRequestStart(TARGETPATH){
			return super.onRequestStart(TARGETPATH);
		}

		// this function is called after the request has been parsed and all request details are known
		function onTaffyRequest(verb, cfc, requestArguments, mimeExt, headers){
			//return representationOf(arguments.cfc);
			if (arguments.cfc eq "token"){
				return true;
			} else {
				// this would be a good place for you to check API key validity and other non-resource-specific validation
				authenticationObj = new authentication();
				evaluateReq =  authenticationObj.authenticateRequest(arguments.verb, arguments.cfc, arguments.requestArguments, arguments.headers);
				if (evaluateReq eq "true")
				{
					return true;
				} else {
					return newRepresentation().noData().withStatus(403,evaluateReq);
				}
			}
		}
	</cfscript>
	
</cfcomponent>