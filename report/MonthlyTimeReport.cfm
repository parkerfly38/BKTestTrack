<cfset objLastWeek = StructNew() />
<cfset objLastWeek.Start = DateFormat(createDate( year(now()) ,month(DateAdd("m",-1,Now())),1),"mm-dd-yyyy") />
<cfset objLastWeek.End = DateFormat(createDate( year(now()) ,month(DateAdd("m",0,Now())),1),'mm-dd-yyyy') />

<cfquery name="qryWorkLogs">
	SELECT TTestAxoSoftWorkLog.id, date_time, description, customer, itemid, item_type, item_name, projectid, username, duration_hours, duration_minutes, work_log_type,
	"AxoSoftClient" = CASE AxoSoftClient WHEN '' THEN 'COG' ELSE AxoSoftClient END 
	FROM TTestAxoSoftWorkLog
	INNER JOIN TTestProject ON itemid = AxoSoftSystemID AND TTestAxoSoftWorkLog.ProjectId = TTestProject.AxoSoftProjectID
	WHERE date_time between '#objLastWeek.Start#' AND '#objLastWeek.End#'
	AND username NOT in ('Trish Varnalis','Drew Yerger')
	ORDER BY date_time
</cfquery>
<cfquery name="qryClientGroupedLogs" dbtype="query">
	SELECT AxoSoftClient, SUM(duration_minutes)/60 as totalhours
	FROM qryWorkLogs
	GROUP BY AxoSoftClient
</cfquery>
<cfset local.totalHours = 0>
<cfloop query="qryClientGroupedLogs">
	<cfset local.totalHours = local.totalHours + qryClientGroupedLogs.totalhours>
</cfloop>
<cfquery name="qryGroupedLogs" dbtype="query">
	SELECT username, AxoSoftClient, SUM(duration_minutes)/60 as totalminutes
	FROM qryWorkLogs
	GROUP BY username, AxoSoftClient
</cfquery>
<cfquery name="qryGroupedUsers" dbtype="query">
	SELECT username from qryWorkLogs
	GROUP BY username
</cfquery>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	    <script src="../scripts/jquery-1.10.2.min.js" type="text/javascript"></script>
	    <script src="../scripts/bootstrap.min.js" type="text/javascript"></script>
	    <script src="../scripts/ChartNew.js" type="text/javascript"></script>
	    <link rel="stylesheet" href="../style/bootstrap.css" media="screen" />
	</head>
	<body>
		<header class="container"><h1>IT Monthly Time Report</h1></header>
		<div class="container">
			<div class="col-sm-6 col-md-6 col-lg-6 col-xs-6">
				<h2>Total Client Hours</h2>
				<table class="table table-condensed table-striped">
				<tr>
					<th>Client</th>
					<th>Hours</th>
					<th>Percentage of Monthly Hours</th>
				</tr>
				<cfoutput query="qryClientGroupedLogs">
				<tr>
					<td>#AxoSoftClient#</td>
					<td>#NumberFormat(totalhours,"9.99")#</td>
					<td>#NumberFormat((totalhours/local.totalHours)*100,"9.99")#%</td>
				</tr>
				</cfoutput>
				<tr>
					<td><strong>Total Hours:</strong></td>
					<td colspan="2" class="left"><cfoutput>#NumberFormat(local.totalHours,"9.99")#</cfoutput></td>
				</tr>
				</table>
			</div>
			<div class="col-sm-6 col-md-6 col-lg-6 col-xs-6">
				<canvas id="chartcanvas" name="chartcanvas" width="100%" height="500" />
				<script type="text/javascript">
					var donutData = [
							<cfloop query="qryClientGroupedLogs">
							{
								title : <cfoutput>"#AxoSoftClient#"</cfoutput>,
								<cfswitch expression="#AxoSoftClient#">
								<cfcase value="AHIC">
								color : "#5cb85c",
								</cfcase>
								<cfcase value="COG">
								color : "#d9534f",
								</cfcase>
								<cfcase value="SBOA">
								color : "#5bc0de",
								</cfcase>
								<cfcase value="HFC">
								color : "#777",
								</cfcase>
								<cfcase value="CLC">
								color : "#f0ad4e",
								</cfcase>
								<cfcase value="SSH">
								color : "#eee",
								</cfcase>
								</cfswitch>
								value : <cfoutput>#NumberFormat(totalhours,"9.99")#</cfoutput>
							}
							<cfif currentRow LT qryClientGroupedLogs.RecordCount>,</cfif>
							</cfloop>
						];
					
					var donutoptions = {
						canvasBorders : false,
						legend : false,
						scaleOverride : false,
						scaleStartValue : null,
						savePng : true,
						savePngOutput : "Save",
						savePngName: "TotalClientHours",
						savePngBackgroundColor : "white",
						annotateDisplay : true,
						inGraphDataShow: true,
						graphTitle : "Total Client Hours",
						responsive: true,
						responsiveMaxHeight: 300,
						maintainAspectRatio: false
					};
					var chartObj = new Chart(document.getElementById("chartcanvas").getContext("2d")).Doughnut(donutData,donutoptions);
				</script>
			</div>
		</div>
		<cfloop query="qryGroupedUsers">
		<cfquery name="qryGroupedLog" dbtype="query">
			SELECT * FROM qryGroupedLogs WHERE username = '#qryGroupedUsers.username#'
		</cfquery>
		<div class="container">
			<div class="col-sm-6 col-md-6 col-lg-6 col-xs-6">
				<h3><cfoutput>#qryGroupedUsers.username# Hours</cfoutput></h3>
				<table class="table table-condensed table-striped">
					<tr>
						<th>Client</th>
						<th>Hours</th>
						<th>Percentage of Monthly Hours</th>
					</tr>
					<cfset local.userTotal = 0>
					<cfloop query="qryGroupedLogs">
						<cfif qryGroupedLogs.username eq qryGroupedUsers.username>
							<cfset local.userTotal = qryGroupedLogs.totalminutes + local.userTotal>
						</cfif>
					</cfloop>
					<cfloop query="qryGroupedLogs">
					<cfif qryGroupedLogs.username eq qryGroupedUsers.username>
					<cfoutput>
					<tr>
						<td>#AxoSoftClient#</td>
						<td>#NumberFormat(totalminutes,"9.99")#</td>
						<td>#NumberFormat((totalminutes/local.userTotal)*100,"9.99")#%</td>
					</tr>
					</cfoutput>
					</cfif>
					</cfloop>
					<tr>
						<td><strong>Total Hours:</strong></td>
						<td colspan="2"><cfoutput>#NumberFormat(local.userTotal,"9.99")#</cfoutput></td>
					</tr>
				</table>
			</div>
			<div class="col-sm-6 col-md-6 col-lg-6 col-xs-6">
				<cfset local.username = ReplaceNoCase(qryGroupedUsers.username," ","_","all")>
				<cfoutput><canvas id="#local.username#" name="#local.username#" width="100%" height="300" /></cfoutput>
				<script type="text/javascript">
					var donutData = [
							<cfloop query="qryGroupedLog">
							{
								title : <cfoutput>"#AxoSoftClient#"</cfoutput>,
								<cfswitch expression="#AxoSoftClient#">
								<cfcase value="AHIC">
								color : "#5cb85c",
								</cfcase>
								<cfcase value="COG">
								color : "#d9534f",
								</cfcase>
								<cfcase value="SBOA">
								color : "#5bc0de",
								</cfcase>
								<cfcase value="HFC">
								color : "#777",
								</cfcase>
								<cfcase value="CLC">
								color : "#f0ad4e",
								</cfcase>
								<cfcase value="SSH">
								color : "#eee",
								</cfcase>
								</cfswitch>
								value : <cfoutput>#NumberFormat(totalminutes,"9.99")#</cfoutput>
							}
							<cfif currentRow LT qryGroupedLog.RecordCount>,</cfif>
							</cfloop>
						];
					
					var donutoptions = {
						canvasBorders : false,
						legend : false,
						scaleOverride : false,
						scaleStartValue : null,
						savePng : true,
						savePngOutput : "Save",
						savePngName: "<cfoutput>Total#local.username#Hours</cfoutput>",
						savePngBackgroundColor : "white",
						annotateDisplay : true,
						inGraphDataShow: true,
						graphTitle : "Total Hours for <cfoutput>#qryGroupedUsers.username#</cfoutput>",
						responsive: true,
						responsiveMaxHeight: 300,
						maintainAspectRatio: false
					};
					var chartObj = new Chart(document.getElementById("<cfoutput>#local.username#</cfoutput>").getContext("2d")).Doughnut(donutData,donutoptions);
				</script>
			</div>
		</div>
		</cfloop>
	</body>
</html>