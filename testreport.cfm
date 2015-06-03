<!---<cfset application.userchatcount.1 = 1>
<cfdump var="#application#">--->
<!---
<cfset objAxoSoft = new CFTestTrack.cfc.AxoSoft()>--->
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
<!---<cfdump var="#objAxoSoft.getDefects("a51c400e-30eb-4dd7-8c7e-998efb16aa66")#">--->
<!---<cfhttp method="get" url="https://cornerops.axosoft.com/api/oauth2/token" result="tokenResult">
		<cfhttpparam type="url" name="grant_type" value="authorization_code">
		<cfhttpparam type="url" name="code" value="0095bee0-60f9-479d-bcb7-097ee9230855">
		<cfhttpparam type="url" name="redirect_uri" value="https://localhost/test/">
		<cfhttpparam type="url" name="client_id" value="84a344d7-9034-4ed7-8a01-ba35f9642648">
		<cfhttpparam type="url" name="client_secret" value="yUNiYAek30KibBtietQVo9UktJz8gv8GLdniTvzyv7rzWW4n2Xq0cSmedoJKMB_PUX5aWUyb2y5LXimFX-1wIJeCQocZSF6HTE7Q">
	</cfhttp>
	<cfdump var="#tokenResult#">--->
<cfset stFields =  { "dr" = {
        "startdate" = "2014-01-01", 
     "enddate" = "2015-01-01"
}}>   

<cfhttp url="http://localhost/IATService/IATService.svc/GetData/2014-01-01/2015-01-01" method="POST" result="httpResp" timeout="60"></cfhttp>
<cfdump var="#httpResp#" />