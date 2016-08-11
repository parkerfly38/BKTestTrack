<cfcomponent>

	<cfset this.Name = "TheCrucible" />
	<cfset this.sessionManagement = true />
	<cfset this.applicationTimeout = createTimeSpan(1,0,0,0)>
	<cfset this.sessionTimeout = createTimeSpan(0,0,30,0)>
	<cfset this.ormEnabled = true />
	<cfset this.datasource = "COGData" />
	<cfset this.ormSettings.datasource = "COGData" />
	<cfset this.ormSettings.eventhandling = true />
	<cfset this.ormSettings.dbCreate = "update" />
	<cfset this.ormSettings.dialect = "MicrosoftSQLServer" />
	<cfset this.ormSettings.useDBForMapping = "false" />
	<cfset this.directory = getdirectoryfrompath(getcurrenttemplatepath()) >
	<cfset this.mappings["/reportpdfs"] = "#this.directory#reportpdfs/">
	<cfset this.mappings["/excel"] = "#this.directory#excel/">
	<cfset this.mappings["/avatars"] = "#this.directory#images/avatars/">
	<cfset this.mappings["/cfc"] = "#this.directory#cfc/">
	<cfset this.mappings["/db"] = "#this.directory#cfc/db/">
	<cfset this.mappings["/style"] = "#this.directory#style/">
	<cfset this.mappings["/taffy"] = "#this.directory#taffy/">
	<cfset this.ormSettings.cfclocation = "db" />
	<cfset this.wschannels = [{name="general",cfclistener="cfc.Chat"}] >
	<!--- production only 
	<cfsetting showdebugoutput="false" />--->
	
	<cffunction name="onRequestStart" returntype="void" output="true">
		<!--- debug only, remove otherwise --->
		<cfif StructKeyExists(URL, "reload")> 
        	<cfset ApplicationStop() />
			<cfset ORMReload() />
        	<cfset StructClear(Session) /> 
        </cfif>
        <!--- end debug only --->
    	<cfif !FindNoCase(".cfc",CGI.SCRIPT_NAME) &&  StructKeyExists(FORM,"username") && StructKeyExists(FORM,"password")>
    		<cfset objLogon = createObject("component","cfc.Logon") />
    		<cfset objAxoSoft = createObject("component","cfc.AxoSoft") />
    		<cfif Application.useLDAP>
    			<cfif objLogon.ldapAuthenticate(form.username,form.password)>
    				<cfscript>
    					StructInsert(application.SessionTracker,Session.UserIDInt,Now(),false);
    				</cfscript>
    				<cfif Application.AxoSoftIntegration and !StructKeyExists(SESSION,"AxoSoftToken")>
    					<cfscript>objAxoSoft.getAxoSoftToken();</cfscript>
    				<cfelse>
    					<cflocation url="index.cfm" addtoken="false" >
    				</cfif>
    			</cfif>
    		<cfelse>
    			<cfif objLogon.formAuthenticate(form.username,form.password)>
    				<cfscript>
    					if (!StructKeyExists(APPLICATION.SessionTracker,Session.UserIDInt)) {
    						StructInsert(application.SessionTracker,Session.UserIDInt,Now(),false);
    					}
    				</cfscript>
    				<cfif Application.AxoSoftIntegration and !StructKeyExists(SESSION,"AxoSoftToken")>
    					<cfscript>objAxoSoft.getAxoSoftToken();</cfscript>
    				<cfelse>
    					<cflocation url="index.cfm" addtoken="false" >
    				</cfif>
    			</cfif>
    		</cfif>
    	</cfif>
		<cfif (!StructKeyExists(SESSION,"Loggedin") || !Session.Loggedin) && !FindNoCase("logon.cfc",CGI.SCRIPT_NAME) && !FindNoCase("login",CGI.SCRIPT_NAME) && !FindNoCase("testreport.cfm",CGI.SCRIPT_NAME) && !FindNoCase("AxoSoftRedirect.cfm",CGI.SCRIPT_NAME) && !FindNoCase(".cfr",CGI.SCRIPT_NAME) && !FindNoCase("report",CGI.SCRIPT_NAME) && !FindNoCase("skedtasks",CGI.SCRIPT_NAME) && !FindNoCase("chat.cfm", CGI.SCRIPT_NAME)>
			<cfset Session.OrigURL = CGI.SERVER_NAME & "/" & CGI.SCRIPT_NAME & "?" & CGI.QUERY_STRING>
			<cflocation url="/CFTestTrack/login.cfm" addtoken="false" />
		</cfif>
	</cffunction>
	
	<cffunction name="onRequestEnd" returntype="void" output="true">
		<cfscript>

		pageContent = getPageContext().getOut().getString();
		getPageContext().getOut().clearBuffer();
		
		ageContent = reReplace( pageContent, ">[[:space:]]+#chr( 13 )#<", "all" );
		
		writeOutput( pageContent );
		getPageContext().getOut().flush();
		if (!FindNoCase("skedtasks",CGI.SCRIPT_NAME) && !FindNoCase("login",CGI.SCRIPT_NAME) && !FindNoCase("testreport",CGI.Script_NAME) && !FindNoCase("report",CGI.SCRIPT_NAME) && !FindNoCase("axosoftgrab",CGI.ScRIPT_NAME)) {
			StructUpdate(application.SessionTracker,Session.UserIDInt,Now());
		}
		</cfscript>
	</cffunction>
	
	
	<cffunction name="onSessionEnd">
	    <cfargument name = "SessionScope" required=true/>
	    <cfargument name = "AppScope" required=true/>
		<cfset temp = StructDelete(application.SessionTracker, Arguments.SessionScope.UserIDInt) />
	</cffunction>
	
	<cffunction name="onApplicationStart" returntype="void">
		<cfset ORMReload() />
		<cfset Application.SessionTracker = StructNew() />
		<cfset Application.charttype = "html" /><!--- options being flash, jpg, png, html --->
		<cfset qryAuthenticationType = EntityLoad("TTestSettings",{Setting="UseLDAP"},true)>
		<cfset qryAllowCaseDelete = EntityLoad("TTestSettings",{Setting="AllowCaseDelete"},true)>
		<cfset Application.useLDAP = qryAuthenticationType.getSettingValue() />
		<cfset Application.DOMAIN = "" />
		<cfset Application.AllowCaseDelete = qryAllowCaseDelete.getSettingValue() />
		<cfset qryMailerDaemon = EntityLoad("TTestSettings",{Setting="MAILERDAEMONADDRESS"},true)>
		<cfset Application.MAILERDAEMONADDRESS = qryMailerDaemon.getSettingValue() />
		<cfset qryChat = EntityLoad("TTestSettings",{Setting="AllowChat"},true)>
		<cfset Application.EnableChat = qryChat.getSettingValue() />
		<cfset arrUsers = EntityLoad("TTestTester")>
		<cfloop array="#arrUsers#" index="user">
			<cfset Application.UserChatCount[user.getId()] = 0 />
		</cfloop>
		<cfset qryAxoSoftIntegration = EntityLoad("TTestSettings",{Setting="AxoSoftIntegration"},true)>
		<cfset Application.AxoSoftIntegration = qryAxoSoftIntegration.getSettingValue()>
		<cfset qryAxoSoftAuthentication = EntityLoad("TTestSettings",{Setting="AxoSoftAuthentication"},true)>
		<cfset Application.AxoSoftAuthentication = qryAxoSoftAuthentication.getSettingValue()>
		<cfset qryAxoSoftClient_Id = EntityLoad("TTestSettings",{Setting="AxoSoftClient_Id"},true)>
		<cfset Application.AxoSoftClient_Id = qryAxoSoftClient_Id.getSettingValue() >
		<cfset qryAxoSoftClient_Secret = EntityLoad("TTestSettings",{Setting="AxoSoftClient_Secret"},true)>
		<cfset Application.AxoSoftClient_Secret = qryAxoSoftClient_Secret.getSettingValue()>
		<cfset qryAxoSoftRedirectURI = EntityLoad("TTestSettings",{Setting="AxoSoftRedirectURI"},true)>
		<cfset Application.AxoSoftRedirectURI = qryAxoSoftRedirectURI.getSettingValue()>
		<cfset qryAxoSoftExpiration = EntityLoad("TTestSettings",{Setting="AxoSoftRedirectURI"},true)>
		<cfset Application.AxoSoftExpiration = qryAxoSoftExpiration.getSettingValue()>
		<cfset qryAxoSoftURL = EntityLoad("TTestSettings",{Setting="AxoSoftURL"},true)>
		<cfset Application.AxoSoftURL = qryAxoSoftURL.getSettingValue()>
		<cfset qryAxoSoftUseAPI = EntityLoad("TTestSettings",{Setting="AxoSoftUseAPI"},true)>
		<cfset Application.AxoSoftUseAPI = qryAxoSoftUseAPI.getSettingValue()>
		<cfset Application.ChatStruct = StructNew()>
		<cfset Application.ChatStruct.connectionInfo.userName = "CFTestTrack" />
        <cfset Application.SlackIntegration = EntityLoad("TTestSettings", {Setting="SlackIntegration"},true).getSettingValue() />
        <cfset Application.SlackAPIToken = EntityLoad("TTestSettings", {Setting="SlackAPIToken"},true).getSettingValue() />
        <cfset Application.SlackBotChannel = EntityLoad("TTestSettings", {Setting="SlackBotChannel"},true).getSettingValue() />
        <cfset Application.SlackBotURL = EntityLoad("TTestSettings", {Setting="SlackBotURL"},true) />
	</cffunction>
	
	<cffunction name="onMissingTemplate" output="true">
		<cfargument name="template" required="true" type="string">
		#arguments.template#
	</cffunction>

	<cffunction name="onWSAuthenticate">
		<cfargument name="username" type="string" />
		<cfargument name="password" type="string" />
		<cfargument name="connectionInfo" type="Struct" />
		
		<cfset connectionInfo.username=arguments.username />
		<cfreturn true />
	</cffunction>
	
</cfcomponent>