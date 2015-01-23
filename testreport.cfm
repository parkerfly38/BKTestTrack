<cfscript>
	writeDump(Application);
	activityreport = new cfc.reports.Activity(0,"Activity Report",StructNew(),StructNew());
	writeDump(activityreport);
	//writeOutput(activityreport.getAuthor());
	testreport = new cfc.Reports(activityreport);
	testreport.saveReport(); 
</cfscript>