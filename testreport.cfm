<cfscript>
	//writeDump(Application);
	activityreport = new cfc.reports.Activity(0,"Activity Report",StructNew(),StructNew());
	//writeDump(activityreport);
	blarg = activityreport.getAccessAndScheduling();
	//writeDump(blarg);
	writeDump(activityreport.getReportOptions());
	blarg.createreport = "weekly";
	//writeDump(blarg);
	//writeOutput(activityreport.getAuthor());
	testreport = new cfc.Reports(activityreport);
	testreport.saveReport();
	testreport.runReport();
	//objMaintenance = createObject("component","cfc.Maintenance");
	//writeDump(objMaintenance.returnTasks());
	//writeOutput(testreport.saveReport()); 
</cfscript>