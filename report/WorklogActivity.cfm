
<cfhttp url="https://cornerops.axosoft.com/api/oauth2/token?grant_type=password&username=bkresge&password=nugget38&client_id=84a344d7-9034-4ed7-8a01-ba35f9642648&client_secret=yUNiYAek30KibBtietQVo9UktJz8gv8GLdniTvzyv7rzWW4n2Xq0cSmedoJKMB_PUX5aWUyb2y5LXimFX-1wIJeCQocZSF6HTE7Q&scope=read" method="get" result="tokenResult" />
<cfset accessToken = DeSerializeJSON(tokenResult.filecontent).access_token>
<cfhttp url="https://cornerops.axosoft.com/api/v2/incidents/?access_token=#accessToken#" method="get" result="httpResult" />
<cfhttp url="https://cornerops.axosoft.com/api/v2/defects/?access_token=#accessToken#" method="get" result="bugResult" />
<cfset qryClientAcceptance = QueryNew("ID,Title,ReportedDate,CustomerContact,CustomerContactEmail,Client,Status,WorkflowStep,OriginalEstimate,HoursToDate,HoursLeft,DueDate,StartDate,Developer,DeveloperHours,SA,SAHours,PM,PMHours","varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,decimal,decimal,decimal,date,date,varchar,decimal,varchar,decimal,varchar,decimal") >
<cfset objData = DeserializeJSON(httpResult.fileContent) />
<cfset objBugData = DeserializeJSON(bugResult.fileContent) />

<cfloop array="#objData['data']#" index="i">
	<cfif i.workflow_step.name DOES NOT CONTAIN "Closed">
		<cfset temp = QueryAddRow(qryClientAcceptance)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"ID",i.number)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"Title",i.name)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"ReportedDate",isnull(i.reported_date) || i.reported_date eq "null" ? DateFormat(ParseDateTime(left(i.created_date_time,10),"yyyy-MM-dd"),"mm/dd/yyyy") : DateFormat(ParseDateTime(left(i.reported_date,10),"yyyy-MM-dd"),"mm/dd/yyyy") )>
		<cfset temp = QuerySetCell(qryClientAcceptance,"CustomerContact",isnull(i.reported_by_customer_contact.name) ? "" : i.reported_by_customer_contact.name)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"CustomerContactEmail",isnull(i.reported_by_customer_contact.email) ? "" : i.reported_by_customer_contact.email)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"Client",i.custom_fields.custom_1167)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"Status",i.status.name)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"WorkflowStep",i.workflow_step.name)>
		<cfset originalestimate = i.estimated_duration.duration_minutes / 60>
		<cfset originalestimate = originalestimate * 100>
		<cfset originalestimate = Round(originalestimate)>
		<cfset originalestimate = originalestimate / 100>
		<cfset temp = QuerySetCell(qryClientAcceptance,"OriginalEstimate",originalestimate)>
		<cfif isnull(i.actual_duration.duration_minutes)>
			<cfset actualduration = 0>
		<cfelse>
			<cfset actualduration =  i.actual_duration.duration_minutes / 60>
			<cfset actualduration = actualduration * 100>
			<cfset actualduration = Round(actualduration)>
			<cfset actualduration = actualduration / 100>
		</cfif>
		<cfset temp = QuerySetCell(qryClientAcceptance,"HoursToDate",actualduration)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"HoursLeft",DecimalFormat((originalestimate) - (actualduration)))>
		<cfset temp = QuerySetCell(qryClientAcceptance,"DueDate",isnull(i.due_date) || i.due_date eq "null" ? DateFormat(DateAdd("m",1,Now()),"mm/dd/yyyy") : DateFormat(ParseDateTime(left(i.due_date,10),"yyyy-MM-dd"),"mm/dd/yyyy") )>
		<cfset temp = QuerySetCell(qryClientAcceptance,"StartDate",isnull(i.start_date) || i.start_date eq "null" ? DateFormat(ParseDateTime(left(i.created_date_time,10),"yyyy-MM-dd"),"mm/dd/yyyy") : DateFormat(ParseDateTime(left(i.start_date,10),"yyyy-MM-dd"),"mm/dd/yyyy")) >
		<cfset temp = QuerySetCell(qryClientAcceptance,"Developer",i.custom_fields.custom_1217)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"DeveloperHours",isnull(i.custom_fields.custom_1218) ? 0 : REFind("[0-9]",i.custom_fields.custom_1218))>
		<cfset temp = QuerySetCell(qryClientAcceptance,"SA",i.custom_fields.custom_1214)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"SAHours",isnull(i.custom_fields.custom_1216) ? 0 : REFind("[0-9]",i.custom_fields.custom_1216))>
		<cfset temp = QuerySetCell(qryClientAcceptance,"PM",i.custom_fields.custom_1219)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"PMHours",isnull(i.custom_fields.custom_1220) ? 0 : REFind("[0-9]",i.custom_fields.custom_1220))>
	</cfif>
</cfloop>

<!--- first get developer time --->
<!--- group by dev first --->
<cfquery name="qryDevelopers" dbtype="query">
	SELECT DISTINCT Developer FROM qryClientAcceptance
	WHERE Developer <> ''
</cfquery>
<cfloop query="qryDevelopers">
	<cfquery name="qryDevTasks" dbtype="query">
		SELECT * from qryClientAcceptance
		WHERE Developer = '#Developer#'
	</cfquery>
	<cfset qDevTasks = QueryNew("TaskName,Hours,StartDate,EndDate")>
	<cfloop query="qryDevTasks">
		<cfset row = QueryAddRow(qDevTasks,1)>
		<cfset QuerySetCell(qDevTasks,"TaskName",ID,row)>
		<cfset QuerySetCell(qDevTasks,"Hours",DeveloperHours,row)>
		<cfset QuerySetCell(qDevTasks,"StartDate",ParseDateTime(StartDate),row)>
		<cfset QuerySetCell(qDevTasks,"EndDate",DueDate eq "No Due Date Assigned" ? ParseDateTime(local.dtEndDate) : ParseDateTime(DueDate),row)>
	</cfloop>
	<cfquery name="qryStartDate" dbtype="query" maxrows="1">
		SELECT  StartDate FROM qDevTasks
		ORDER BY StartDate ASC
	</cfquery>
	<cfset local.dtStartDate = qryStartDate.StartDate[1]>
	<cfquery name="qryEndDate" dbtype="query" maxrows="1">
		SELECT EndDate FROM qDevTasks
		ORDER BY EndDate DESC
	</cfquery>
	<cfset local.dtEndDate = qryEndDate.EndDate[1]>

	
	<cfscript>
		ganttChart = createObject("component","GanttChart").constructor();
		ganttChart.setStartDate(DateFormat(local.dtStartDate,"m/d/yy"));
		ganttChart.setEndDate(DateFormat(local.dtEndDate,"m/d/yy"));
		ganttChart.setTitle('Developer Time');
		ganttChart.setWidth(600);
		ganttChart.setScale('daily');
		ganttChart.setrowLabel(Developer);
	</cfscript>
	<cfloop query="qDevTasks">
		<cfscript>
			grow = createObject("component","GanttChartRow").constructor("#TaskName# - #Hours# hrs");
			grow.addRange(DateFormat(qDevTasks.StartDate,"m/d/yy"),DateFormat(qDevTasks.EndDate,"m/d/yy"),returnRandomHEXColors(1));
			ganttChart.addRow(grow);
		</cfscript>
	</cfloop>
	<cfset ganttChart.draw()>
</cfloop>
<cfscript>
    function returnRandomHEXColors(numToReturn){
	    var returnList = ""; 
        var colorTable = "A,B,C,D,E,F,0,1,2,3,4,5,6,7,8,9";

        for (i=1; i LTE val(numToReturn); i=i+1)
        {
           	tRandomColor = "";
           	for(c=1; c lte 6; c=c+1)
           	{
           		tRandomColor = tRandomColor & listGetAt(colorTable, randRange(1, listLen(colorTable)));
           	}
           	returnList = listAppend(returnList, tRandomColor);
        }    
        return returnList;
    }
</cfscript>