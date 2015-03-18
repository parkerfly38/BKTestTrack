<cfcomponent>

	<cfset this.Name = "CFTestTrack" />
	<cfset this.sessionManagement = true />
	<cfset this.ormEnabled = true />
	<cfset this.datasource = "COGData" />
	<cfset this.ormSettings.cflocation = "CFC.db" />
	<cfset this.ormSettings.datasource = "COGData" />
	<cfset this.ormSettings.eventhandling = true />
	<cfset this.directory = getdirectoryfrompath(getcurrenttemplatepath()) >
	<cfset this.mappings["/reportpdfs"] = "#this.directory#reportpdfs/">
	<cfset this.mappings["/excel"] = "#this.directory#excel/">
	<cfset this.mappings["/avatars"] = "#this.directory#images/avatars/">
	
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
    				<cfscript>
    					StructInsert(application.SessionTracker,Session.UserIDInt,Now(),false);
    				</cfscript> 
    				<cflocation url="index.cfm" addtoken="false" >
    			</cfif>
    		<cfelse>
    			<cfif objLogon.formAuthenticate(form.username,form.password)>
    				<cfscript>
    					StructInsert(application.SessionTracker,Session.UserIDInt,Now(),false);
    				</cfscript> 
    				<cflocation url="index.cfm" addtoken="false" >
    			</cfif>
    		</cfif>
    	</cfif>
		<cfif (!StructKeyExists(SESSION,"Loggedin") || !Session.Loggedin) && !FindNoCase("logon.cfc",CGI.SCRIPT_NAME) && !FindNoCase("login",CGI.SCRIPT_NAME) && !FindNoCase("testreport.cfm",CGI.SCRIPT_NAME)>
			<cfset Session.OrigURL = CGI.SERVER_NAME & "/" & CGI.SCRIPT_NAME & "?" & CGI.QUERY_STRING>
			<cflocation url="login.cfm" addtoken="false" />
		</cfif>
	</cffunction>
	
	<cffunction name="onRequestEnd" returntype="void" output="true">
		<cfscript>

		pageContent = getPageContext().getOut().getString();
		getPageContext().getOut().clearBuffer();
		
		ageContent = reReplace( pageContent, ">[[:space:]]+#chr( 13 )#<", "all" );
		
		writeOutput( pageContent );
		getPageContext().getOut().flush();
		if (!FindNoCase("login",CGI.SCRIPT_NAME)) {
			StructUpdate(application.SessionTracker,Session.UserIDInt,Now());
		}
		</cfscript>
	</cffunction>
	
	
	<cffunction name="onSessionEnd">
	    <cfargument name = "SessionScope" required=true/>
	    <cfargument name = "AppScope" required=true/>
	    <!---<cfset var sessionLength = TimeFormat(Now() - SessionScope.started,
	        "H:mm:ss")>
	    <cflock name="AppLock" timeout="5" type="Exclusive">
	        <cfset Arguments.AppScope.sessions = Arguments.AppScope.sessions - 1>
	    </cflock>--->
		<cfset temp = StructDelete(application.SessionTracker, Arguments.SessionScope.UserIDInt) />
	</cffunction>
	
	<cffunction name="onApplicationStart" returntype="void">
		<cfset ORMReload() />
		<cfset Application.SessionTracker = StructNew() />
		<cfset Application.charttype = "html" /><!--- options being flash, jpg, png, html --->
		<cfset qryAuthenticationType = EntityLoad("TTestSettings",{Setting="UseLDAP"},true)>
		<cfset qryAllowCaseDelete = EntityLoad("TTestSettings",{Setting="AllowCaseDelete"},true)>
		<cfset Application.useLDAP = qryAuthenticationType.getSettingValue() /><!--- set this to true if you want to use LDAP --->
		<cfset Application.DOMAIN = "CORNEROPS" /><!--- set your domain name here, further adjustments may be necessary in Logon.cfc --->
		<cfset Application.AllowCaseDelete = qryAllowCaseDelete.getSettingValue() />
		<cfset qryMailerDaemon = EntityLoad("TTestSettings",{Setting="MAILERDAEMONADDRESS"},true)>
		<cfset Application.MAILERDAEMONADDRESS = qryMailerDaemon.getSettingValue() />
		<cfset qryChat = EntityLoad("TTestSettings",{Setting="AllowChat"},true)>
		<cfset Application.EnableChat = qryChat.getSettingValue() />
		<!--- by user chat count --->
		<cfset arrUsers = EntityLoad("TTestTester")>
		<cfloop array="#arrUsers#" index="user">
			<cfset Application.UserChatCount[user.getId()] = 0 />
		</cfloop>
	</cffunction>

</cfcomponent>