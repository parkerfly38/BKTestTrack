<cfset testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite() />

<cfset testSuite.addAll("AdminTests") />

<cfset testResults = testSuite.run() />

<cfoutput>
	#testResults.getHtmlResults("../mxunit/")#
</cfoutput>