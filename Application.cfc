<cfcomponent>

	<cfset this.Name = "COGTestTrack" />
	<cfset this.sessionManagement = true />
	<cfset this.ormEnabled = true />
	<cfset this.datasource = "COGData" />
	<cfset this.ormSettings.cflocation = "CFC.db" />
	<cfset this.ormSettings.datasource = "COGData" />
	<cfset this.ormSettings.eventhandling = true />
	<cfset this.directory = getdirectoryfrompath(getcurrenttemplatepath()) >
	<cfset this.mappings["/reportpdfs"] = "#this.directory#reportpdfs/">
	<cfset this.mappings["/excel"] = "#this.directory#excel/">
	
	<cffunction name="onRequestStart" returntype="void" output="true">
		<!--- debug only, remove otherwise --->
		<cfif StructKeyExists(URL, "reload")> 
        	<cfset ApplicationStop() />
        	<cfset StructClear(Session) /> 
        </cfif>
        <!--- end debug only --->
    	<cfif !FindNoCase(".cfc",CGI.SCRIPT_NAME) &&  StructKeyExists(FORM,"username") && StructKeyExists(FORM,"password")>
    		<cfset objLogon = createObject("component","cfc.Logon") />
    		<cfif Application.useLDAP>
    			<cfif objLogon.ldapAuthenticate(form.username,form.password)>
    				<cflocation url="index.cfm" addtoken="false" >
    			</cfif>
    		<cfelse>
    			<cfif objLogon.formAuthenticate(form.username,form.password)>
    				<cflocation url="index.cfm" addtoken="false" >
    			</cfif>
    		</cfif>
    	</cfif>
		<cfif (!StructKeyExists(SESSION,"Loggedin") || !Session.Loggedin) && !FindNoCase("logon.cfc",CGI.SCRIPT_NAME) && !FindNoCase("login",CGI.SCRIPT_NAME) && !FindNoCase("testreport.cfm",CGI.SCRIPT_NAME)>
			<cflocation url="login.cfm" addtoken="false" />
		</cfif>
		
	</cffunction>
	
	<cffunction name="onApplicationStart" returntype="void">
		<cfset ORMReload() />
		<cfset Application.charttype = "html" /><!--- options being flash, jpg, png, html --->
		<cfset qryAuthenticationType = EntityLoad("TTestSettings",{Setting="UseLDAP"},true)>
		<cfset qryAllowCaseDelete = EntityLoad("TTestSettings",{Setting="AllowCaseDelete"},true)>
		<cfset Application.useLDAP = qryAuthenticationType.getSettingValue() /><!--- set this to true if you want to use LDAP --->
		<cfset Application.DOMAIN = "CORNEROPS" /><!--- set your domain name here, further adjustments may be necessary in Logon.cfc --->
		<cfset Application.AllowCaseDelete = qryAllowCaseDelete.getSettingValue() />
	</cffunction>

</cfcomponent>