<cfcomponent>
	
	<cfset api_token = Application.SlackAPIToken>
	<cfset bot_channel = Application.SlackBotChannel >
	<!---<cfset slackbot_url = Application.SlackBotURL >--->
	
	<cffunction name="slackTestAuthentication" access="public" returntype="Any">
		<cfhttp method="post" url="https://slack.com/api/auth.test" result="httpResult">
			<cfhttpparam type="formfield" name="token" value="#api_token#" />
		</cfhttp>
		<cfreturn deserializeJSON(httpResult.fileContent) />
	</cffunction>
	
	<cffunction name="slackTestAPI" access="public" returntype="any">
		<cfhttp method="post" url="https://slack.com/api/api.test" result="httpResult">
			<cfhttpparam type="body" value="" />
		</cfhttp>
		<cfreturn deserializeJSON(httpResult.filecontent) />
	</cffunction>
	
	<cffunction name="slackRTMStart" access="public" returntype="any">
		<cfhttp method="post" url="https://slack.com/api/rtm.start" result="httpResult">
			<cfhttpparam type="formfield" name="token" value="#api_token#">
		</cfhttp>
		<cfreturn deserializeJson(httpResult.fileContent) />
	</cffunction>
	
	<cffunction name="slackChannels" access="public" returntype="any">
		<cfhttp method="post" url="https://slack.com/api/channels.list" result="httpResult">
			<cfhttpparam type="formfield" name="token" value="#api_token#" />
			<cfhttpparam type="formfield" name="exclude_archived" value="1" />
		</cfhttp>
		<cfreturn deserializeJSON(httpResult.fileContent) />
	</cffunction>
	
	<cffunction name="slackPostMessage" access="public" returntype="any">
		<cfargument name="channel" default="#bot_channel#">
		<cfargument name="text" required="true">
		<cfargument name="as_user" required="false" default="false">
		<cfhttp method="post" url="https://slack.com/api/chat.postMessage" result="httpResult">
			<cfhttpparam type="formfield" name="token" value="#api_token#" />
			<cfhttpparam type="formfield" name="channel" value="#bot_channel#" />
			<cfhttpparam type="formfield" name="text" value="#arguments.text#" />
			<cfhttpparam type="formfield" name="as_user" value="#arguments.as_user#" />
		</cfhttp>
		<cfreturn deserializeJSON(httpResult.fileContent) />
	</cffunction>
				
</cfcomponent>