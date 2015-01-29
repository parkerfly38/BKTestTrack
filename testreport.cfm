<cfscript>
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
	writeOutput(testreport.getFormFields());
	//testreport.saveReport();
	testreport.runReport();
	//objMaintenance = createObject("component","cfc.Maintenance");
	//writeDump(objMaintenance.returnTasks());
	//writeOutput(testreport.saveReport()); 
</cfscript>