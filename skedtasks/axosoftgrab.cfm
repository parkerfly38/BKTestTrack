<cfsetting requesttimeout="216000">
<cfset objAxoSoft = new CFTestTrack.cfc.AxoSoft()> 
<cfhttp url="https://cornerops.axosoft.com/api/oauth2/token?grant_type=password&username=bkresge&password=nugget38&client_id=84a344d7-9034-4ed7-8a01-ba35f9642648&client_secret=yUNiYAek30KibBtietQVo9UktJz8gv8GLdniTvzyv7rzWW4n2Xq0cSmedoJKMB_PUX5aWUyb2y5LXimFX-1wIJeCQocZSF6HTE7Q&scope=read" method="get" result="tokenResult" />
<!---<cfdump var="#tokenResult#">--->
<cfset local.accessToken = DeSerializeJSON(tokenResult.filecontent).access_token>
<cfset structItems = objAxoSoft.getItems(0,local.accessToken)>
<!---<cfdump var="#structItems#">--->
<cfloop array="#structItems["data"]#" index="i">
	<cfif i.number CONTAINS "COG">
	<cfscript>
		if ( ArrayLen(EntityLoad("TTestProject",{AxoSoftID = i.number})) lte 0 ) {
			newTestProject = new CFTestTrack.cfc.db.TTestProject();
		 	newTestProject.setProjectTitle(i.name);
		 	newTestProject.setAxoSoftID(i.number);
		 	newTestProject.setProjectDescription(i.description);
		 	newTestProject.setProjectStartDate(isnull(i.start_date) || i.start_date == "null" ? DateFormat(ParseDateTime(left(i.created_date_time,10),"yyyy-MM-dd"),"mm/dd/yyyy")  : DateFormat(ParseDateTime(left(i.start_date,10),"yyyy-MM-dd"),"mm/dd/yyyy"));
		 	newTestProject.setIncludeAnnouncement(false);
		 	newTestProject.setRepositoryType(1);
		 	newTestProject.setClosed(0);
		 	newTestProject.setAxoSoftProjectID(i.project.id);
		 	newTestProject.setAxoSoftSystemID(i.id);
		 	newTestProject.setAxoSoftClient(i.custom_fields.custom_1167);
		 	EntitySave(newTestProject);
		 }							
	</cfscript>
	</cfif>
	<cfif i.number DOES NOT CONTAIN "COG">
	<cfscript>
		if ( ArrayLen(EntityLoad("TTestProject",{AxoSoftID = i.number})) lte 0 ) {
			newTestProject = new CFTestTrack.cfc.db.TTestProject();
		 	newTestProject.setProjectTitle(i.name);
		 	newTestProject.setAxoSoftID(i.number);
		 	newTestProject.setProjectDescription(i.description);
		 	newTestProject.setProjectStartDate(
		 		isnull(i.start_date) || i.start_date == "null" ? DateFormat(ParseDateTime(left(i.created_date_time,10),"yyyy-MM-dd"),"mm/dd/yyyy")  :
		 		DateFormat(ParseDateTime(left(i.start_date,10),"yyyy-MM-dd"),"mm/dd/yyyy"));
		 	newTestProject.setIncludeAnnouncement(false);
		 	newTestProject.setRepositoryType(1);
		 	newTestProject.setClosed(0);
		 	newTestProject.setAxoSoftProjectID(i.project.id);
		 	newTestProject.setAxoSoftSystemID(i.id);
		 	newTestProject.setAxoSoftClient(i.custom_fields.custom_1196);
		 	EntitySave(newTestProject);
		 }							
	</cfscript>
	</cfif>
</cfloop><!---
<cfset dtLastWeek = (Fix( Now() ) - 7) />
<cfset objLastWeek = StructNew() />
<cfset objLastWeek.Start = DateFormat(createDate( year(now()) ,month(DateAdd("m",-1,Now())),1)) />
<!---<cfset objLastWeek.End = DateFormat(dateAdd("d",-1,createDate(year(now()),month(now()),1))) />--->
<cfset objLastWeek.End = DateFormat(createDate( year(now()) ,month(DateAdd("m",0,Now())),1)) /> />
<cfdump var="#objLastWeek#">

<cfhttp url="https://cornerops.axosoft.com/api/v5/work_logs/?access_token=#local.accessToken#&start_date=#objLastWeek.Start#&end_date=#objLastWeek.End#" method="get" result="worklogResult" />
<cfdump var="#DeserializeJSON(worklogResult.fileContent)#">
<cfloop array="#DeSerializeJSON(worklogResult.fileContent)['data']#" index="i">
	<cfscript>
		if (ArrayLen(EntityLoad("TTestAxoSoftWorkLog",{id = i.id})) LTE 0 ) {
			newWorkLog = new CFTestTrack.cfc.db.TTestAxoSoftWorkLog(); 
			newWorkLog.setId(i.id);
			newWorkLog.setDate_Time(DateFormat(ParseDateTime(left(i.date_time,10),"yyyy-MM-dd")));
			newWorkLog.setDescription(Left(i.description,1000));
			newWorkLog.setCustomer(Isnull(i.item.customer.company_name) || i.item.customer.company_name eq "" ? "" : i.item.customer.company_name);
			newWorkLog.setItemid(i.item.id);
			newWorkLog.setItem_type(i.item.item_type);
			newWorkLog.setItem_name(i.item.name);
			newworklog.setProjectid(i.project.id);
			newWorkLog.setusername(i.user.name);
			newWorkLog.setduration_hours(i.work_done.duration);
			newworkLog.setDuration_minutes(i.work_done.duration_minutes);
			newWorkLog.setWork_log_type(i.work_log_type.name);
			entitySave(newWorkLog);
		}
	</cfscript>
</cfloop>--->