<cfcomponent>
	
	<cffunction access="remote" name="returnTasks" returntype="query">
    	<cfswitch expression="#getVersion()#">
	    	<cfcase value="8,9">
		    	<cfset local = structnew()>
		    	<cfset objCF9 = createObject("component","cf9below")>
		    	<cfset qryScheduledTasks = objCF9.getScheduleQuery()>
		    </cfcase>
		    <cfcase value="10,11">
		   		<cfset objCF10 = createObject("component","cf10plus")>
		   		<cfset qryScheduledTasks = objCF10.getScheduleQuery()>
		    </cfcase>
		</cfswitch>
	    <cfquery dbtype="query" name="qrytasks">
	    	SELECT * FROM qryScheduledTasks
	    	WHERE task like 'TestTrack%'
	    </cfquery>
	    <cfreturn qrytasks />
	</cffunction>
	
	<cffunction access="remote" name="getVersion" returntype="string">
		<cfreturn ListGetAt(SERVER.ColdFusion.ProductVersion,1) />
	</cffunction>
	
	<cffunction access="remote" name="createTask" returntype="query">
		<cfargument name="reportid" required="true">
		<cfargument name="interval" required="true">
		<cfargument name="startDate" required="true">
		<cfargument name="startTime" required="true">
		
		<cfschedule action="update" task="TestTrack#arguments.reportid#" operation="HTTPRequest" url="reporthandler.cfm?id=#arguments.reportid#" startDate="#arguments.startDate#" startTime="#arguments.startTime#" interval="#arguments.interval#" resolveURL="no" publish="false" path="#GetDirectoryFromPath(ExpandPath("*.*"))#" requesttimeout="3500" />
					
		<cfreturn returnTasks() />
	</cffunction>

	<cffunction access="remote" name="deleteTask" returntype="void">
		<cfargument name="testid" type="numeric" required="true">
		<cfschedule action="delete" task="TestTrack#arguments.testid#">
	</cffunction>

</cfcomponent>