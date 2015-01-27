component implements="COGTestTrack.cfc.IReports"
{
	objFunctions = createObject("component","COGTestTrack.cfc.Functions");
	
	variables.reportid = 0;
	variables.ReportName = "";
	variables.ReportOptions = StructNew();
	variables.AccessAndScheduling = StructNew();
	
	public Activity function init(required numeric reportid, required string reportname, required struct reportoptions, required struct accessandscheduling) {
		variables.reportid = arguments.reportid;
		variables.ReportName = arguments.reportname;
		variables.ReportOptions = arguments.reportoptions;
		variables.AccessAndScheduling = arguments.accessandscheduling;
		return this;
	}
	
	public void function setReportName(required string reportname)
	{
		variables.ReportName = arguments.reportname;
	}
	
	public void function setReportOptions(required struct reportoptions)
	{
		variables.ReportOptions = arguments.reportoptions;
	}
	public void function setAccessAndScheduling(required struct accessandscheduling)
	{
		variables.AccessAndScheduling = arguments.accessandscheduling;
	}
	
	public struct function getReportOptions()
	{
		if ( structIsEmpty(variables.ReportOptions) ) {
			variables.ReportOptions.GroupingAndChanges = StructNew();
			variables.ReportOptions.GroupingAndChanges.IncludeChanges = "New,Updated";
			variables.ReportOptions.TimeFrame = "Today";
			variables.ReportOptions.TestScenarios = "";
		}
		return variables.ReportOptions;
	}
	public struct function getAccessAndScheduling() {
		if ( structIsEmpty(variables.AccessAndScheduling) )
		{
			variables.AccessAndScheduling.AccessBy = Session.UserIDInt;
			variables.AccessAndScheduling.CreateReport = "Once";
			variables.AccessAndScheduling.Email = StructNew();
			variables.AccessAndScheduling.Email.NotifyMe = true;
			variables.AccessAndScheduling.Email.SendLinkToUserIds = "";
			variables.AccessAndScheduling.Email.SendAsAttachmentTo = "";
			variables.AccessAndScheduling.StartDate = Now();
			variables.AccessAndScheduling.StartTime = "17:00";
		}
		return variables.AccessAndScheduling;
	}
	
	public string function getReportDescription()
	{
		return "Shows a summary of new and updated test cases.  Refer to the Options section below to configure the report specific options.";
	}
	public string function getReportTypeName()
	{
		return "Activity Report";
	}
	public string function getVersion()
	{
		return "1";
	}
	public string function getAuthor()
	{
		return "Brian Kresge, MBA";
	}
	public string function getReportName()
	{
		return variables.ReportName;
	}
	public string function getGroup()
	{
		return "Projects";
	}
	public numeric function getReportId() {
		return variables.reportid;
	}
	
	public void function saveReport()
	{
		if ( variables.reportid == 0 ) {
			report = EntityNew("TTestReports");
		} else {
			report = EntityLoadByPK("TTestReports",variables.reportid);
		}
		report.setReportTypeName(this.getReportTypeName());
		report.setReportAuthor(this.getAuthor());
		report.setReportGroup(this.getGroup());
		report.setReportVersion(this.getVersion());
		report.setReportName(this.getReportName());
		report.setReportDescription(this.getReportDescription());
		report.setReportOptions(objFunctions.toWddx(this.GetReportOptions()));
		report.setReportAccessAndScheduling(objFunctions.toWddx(this.getAccessAndScheduling()));
		EntitySave(report);
		variables.reportid = report.getId();
		if ( variables.AccessAndScheduling.CreateReport != "once" ) {
			objMaintenance = createObject("component","COGTestTrack.cfc.Maintenance");
			objMaintenance.createTask(report.getId(),variables.AccessAndScheduling.CreateReport,variables.AccessAndScheduling.StartDate,variables.AccessAndScheduling.StartTime);
		}
		
	}
	public any function runReport() {
		if ( StructKeyExists(variables.AccessAndScheduling,"CreateReport") && variables.AccessAndScheduling.CreateReport == "OneTime")
		{
			if ( FileExists("../../reportpdfs/"&variables.reportid&".pdf") ) 
			{
				return;
			}
		}
		sql = "SELECT a.TestTitle, b.Action, b.DateOfAction,d.UserName ";
		sql &= "FROM TTestCase a INNER JOIN TTestCaseHistory b ";
		sql &= "ON a.id = b.CaseId ";
		if ( Len(variables.ReportOptions.TestScenarios) > 0 ) {
			sql &= "INNER JOIN TTestScenarioCases c ON a.id = c.CaseId ";
		}
		sql &= "INNER JOIN TTestTester d ON b.TesterId = d.id ";
		sql &= "WHERE b.DateActionClosed IS NULL ";
		if ( ListContainsNoCase(variables.ReportOptions.GroupingAndChanges.IncludeChanges,"New") > 0 && ListContainsNoCase(variables.ReportOptions.GroupingAndChanges.IncludeChanges,"Updated") == 0)
			sql &= "AND b.Action = 'Created' ";
		if ( Len(variables.ReportOptions.TestScenarios) > 0 )
			sql &= "AND c.ScenarioID IN (" & variables.ReportOptions.TestScenarios & ") ";
		if ( variables.ReportOptions.TimeFrame == "Today" )
			sql &= "AND DateOfAction > DATEADD(d,-1,GETDATE()) AND DateOfAction < DATEADD(d,1,GETDATE()) ";
		if ( variables.ReportOptions.TimeFrame == "Week" ) {
			if ( dayofWeek(now()) > 1)
			{
				mostRecentMonday = dateAdd("d",2-dayofWeek(now()),now());
			} else {
				mostRecentMonday = dateAdd("d",-6,now());
			}
			sql &= "AND DateofAction > '" & CreateOdbcDate(mostRecentMonday) & "' AND DateOfAction <= DateAdd(d,7,'" & CreateOdbcDate(mostRecentMonday) & "') ";
		}
		q1 = new Query();
		q1.setSQL(sql);
		rs1 = q1.execute().getResult();
		
		reportoutput = "<table border='0' cellspacing='0' cellpadding='2' align='center'><tbody>";
		if ( ListContainsNoCase(variables.ReportOptions.GroupingAndChanges.IncludeChanges,"New") > 0 && ListContainsNoCase(variables.ReportOptions.GroupingAndChanges.IncludeChanges,"Updated") > 0)
		{
			q2 = new Query();
			q2.setName("myquery");
			q2.setDBType("query");
			q2.setAttributes(rs=rs1);
			q2.setSQL("SELECT [Action] as Item, COUNT([Action]) as ItemCount FROM [rs] GROUP BY [Action]");
			rs2 = q2.execute().getResult();
			reportoutput &= "<tr><td>" & objFunctions.piechart(rs2,"Activity Counts") & "</td></tr>";
			
		}
		reportoutput &= "<tr><td><h3>Activity for Date Range</h3><table border='0' cellspacing='0' cellpadding='3'><thead><tr><th>Action</th><th>Date</th><th>Test Title</th><th>Assigned To</th></tr></thead><tbody>";
		for ( q in rs1 ) {
			reportoutput &= "<tr><td>" & q.Action & "</td><td>" & q.DateOfAction & "</td><td>" & q.TestTitle & "</td><td>" & q.UserName & "</td></tr>";
		}
		reportoutput &= "</tbody></table></td></tr></tbody></table>";
		writeOutput(reportoutput); 
		pdfvar = objFunctions.createPDFfromContent(reportoutput);
		fileWrite(ExpandPath("/reportpdfs/") & variables.reportid & ".pdf",pdfvar);
		//TODO:  if it's scheduled, handle email disposition
	}
}