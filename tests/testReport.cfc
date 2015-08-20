<cfcomponent displayname="LdapTests" extends="mxunit.framework.TestCase">
	
	
	<cffunction name="testGetAllProjects" access="public" returntype="void">
		<cfscript>
		objData = new CFTestTrack.cfc.reports.AllOpenItems();report.getReportOptions();
			objData.getAccessAndScheduling();
			newreport = new Reports(objData);
			outputbody = newreport.getFormFields();
		</cfscript>
	</cffunction>
		
</cfcomponent>