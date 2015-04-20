<cfset objAxoSoft = new CFTestTrack.cfc.AxoSoft()> 
<cfset datastruct = objAxoSoft.getIncidents("a51c400e-30eb-4dd7-8c7e-998efb16aa66") />
<cfloop array="#datastruct.data#" index="incident">
	<cfquery name="qryIndTest">
		SELECT id FROM TTestScenario WHERE AxoSoftNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#incident.number#" />
	</cfquery>
	<cfif qryIndTest.RecordCount lt 1>
	<cfscript>
		arrScenario = EntityNew("TTestScenario");
		arrScenario.setTestScenario(incident.name);
		arrScenario.setProjectID(6);
		arrScenario.setSectionId(0);
		arrScenario.setCreatorUserId(1);
		arrScenario.setAxoSoftNumber(incident.number);
		EntitySave(arrScenario);
	</cfscript>
	</cfif>
</cfloop>

<cfset defectstruct = objAxoSoft.getDefects("a51c400e-30eb-4dd7-8c7e-998efb16aa66") />
<cfloop array="#defectstruct.data#" index="defect">
	<cfquery name="qryDefTest">
		SELECT id FROM TTestScenario WHERE AxoSoftNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#defect.number#" />
	</cfquery>
	<cfif qryDefTest.RecordCount lt 1>
	<cfscript>
		arrScenario = EntityNew("TTestScenario");
		arrScenario.setTestScenario(defect.name);
		arrScenario.setProjectID(8);
		arrScenario.setSectionId(0);
		arrScenario.setCreatorUserId(1);
		arrScenario.setAxoSoftNumber(defect.number);
		EntitySave(arrScenario);
	</cfscript>
	</cfif>
</cfloop>