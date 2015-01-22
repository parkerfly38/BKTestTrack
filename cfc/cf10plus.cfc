<cfcomponent hint="For functions that are only going to work in CF10 plus">

	<cffunction name="qryTasks" returntype="Query" access="public">
	    	<cfschedule action='list' result='qryScheduledTasks' mode="server" />
	    	<cfreturn qryScheduledTasks>
	</cffunction>

</cfcomponent>