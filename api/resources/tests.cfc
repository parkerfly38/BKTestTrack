<cfcomponent extends="taffy.core.resource" taffy:uri="/testcases">
	
	<cffunction name="get">
		<cfset var local = {} />
		<cfset objData = createObject("component","/CFTestTrack/cfc/Data") />
		<cfset local.Tests = objData.getAllTestCases() />
		<cfreturn representationOf(local.Tests) />
	</cffunction>

</cfcomponent>