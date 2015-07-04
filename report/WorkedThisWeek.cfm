<cfhttp url="https://cornerops.axosoft.com/api/oauth2/token?grant_type=password&username=bkresge&password=nugget38&client_id=84a344d7-9034-4ed7-8a01-ba35f9642648&client_secret=yUNiYAek30KibBtietQVo9UktJz8gv8GLdniTvzyv7rzWW4n2Xq0cSmedoJKMB_PUX5aWUyb2y5LXimFX-1wIJeCQocZSF6HTE7Q&scope=read" method="get" result="tokenResult" />
<cfset accessToken = DeSerializeJSON(tokenResult.filecontent).access_token>

<cfset dtLastWeek = (Fix( Now() ) - 7) />
<cfset objLastWeek = StructNew() />
<cfset objLastWeek.Start = DateFormat(dtLastWeek - DayOfWeek( dtLastWeek ) + 1) />
<cfset objLastWeek.End = DateFormat( objLastWeek.Start + 6 ) />

<cfhttp url="https://cornerops.axosoft.com/api/v2/work_logs/?access_token=#accessToken#&start_date=#objLastWeek.Start#&end_date=#objLastWeek.End#" method="get" result="worklogResult" />
<cfset objWorkLogData = DeserializeJSON(worklogResult.fileContent) />
<cfset qryWorkLogs = QueryNew("duration,itemid","decimal,integer")>
<cfloop array="#objWorkLogData['data']#" index="i">
	<cfset temp = QueryAddRow(qryWorkLogs)>
	<cfif i.work_done.time_unit.name eq "Minutes">
		<cfset temp = QuerySetCell(qryWorkLogs,"duration",i.work_done.duration / 60)>
	<cfelseif i.work_done.time_unit.name eq "Hours">
		<cfset temp = QuerySetCell(qryWorkLogs,"duration",i.work_done.duration)>
	</cfif>
	<cfset temp = QuerySetCell(qryWorkLogs,"itemid",i.item.id)>
</cfloop>

<cfhttp url="https://cornerops.axosoft.com/api/v2/incidents/?access_token=#accessToken#" method="get" result="itemResult" />
<cfset objItemData = DeserializeJSON(itemResult.fileContent) />
<cfset qryClientAcceptance = QueryNew("ID,itemid,Title,ReportedDate,CustomerContact,CustomerContactEmail,Client,Status,WorkflowStep,OriginalEstimate,HoursToDate,HoursLeft,HoursWorkedThisWeek","varchar,integer,varchar,varchar,varchar,varchar,varchar,varchar,varchar,decimal,decimal,decimal,decimal") >
<cfloop array="#objItemData['data']#" index="i">
	<cfif i.workflow_step.name DOES NOT CONTAIN "Closed" AND i.custom_fields.custom_1167 eq "AHIC">
		<cfset temp = QueryAddRow(qryClientAcceptance)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"ID",i.number)>
		<cfset temp = QuerySetCell(qryClientAcceptance,"itemid",i.id)>
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
		<cfquery dbtype="query" name="qryItemSum">
			SELECT sum(duration) as durationsum
			FROM qryWorkLogs
			WHERE itemid = #i.id#
		</cfquery>
		<cfif qryItemSum.RecordCount gt 0>
			
			<cfset temp = QuerySetCell(qryClientAcceptance,"HoursWorkedThisWeek",NumberFormat(qryItemSum.durationsum,"0.00"))>
		<cfelse>
			<cfset temp = QuerySetCell(qryClientAcceptance,"HoursWorkedThisWeek",0)>
		</cfif>
	</cfif>
</cfloop>

<cfquery dbtype="query" name="qryResult">
	SELECT * FROM qryClientAcceptance
	WHERE HoursWorkedThisWeek > 0
</cfquery>
<cfreport query="#qryResult#" template="WorkedThisWeek.cfr" format="PDF"></cfreport>
