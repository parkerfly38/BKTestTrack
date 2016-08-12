<cfcomponent extends="taffy.core.api">
	
	<cfscript>

		this.name = hash(getCurrentTemplatePath());

		this.mappings["/resources"] = listDeleteAt(cgi.script_name, listLen(cgi.script_name, "/"), "/") & "/resources";
	</cfscript>
	<cfset this.ormEnabled = true />
	<cfset this.datasource = "COGData" />
	<cfset this.ormSettings.datasource = "COGData" />
	<cfset this.ormSettings.eventhandling = true />
	<cfset this.ormSettings.dbCreate = "update" />
	<cfset this.ormSettings.dialect = "MicrosoftSQLServer" />
	<cfset this.ormSettings.useDBForMapping = "false" />
	<!---<cfset this.mappings["/db"] = "#ExpandPath('../cfc/db/')#" />--->
	<cfset this.ormSettings.cfclocation = "../cfc/db" />
	<cfscript>
		variables.framework = {};
		variables.framework.debugKey = "debug";
		variables.framework.reloadKey = "reload";
		variables.framework.reloadPassword = "true";
		variables.framework.serializer = "taffy.core.nativeJsonSerializer";
		variables.framework.returnExceptionsAsJson = true;
		variables.framework.docs.APIName = "CrucibleAPI";
		variables.framework.docs.APIVersion = "1.1.0";

		function onApplicationStart(){
			return super.onApplicationStart();
		}

		function onRequestStart(TARGETPATH){
			return super.onRequestStart(TARGETPATH);
		}

		// this function is called after the request has been parsed and all request details are known
		function onTaffyRequest(verb, cfc, requestArguments, mimeExt){
			// this would be a good place for you to check API key validity and other non-resource-specific validation
			return true;
		}
	</cfscript>
	
</cfcomponent>