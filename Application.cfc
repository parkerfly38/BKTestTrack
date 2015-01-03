<cfcomponent>

	<cfset this.Name = "COGTestTracker" />
	<cfset this.sessionManagement = true />
	<cfset this.ormEnabled = true />
	<cfset this.datasource = "COGData" />
	<cfset this.ormSettings.cflocation = "CFC.db" />
	<cfset this.ormSettings.datasource = "COGData" />
	
	
	<cffunction name="onRequestStart" returntype="void" output="true">
		<!--- debug only, remove otherwise --->
		<cfif StructKeyExists(URL, "reload")> 
        	<cfset ApplicationStop() />
        	<cfset StructClear(Session) /> 
        </cfif>
        <!--- end debug only --->
    	<cfif !FindNoCase(".cfc",CGI.SCRIPT_NAME) &&  StructKeyExists(FORM,"username") && StructKeyExists(FORM,"password")>
    		<cfset objLogon = createObject("component","cfc.Logon") />
    		<cfif objLogon.ldapAuthenticate(form.username,form.password)>
    			<cflocation url="index.cfm">
    		</cfif>
    	</cfif>
		<cfif (!StructKeyExists(SESSION,"Loggedin") || !Session.Loggedin) && !FindNoCase(".cfc",CGI.SCRIPT_NAME) && !FindNoCase("login",CGI.SCRIPT_NAME)>
			<cflocation url="login.cfm" addtoken="false" />
		</cfif>
		
	</cffunction>
	
	<cffunction name="onApplicationStart" returntype="void">
		<cfset ORMReload() />
		<cfset Application.charttype = "html" /><!--- options being flash, jpg, png, html --->
	</cffunction>

</cfcomponent>