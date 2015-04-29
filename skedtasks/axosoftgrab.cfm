<cfset objAxoSoft = new CFTestTrack.cfc.AxoSoft()> 
<cfset datastruct = objAxoSoft.getIncidents("58dfb0e4-c727-4008-a03c-fe352bc747ce") />
<cfdump var="#datastruct#">
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

<cfset defectstruct = objAxoSoft.getDefects("58dfb0e4-c727-4008-a03c-fe352bc747ce") />
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