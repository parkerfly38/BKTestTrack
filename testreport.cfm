<!---<cfscript>
	//writeDump(Application);
	activityreport = new cfc.reports.Activity(0,"Weekly Activity Report",StructNew(),StructNew());
	//writeDump(activityreport);
	blarg = activityreport.getAccessAndScheduling();
	//writeDump(blarg);
	blarg2 = activityreport.getReportOptions();
	blarg.createreport = "Weekly";
	blarg2.TimeFrame = "Week";
	//writeDump(blarg);
	//writeOutput(activityreport.getAuthor());
	testreport = new cfc.Reports(activityreport);
	//writeOutput(testreport.getFormFields());
	testreport.saveReport();
	//testreport.runReport();
	//objMaintenance = createObject("component","cfc.Maintenance");
	//writeDump(objMaintenance.returnTasks());
	//writeOutput(testreport.saveReport()); 
</cfscript>--->
<!---<cfset jsonvar = '{"ReportOptions":[{"GroupingAndChanges":[{"IncludeChanges":""}]},{"TimeFrame":"Today"},{"TestScenarios":""}]}'>
<CFDUMP VAR="#deserializejson(jsonvar)#">
<cfset jsonvar2 = '{"AccessAndScheduling":[{},{"CreateReport":"once"},{"Email":[{},{"SendLinkToUserIds":""},{"SendAsAttachmentTo":""}]},{"StartDate":"2015-01-29"},{"StartTime":"0:00"}]}'>
<cfdump var="#deserializejson(jsonvar2)#">--->
<cfschedule action='list' result='qryScheduledTasks' mode="server" />
	    	<cfdump var="#qryScheduledTasks#">