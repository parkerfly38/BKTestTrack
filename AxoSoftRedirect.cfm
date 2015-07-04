<cfif StructKeyExists(URL,"code")>
	<cfset Session.AxoSoftCode = URL.code />
	<!--- trade in code for access token --->
	<cfhttp method="get" url="#Application.AxoSoftURL#api/oauth2/token" result="tokenResult">
		<cfhttpparam type="url" name="grant_type" value="authorization_code">
		<cfhttpparam type="url" name="code" value="#Session.AXoSoftCode#">
		<cfhttpparam type="url" name="redirect_uri" value="#Application.AxoSoftRedirectURI#">
		<cfhttpparam type="url" name="client_id" value="#Application.AxoSoftClient_Id#">
		<cfhttpparam type="url" name="client_secret" value="#Application.AxoSoftClient_Secret#">
	</cfhttp>
	<cfset filecontent = DeserializeJSON(tokenResult.filecontent)>
	<cfdump var="#Session#">
	<cfdump var="#filecontent#">
	<cfscript>
		user = EntityLoadByPK("TTestTester",Session.UserIDInt);
		user.setAxoSoftToken(filecontent.access_token);
		EntitySave(user);
		//writeDump(user);
	</cfscript>
</cfif>
<cflocation url="index.cfm" addtoken="false">