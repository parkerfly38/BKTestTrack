<cfcomponent>

	<cffunction name="getAxoSoftToken" access="public">
		<cfif Application.AxoSoftAuthentication eq "Authorization">
			<cflocation url="#Application.AxoSoftURL#auth?response_type=code&client_id=#Application.AxoSoftClient_Id#&redirect_uri=#Application.AxoSoftRedirectURI#&scope=read%20write" addtoken="false">
		</cfif>
	</cffunction>
	
	<cffunction name="getProjects" access="public">
		<cfargument name="access_token" required="true">
		<cfhttp url="#Application.AxoSoftURL#api/v2/projects/?access_token=#arguments.access_token#" method="get" result="httpResult" />
		<cfreturn DeserializeJSON(httpResult.fileContent) />
	</cffunction>
	
	<cffunction name="getWorkflows" access="public">
		<cfargument name="access_token" required="true">
		<cfhttp url="#Application.AxoSoftURL#api/v2/workflows/?access_token=#arguments.access_token#" method="get" result="httpResult" />
		<cfreturn DeserializeJSON(httpResult.fileContent) />
	</cffunction>
	
	<cffunction name="getCustomers" access="public">
		<cfargument name="access_token" required="true">
		<cfhttp url="#Application.AxoSoftURL#api/v2/customers/?access_token=#arguments.access_token#" method="get" result="httpResult" />
		<cfreturn DeserializeJSON(httpResult.fileContent) />
	</cffunction>

	<cffunction name="getContacts" access="public">
		<cfargument name="access_token" required="true">
		<cfhttp url="#Application.AxoSoftURL#api/v2/contacts/?access_token=#arguments.access_token#" method="get" result="httpResult" />
		<cfreturn DeserializeJSON(httpResult.fileContent) />
	</cffunction>
	
	<cffunction name="getDefects" access="public">
		<cfargument name="access_token" required="true">
		<cfhttp url="#Application.AxoSoftURL#api/v2/defects/?access_token=#arguments.access_token#" method="get" result="httpResult" />
		<cfreturn DeserializeJSON(httpResult.fileContent) />
	</cffunction>
	
	<cffunction name="getDefect" access="public">
		<cfargument name="access_token" required="true">
		<cfargument name="defectid" required="true">
		<cfhttp url="#Application.AxoSoftURL#api/v2/defects/#arguments.defectid#?access_token=#arguments.access_token#" method="get" result="httpResult" />
		<cfreturn DeserializeJSON(httpResult.fileContent) />
	</cffunction>
	
	<cffunction name="getUsers" access="public">
		<cfargument name="access_token" required="true">
		<cfhttp url="#Application.AxoSoftURL#api/v2/users/?access_token=#arguments.access_token#" method="get" result="httpResult" />
		<cfreturn DeserializeJSON(httpResult.fileContent) />
	</cffunction>
	
	<cffunction name="addEmail" access="public" output="true">
		<cfargument name="access_token">
		<cfset objemail = {data = { "subject" = "Test", "body" = "test", "from" = "brian.kresge@cornerstoneoperations.com", to="brian.kresge@cornerstoneoperations.com", "email_type" = "text", "item" = { "id" =  249, "type" = "defects" }}}>
		<cfhttp method="POST" url="#Application.AxoSoftURL#api/v2/emails" result="httpResult">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
			<cfhttpparam type="header" name="Accept" value="application/json" />
			<cfhttpparam type="header" name="X-Authorization" value="Bearer #arguments.access_token#" />
			<cfhttpparam type="body" value="#serializeJSON(objemail)#" />
			
		</cfhttp>
		<cfdump var="#serializeJSON(objemail)#">
		<cfdump var="#httpResult#">
	</cffunction>
	
	<cffunction name="defectNotification" access="public" output="true">
		<cfargument name="access_token">
		<cfset objnot = { "user_ids" = "[1103]" }>
		<cfhttp method="POST" url="#Application.AxoSoftURL#api/v2/defects/249/notifications" result="httpResult">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
			<cfhttpparam type="header" name="Accept" value="application/json" />
			<cfhttpparam type="header" name="X-Authorization" value="Bearer #arguments.access_token#" />
			<cfhttpparam type="body" name="data" value="#serializeJSON(objnot)#" />
		</cfhttp>
		<cfdump var="#serializeJSON(objnot)#">
		<cfdump var="#httpResult#">
	</cffunction>
	
	<cffunction name="addDefect" access="public" output="true">
		<cfargument name="access_token">
		<cfargument name="defectname">
		<cfargument name="defectdescription">
		<cfargument name="defectnotes">
		<cfargument name="replication_procedures">
		<cfargument name="reported_by">
		<cfargument name="project">
		<cfset item = { "notify_customer" = false, "item" = { "name" = arguments.defectname, "description" = arguments.defectdescription, "notes" = arguments.defectnotes, "resolution" = "", "replication_procedures" = arguments.replication_procedures, "percent_complete" = 0, "archived" = false, "publicly_viewable" = true, "iscompleted" = false, "completion_date" = "", "due_date" = "", "reported_date" = Now(), "start_date" = "", "assigned_to" = { "id" = arguments.reported_by, "type" = "user" }, "priority" = { "id" = "0" }, "project" = { "id" = arguments.project }, "parent" = { "id" = 0 }, "release" = { "id" = 0 },  "reported_by" = { "id" = arguments.reported_by }, "reported_by_customer_contact" = "", "severity" = { "id" = 1}, "status" = { "id" = 0}, "workflow_step" = { "id" = 0 }, "actual_duration" = { "duration" = 0, "time_unit" = { "id" = 0 }}, "estimated_duration"= { "duration" = 0, "time_unit" = { "id" = 0 }}, "remaining_duration" = { "duration" = 0, "time_unit" = { "id" = 0 }}  } } >
		<cfhttp method="PUT" url="#Application.AxoSoftURL#api/v1/defects" result="httpResult">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
			<cfhttpparam type="header" name="Accept" value="application/json" />
			<cfhttpparam type="header" name="X-Authorization" value="Bearer #arguments.access_token#" />
			<cfhttpparam type="body" value="#serializeJSON(item)#" />
			
		</cfhttp>
		<cfdump var="#item#">
		<cfdump var="#httpResult#">
	</cffunction>
		

</cfcomponent>