<cfif !StructKeyExists(FORM,"reporttype")>
	<form method="post">
		Select report type:<br />
		<select name="reporttype" id="reportype">
			<option>PDF</option>
			<option>Excel</option>
			<option>HTML</option>
			<option>FlashPaper</option>
			<option>RTF</option>
			<option>XML</option>
		</select><br />
		Select client:<br />
		<select name="reportcustomer" id="reportcustomer">
			<option>AHIC</option>
			<option>SBOA</option>
			<option>All</option>
		</select><br />
		<input type="submit" value="Create Report" />
	</form>
<cfelse>
<cfhttp url="https://cornerops.axosoft.com/api/oauth2/token?grant_type=password&username=bkresge&password=nugget38&client_id=84a344d7-9034-4ed7-8a01-ba35f9642648&client_secret=yUNiYAek30KibBtietQVo9UktJz8gv8GLdniTvzyv7rzWW4n2Xq0cSmedoJKMB_PUX5aWUyb2y5LXimFX-1wIJeCQocZSF6HTE7Q&scope=read" method="get" result="tokenResult" />
<cfset accessToken = DeSerializeJSON(tokenResult.filecontent).access_token>
<cfhttp url="https://cornerops.axosoft.com/api/v2/incidents/?access_token=#accessToken#" method="get" result="httpResult" />
<cfhttp url="https://cornerops.axosoft.com/api/v2/defects/?access_token=#accessToken#" method="get" result="bugResult" />
<cfset qryClientAcceptance = QueryNew("ID,Title,ReportedDate,CustomerContact,CustomerContactEmail,Client,Status,WorkflowStep,OriginalEstimate,HoursToDate,HoursLeft,DueDate","varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,decimal,decimal,decimal,varchar") >
<cfset objData = DeserializeJSON(httpResult.fileContent) />
<cfset objBugData = DeserializeJSON(bugResult.fileContent) />
<cfif form.reportcustomer neq "All">
<cfloop array="#objData['data']#" index="i">
	<cfif i.workflow_step.name DOES NOT CONTAIN "Closed" AND i.custom_fields.custom_1167 eq "#form.reportcustomer#">
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
		<cfset temp = QuerySetCell(qryClientAcceptance,"DueDate",isnull(i.due_date) || i.due_date eq "null" ? "No Due Date Assigned" : DateFormat(ParseDateTime(left(i.due_date,10),"yyyy-MM-dd"),"mm/dd/yyyy") )>
	</cfif>
</cfloop>
<cfloop array="#objBugData['data']#" index="i">
	<cfif (i.workflow_step.name neq "Fixed" and i.workflow_step.name neq "Rejected") AND i.custom_fields.custom_1196 eq "#form.reportcustomer#">
		<cfset temp = QueryAddRow(qryClientAcceptance)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"ID","BUG" & i.number)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"Title",i.name)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"ReportedDate",isnull(i.reported_date) || i.reported_date eq "null" ? DateFormat(ParseDateTime(left(i.created_date_time,10),"yyyy-MM-dd"),"mm/dd/yyyy") : DateFormat(ParseDateTime(left(i.reported_date,10),"yyyy-MM-dd"),"mm/dd/yyyy") )>
		<cfset temp = QuerySetCell(qryClientAcceptance,"CustomerContact",isnull(i.reported_by_customer_contact.name) ? "" : i.reported_by_customer_contact.name)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"CustomerContactEmail",isnull(i.reported_by_customer_contact.email) ? "" : i.reported_by_customer_contact.email)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"Client",i.custom_fields.custom_1196)>
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
		<cfset temp = QuerySetCell(qryClientAcceptance,"DueDate",isnull(i.due_date) || i.due_date eq "null" ? "No Due Date Assigned" : DateFormat(ParseDateTime(left(i.due_date,10),"yyyy-MM-dd"),"mm/dd/yyyy") )>
	</cfif>
</cfloop>
<cfelse>
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
		<cfset temp = QuerySetCell(qryClientAcceptance,"DueDate",isnull(i.due_date) || i.due_date eq "null" ? "No Due Date Assigned" : DateFormat(ParseDateTime(left(i.due_date,10),"yyyy-MM-dd"),"mm/dd/yyyy") )>
	</cfif>
</cfloop>
<cfloop array="#objBugData['data']#" index="i">
	<cfif (i.workflow_step.name neq "Fixed" and i.workflow_step.name neq "Rejected")>
		<cfset temp = QueryAddRow(qryClientAcceptance)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"ID","BUG" & i.number)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"Title",i.name)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"ReportedDate",isnull(i.reported_date) || i.reported_date eq "null" ? DateFormat(ParseDateTime(left(i.created_date_time,10),"yyyy-MM-dd"),"mm/dd/yyyy") : DateFormat(ParseDateTime(left(i.reported_date,10),"yyyy-MM-dd"),"mm/dd/yyyy") )>
		<cfset temp = QuerySetCell(qryClientAcceptance,"CustomerContact",isnull(i.reported_by_customer_contact.name) ? "" : i.reported_by_customer_contact.name)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"CustomerContactEmail",isnull(i.reported_by_customer_contact.email) ? "" : i.reported_by_customer_contact.email)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"Client",i.custom_fields.custom_1196)>
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
		<cfset temp = QuerySetCell(qryClientAcceptance,"DueDate",isnull(i.due_date) || i.due_date eq "null" ? "No Due Date Assigned" : DateFormat(ParseDateTime(left(i.due_date,10),"yyyy-MM-dd"),"mm/dd/yyyy") )>
	</cfif>
</cfloop>
</cfif>
<cfquery name="qryReport" dbtype="query">
	SELECT * FROM qryClientAcceptance
	ORDER BY WorkflowStep <cfif form.reportcustomer eq "all">, Client</cfif>, ID
</cfquery>
<cfif form.reporttype NEQ "excel">
<cfquery name="qryCounts" dbtype="query">
	SELECT WorkflowStep, COUNT(WorkflowStep) as WorkflowCount
	FROM qryReport
	GROUP BY WorkflowStep
</cfquery>
<cfreport query="#qryReport#" template="AllOpenItems.cfr" format="#form.reporttype#">
	<cfreportparam series="1" chart="PieChart" query="#qryCounts#">
	<cfif form.reportcustomer eq "SBOA">
	<cfreportparam name="customername" value="SBOA">
	<cfelseif form.reportcustomer eq "All">
	<cfreportparam name="customername" value="Cornerstone">
	<cfelse>
	<cfreportparam name="customername" value="Access Home">
	</cfif>
</cfreport>
<cfelse>
	<cfscript> 
	    ///We need an absolute path, so get the current directory path. 
	    theFile=GetDirectoryFromPath(GetCurrentTemplatePath()) & "allopenitems.xlsx"; 
	    //Create a new Excel spreadsheet object. 
	    s = SpreadsheetNew("AllOpenItems");
	  	spreadsheetAddRow(s,"ID,Title,ReportedDate,CustomerContact,CustomerContactEmail,Client,Status,WorkflowStep,OriginalEstimate,HoursToDate,HoursLeft,DueDate");
	  	spreadsheetFormatRow(s,{bold=true,fgcolor="lemon_chiffon",fontsize=14},1);
	  	spreadSheetAddRows(s,qryReport);
	  	spreadSheetWrite(s,theFile,true);
	</cfscript> 
 
	<!--- Write the spreadsheet to a file, replacing any existing file. ---> 
	<cfheader name="content-disposition" value="attachment; filename=AllOpenItems.xls">
	<cfcontent type="application/msexcel" variable="#spreadsheetReadBinary(s)#" reset="true">
</cfif>	
</cfif>

