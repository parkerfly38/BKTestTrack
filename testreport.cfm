<!---<cfset application.userchatcount.1 = 1>
<cfdump var="#application#">--->

<cfset objAxoSoft = new CFTestTrack.cfc.AxoSoft()>
<!---<cfdump var="#objAxoSoft.getProjects("a51c400e-30eb-4dd7-8c7e-998efb16aa66",249)#">--->
<!---<cfoutput>#objAxoSoft.addDefect("a51c400e-30eb-4dd7-8c7e-998efb16aa66","testdisregard","testdisregard","testdisregard","testdisregard",1103,23)#</cfoutput>--->
<!---<cfdump var="#objAxoSoft.getIncidents("a51c400e-30eb-4dd7-8c7e-998efb16aa66")#">--->
<!---<cfloop array="#datastruct.data#" index="incident">
	<cfscript>
		arrScenario = EntityNew("TTestScenario");
		arrScenario.setTestScenario(incident.name);
		arrScenario.setProjectID(6);
		arrScenario.setSectionId(0);
		arrScenario.setCreatorUserId(1);
		arrScenario.setAxoSoftNumber(incident.number);
		EntitySave(arrScenario);
	</cfscript>
</cfloop>--->
<!---<cfset qryCount = "SELECT count(*) FROM TTestScenario WHERE ProjectID = #Session.ProjectID#">
<cfset results = ORMExecuteQuery(qryCount)[1]>
<cfdump var="#results#">--->
<!---<cfdump var="#objAxoSoft.updateIncident("COG00484","test","a51c400e-30eb-4dd7-8c7e-998efb16aa66")#">--->
<cfdump var="#objAxoSoft.getDefects("a51c400e-30eb-4dd7-8c7e-998efb16aa66")#">