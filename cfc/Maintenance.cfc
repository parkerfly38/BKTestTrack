<cfcomponent>
	
	<cffunction access="remote" name="returnTasks" returntype="query">
    	<cfswitch expression="#getRemoteVersion()#">
    	<cfcase value="8,9">
	    	<cfset local = structnew()>
	    	<cfset objCF9 = createObject("component","cf9below")>
	    	<cfset qryScheduledTasks = objCF9.qryTasks()>
	    </cfcase>
	    <cfcase value="10,11">
	   		<cfset objCF10 = createObject("component","cf10plus")>
	   		<cfset qryScheduledTasks = objCF10.qryTasks()>
	    </cfcase>
	</cfswitch>
    <cfquery dbtype="query" name="qrytasks">
    	SELECT * FROM qryScheduledTasks
    	WHERE task like 'Email%'
    </cfquery>
    <cfreturn qrytasks />
</cffunction>

<cffunction access="remote" name="getVersion" returntype="string">
	<cfreturn ListGetAt(SERVER.ColdFusion.ProductVersion,1) />
</cffunction>


</cfcomponent>