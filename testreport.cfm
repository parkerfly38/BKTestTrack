<!---<!DOCTYPE html>
	<html lang="en">
		<head>
			<link rel="stylesheet" type="text/css" media="screen" href="style/bootstrap-select.min.css" />
			<script type="text/javascript" src="scripts/jquery-1.10.2.min.js"></script>
			<script type="text/javascript" src="scripts/ChartNew.js"></script>
			<script type="text/javascript" src="scripts/bootstrap-select.min.js"></script>
		</head>
		<body>
			<div class="container-fluid" style="background:none;">--->
<cfscript>
	//writeDump(Application);
	Session.UserIDInt = 1;
	activityreport = new cfc.reports.ExecutionList(0,"Weekly Execution List Report",StructNew(),StructNew());
	//writeDump(activityreport);
	blarg = activityreport.getAccessAndScheduling();
	blarg.Email.NotifyMe = 0;
	//writeDump(blarg);
	blarg2 = activityreport.getReportOptions();
	blarg.createreport = "Weekly";
	blarg2.TimeFrame = "Week";
	blarg2.TestScenarios = 1;
	//writeDump(blarg);
	//writeOutput(activityreport.getAuthor());
	testreport = new cfc.Reports(activityreport);
	//writeOutput(testreport.getFormFields());
	//testreport.saveReport();
	testreport.runReport();
	//objMaintenance = createObject("component","cfc.Maintenance");
	//writeDump(objMaintenance.returnTasks());
	//writeOutput(testreport.saveReport()); 
</cfscript>
<!--->--->
<!---<cfset jsonvar = '{"ReportOptions":[{"GroupingAndChanges":[{"IncludeChanges":""}]},{"TimeFrame":"Today"},{"TestScenarios":""}]}'>
<CFDUMP VAR="#deserializejson(jsonvar)#">
<cfset jsonvar2 = '{"AccessAndScheduling":[{},{"CreateReport":"once"},{"Email":[{},{"SendLinkToUserIds":""},{"SendAsAttachmentTo":""}]},{"StartDate":"2015-01-29"},{"StartTime":"0:00"}]}'>
<cfdump var="#deserializejson(jsonvar2)#">---><!---
<cfscript>selenium = new cfselenium.selenium();writeDump(selenium);</cfscript>--->
<!---<cfscript>
	objAutomationStudio = createObject("component","cfc.AutomationStudio");
	//objAutomationStudio.
	objAutomationStudio.RunTest('https://accesshometest.cogisi.com','*iexplore',4,1);
</cfscript>
</body>
</html>--->