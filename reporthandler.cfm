<cfif StructKeyExists(URL,"id")>
	<cfscript>
		objFunctions = createObject("component","cfc.Functions");
		reportid = url.id;
		arrReport = EntityLoadByPK("TTestReports",reportid);
		structOptions = objFunctions.toCFML(arrReport.getReportOptions());
		structAandS = objFunctions.toCFML(arrReport.getReportAccessAndScheduling());
		
		switch(arrReport.getReportTypeName()) {
			case "Activity Report":
				report = createObject("component","cfc.reports.Activity").init(arrReport.getId(),arrReport.getReportName(),structOptions,structAandS);
				break;
		}
		writeDump(report.getAccessAndScheduling());
		writeDump(report.getReportOptions());
		report.runReport();
	</cfscript>
</cfif>		 