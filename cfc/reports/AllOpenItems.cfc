component  implements="CFTestTrack.cfc.IReports"
{
	objFunctions = createObject("component","CFTestTrack.cfc.Functions");
	
	variables.reportid = 0;
	variables.ReportName = "";
	variables.ReportOptions = StructNew();
	variables.AccessAndScheduling = StructNew();
	
	public AllOpenItems function init(required numeric reportid, required string reportname, required struct reportoptions, required struct accessandscheduling) {
		variables.reportid = arguments.reportid;
		variables.ReportName = arguments.reportname;
		variables.ReportOptions = arguments.reportoptions;
		variables.AccessAndScheduling = arguments.accessandscheduling;
		return this;
	}
	
	public struct function getReportOptions()
	{
		if ( structIsEmpty(variables.ReportOptions) ) {
			variables.ReportOptions.GroupingAndChanges = StructNew();
			//variables.ReportOptions.GroupingAndChanges.IncludeChanges = "New,Updated";
			variables.ReportOptions.TimeFrame = "All";
			variables.ReportOptions.reporttype = "";
			variables.ReportOptions.reportcustomer = "";
			//variables.ReportOptions.TestScenarios = "";
		}
		return variables.ReportOptions;
	}
	public void function setAccessAndScheduling(required struct accessandscheduling)
	{
		variables.AccessAndScheduling = arguments.accessandscheduling;
	}
	public string function getReportDescription()
	{
		return "<strong>AxoSoft Integration Only:</strong>  Returns all open items in AxoSoft.";
	}
	public string function getJSONFormDataForPost()
	{
//		sReturn =	"var reportOptions = " & serializeJSON(getReportOptions()) & chr(13) & chr(10);
//		sReturn &=	"var reportAandS = " & serializeJSON(getAccessAndScheduling()) & chr(13) & chr(10);
//		sReturn &=	"reportOptions.GROUPINGANDCHANGES.INCLUDECHANGES = $('##includechanges:checked').map(function() {return this.value;}).get().join(',');" & chr(13) & chr(10);
//		sReturn &=	"reportOptions.TIMEFRAME = $('##timeframe').val();" & chr(13) & chr(10);
//		sReturn &=	"var ts = $('##testscenarios').val() || [];" & chr(13) & chr(10);
//		sReturn &=	"reportOptions.TESTSCENARIOS = ts.join(',');" & chr(13) & chr(10);
//		sReturn &=	"reportAandS.ACCESSBY = $('##AccessBy').val();" & chr(13) & chr(10);
//		sReturn &=	"reportAandS.CREATEREPORT = $('##createreport').val();" & chr(13) & chr(10);
//		sReturn &=	"reportAandS.EMAIL.NOTIFYME = $('##notifyme:checked').length == 1 ? '"& session.useridint & "' : '0';" & chr(13) & chr(10);
//		sReturn &=	"reportAandS.EMAIL.SENDLINKTOUSERIDS = $('##sendlinktouserids').val();" & chr(13) & chr(10);
//		sReturn &=  "reportAandS.EMAIL.SENDASATTACHMENTTO = $('##sendasattachmentto').val();" & chr(13) & chr(10);
//		sReturn &=	"reportAandS.STARTTIME = $('##starttime').val();" & chr(13) & chr(10);
		sReturn = "var reportOptions = " & serializeJSON(getReportOptions()) & chr(13) & chr(10);
		sReturn = "reportOptions.REPORTTYPE = $('##reporttype').val();" & chr(13) & chr(10);
		sReturn = "reportOptions.REPORTCUSTOMER = $('##reportcustomer').val();" & chr(13) & chr(10);
		return sReturn;
	}
	
	public any function runReport()
	{
		httpAxoSoft = new http();
		httpAxoSoft.setMethod("GET");
		httpAxoSoft.setURL("https://cornerops.axosoft.com/api/oauth2/token?grant_type=password&username=bkresge&password=nugget38&client_id=84a344d7-9034-4ed7-8a01-ba35f9642648&client_secret=yUNiYAek30KibBtietQVo9UktJz8gv8GLdniTvzyv7rzWW4n2Xq0cSmedoJKMB_PUX5aWUyb2y5LXimFX-1wIJeCQocZSF6HTE7Q&scope=read");
		tokenResult = httpAxoSoft.send().getPrefix();
		accessToken = DeSerializeJSON(tokenResult.filecontent).access_token;
		httpProjects = new http();
		httpProjects.setMethod("GET");
		httpProjects.setUrl("https://cornerops.axosoft.com/api/v2/incidents/?access_token="&accessToken);
		projectResult = httpProjects.send().getPrefix();
		httpBugs = new http();
		httpBugs.setMethod("GET");
		httpBugs.setUrl("https://cornerops.axosoft.com/api/v2/defects/?access_token="&accessToken);
		bugsResult = httpBugs.send().getPrefix();
		
		qryAllOpenItems = QueryNew("ID,Title,ReportedDate,CustomerContact,CustomerContactEmail,Client,Status,WorkflowStep,OriginalEstimate,HoursToDate,HoursLeft,DueDate","varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,decimal,decimal,decimal,varchar");
		objProjects = DeserializeJSON(projectResult.filecontent);
		objBugs = DeSerializeJSON(bugsResult.filecontent);
		
		if (variables.ReportOptions.reporttype != "All") 
		{
			var arrData = objProjects['data'];
			for ( i = 1; i LTE ArrayLen(arrData);i = i + 1) 
			{
				if ( arrData[i].workflow_step.name DOES NOT CONTAIN "Closed" && arrData[i].custom_fields.custom_1167 == variables.ReportOptions.reportcustomer ) 
				{
					QueryAddRow(qryAllOpenItems);
					QuerySetCell(qryAllOpenItems, "ID", arrData[i].number);
					QuerySetCell(qryAllOpenItems, "Title", arrData[i].name);
					QuerySetCell(qryAllOpenItems, "ReportedDate",isnull(arrData[i].reported_date) || arrData[i].reported_date == "null" ? DateFormat(ParseDateTime(left(arrData[i].created_date_time, 10),"yyyy-MM-dd"),"mm/dd/yyyy") : DateFormat(ParseDateTime(left(arrData[i].reported_date,10),"yyyy-MM-dd"),"mm/dd/yyyy"));
					QuerySetCell(qryAllOpenItems, "CustomerContact", isnull(arrData[i].reported_by_customer_contact.name) ? "" : arrData[i].reported_by_customer_contact.name);
					QuerySetCell(qryAllOpenItems, "CustomerContactEmail", isnull(arrData[i].reported_by_customer_contact.email) ? "" : arrData[i].reported_by_customer_contact.email);
					QuerySetCell(qryAllOpenItems, "Client", arrData[i].custom_fields.custom_1167);
					QuerySetCell(qryAllOpenItems, "Status", arrData[i].status.name);
					QuerySetCell(qryAllOpenItems, "WorkflowStep", arrData[i].workflow_step.name);
					originalestimate = arrData[i].estimated_duration.duration_minutes / 60;
					originalestimate = originalestimate * 100;
					originalestimate = Round(originalestimate);
					originalestimate = originalestimate / 100;
					QuerySetCell(qryAllOpenItems, "OriginalEstimate", originalestimate);
					if ( isnull(arrData[i].actual_duration.duration_minutes) )
					{
						actualduration = 0;
					} else {
						actualduration = arrData[i].actual_duration.duration_minutes / 60;
						actualduration = actualduration * 100;
						actualduration = Round(actualduration);
						actualduration = actualduration / 100;
					}
					QuerySetCell(qryAllOpenItems, "HoursToDate", actualduration);
					QuerySetCell(qryAllOpenItems, "HoursLeft", decimalFormat((originalestimate) - (actualduration)));
					QuerySetCell(qryAllOpenItems, "DueDate", isNull(arrData[i].due_date) || arrData[i].due_date == "null" ? "No Due Date Assigned" : DateFormat(ParseDateTime(left(arrData[i].due_date,10),"yyyy-MM-dd"), "mm/dd/yyyy"));
				}					
			}
			var arrBugs = objBugs['data'];
			for ( i = 1; i LTE ArrayLen(arrBugs);i = i + 1) 
			{
				if ( arrBugs[i].workflow_step.name != "Fixed" && arrBugs[i].workflow_step.name != "Rejected" && arrBugs[i].custom_fields.custom_1196 == variables.ReportOptions.reportcustomer ) 
				{
					QueryAddRow(qryAllOpenItems);
					QuerySetCell(qryAllOpenItems, "ID", "BUG" & arrBugs[i].number);
					QuerySetCell(qryAllOpenItems, "Title", arrBugs[i].name);
					QuerySetCell(qryAllOpenItems, "ReportedDate",isnull(arrBugs[i].reported_date) || arrBugs[i].reported_date == "null" ? DateFormat(ParseDateTime(left(arrBugs[i].created_date_time, 10),"yyyy-MM-dd"),"mm/dd/yyyy") : DateFormat(ParseDateTime(left(arrBugs[i].reported_date,10),"yyyy-MM-dd"),"mm/dd/yyyy"));
					QuerySetCell(qryAllOpenItems, "CustomerContact", isnull(arrBugs[i].reported_by_customer_contact.name) ? "" : arrBugs[i].reported_by_customer_contact.name);
					QuerySetCell(qryAllOpenItems, "CustomerContactEmail", isnull(arrBugs[i].reported_by_customer_contact.email) ? "" : arrBugs[i].reported_by_customer_contact.email);
					QuerySetCell(qryAllOpenItems, "Client", arrBugs[i].custom_fields.custom_1196);
					QuerySetCell(qryAllOpenItems, "Status", arrBugs[i].status.name);
					QuerySetCell(qryAllOpenItems, "WorkflowStep", arrBugs[i].workflow_step.name);
					originalestimate = arrBugs[i].estimated_duration.duration_minutes / 60;
					originalestimate = originalestimate * 100;
					originalestimate = Round(originalestimate);
					originalestimate = originalestimate / 100;
					QuerySetCell(qryAllOpenItems, "OriginalEstimate", originalestimate);
					if ( isnull(arrBugs[i].actual_duration.duration_minutes) )
					{
						actualduration = 0;
					} else {
						actualduration = arrBugs[i].actual_duration.duration_minutes / 60;
						actualduration = actualduration * 100;
						actualduration = Round(actualduration);
						actualduration = actualduration / 100;
					}
					QuerySetCell(qryAllOpenItems, "HoursToDate", actualduration);
					QuerySetCell(qryAllOpenItems, "HoursLeft", decimalFormat((originalestimate) - (actualduration)));
					QuerySetCell(qryAllOpenItems, "DueDate", isNull(arrBugs[i].due_date) || arrBugs[i].due_date == "null" ? "No Due Date Assigned" : DateFormat(ParseDateTime(left(arrBugs[i].due_date,10),"yyyy-MM-dd"), "mm/dd/yyyy"));
				}					
			}
		}
		//return qryAllOpenItems;
		if ( variables.ReportOptions.reporttype != "Excel" ) {
			objFunctions.createCFROutputfromContent(variables.ReportOptions.reporttype,"AllOpenItems",qryAllOpenItems,variables.reportid);
		} else {
			
		}
	}
	
	public any function showReport() {
		
	}
	
	public void function saveReport()
	{

	}
	public struct function getAccessAndScheduling()
	{
		if ( structIsEmpty(variables.AccessAndScheduling) )
		{
			variables.AccessAndScheduling.AccessBy = Session.UserIDInt;
			variables.AccessAndScheduling.CreateReport = "Once";
			variables.AccessAndScheduling.Email = StructNew();
			variables.AccessAndScheduling.Email.NotifyMe = true;
			variables.AccessAndScheduling.Email.SendLinkToUserIds = "";
			variables.AccessAndScheduling.Email.SendAsAttachmentTo = "";
			variables.AccessAndScheduling.StartDate = DateFormat(Now(),"YYYY-MM-DD");
			variables.AccessAndScheduling.StartTime = "17:00";
		}
		return variables.AccessAndScheduling;
	
	}
	public string function getReportTypeName()
	{
		return "All Open Items";
	}
	public string function getVersion()
	{
		return "1.0";
	}
	public string function getFormFields() output="true"
	{
//		var formbody = "<p>Select report type:</p>";
//		formbody &= '<select class="form-control" name="reporttype" id="reportype">';
//		formbody &= '	<option>PDF</option>';
//		formbody &= '	<option>Excel</option>';
//		formbody &= '	<option>HTML</option>';
//		formbody &= '	<option>FlashPaper</option>';
//		formbody &= '	<option>RTF</option>';
//		formbody &= '	<option>XML</option>';
//		formbody &= '</select><br />';
//		formbody &= 'Select client:<br />';
//		formbody &= '<select class="form-control" name="reportcustomer" id="reportcustomer">';
//		formbody &= '	<option>AHIC</option>';
//		formbody &= '	<option>SBOA</option>';
//		formbody &= '	<option>All</option>';
//		formbody &= '</select><br />';
//		return formbody;
		savecontent variable="reportreturn" {
			include "../../report/AllOpenItems.cfm";
		} 
		return reportreturn;
	}
	public string function getAuthor()
	{
		return "Brian Kresge, MBA";
	}
	public numeric function getReportId()
	{
		return variables.reportid;
	}
	public string function getReportName()
	{
		return variables.ReportName;
	}
	
	public string function getGroup()
	{
		return "AxoSoft";
	}
	
	public void function setReportOptions(required struct reportoptions)
	{
		variables.ReportOptions = arguments.reportoptions;
	}
}