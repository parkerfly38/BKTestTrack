<cfcomponent>
	
	<!--- dashboard charting --->
	
	<cffunction name="HubChart" access="remote" output="true" httpmethod="POST">
		<cfargument name="projectid" required="false" default="0">
		<cfquery name="qryName" dbtype="hql">
			FROM TTestProject
			WHERE id = <cfqueryparam value="#arguments.projectid#">
		</cfquery>
		<div id="topcontent" class="panel panel-default">
		<div class="panel-heading" id="activitytitle">#qryName[1].getProjectTitle()#</div>
		<div class="panel-body">
		<cfstoredproc procedure="PReturnTestResultCounts">
			<cfprocparam cfsqltype="cf_sql_int" value="#arguments.projectid#">
			<cfprocresult name="qryCounts" />
		</cfstoredproc>
		<cfscript>
			local.TotalPassedCount = 0;
			local.TotalFailedCount = 0;
			local.TotalUntestedCount = 0;
			local.TotalBlockedCount = 0;
			local.TotalRetestCount = 0;
		</cfscript>
		<cfloop query="qryCounts">
			<cfset local.TotalPassedCount = local.TotalPassedCount + PassedCount />
			<cfset local.TotalFailedCount = local.TotalFailedCount + FailedCount />
			<cfset local.TotalUntestedCount = local.TotalUntestedCount + UntestedCount />
			<cfset local.TotalBlockedCount = local.TotalBlockedCount + BlockedCount />
			<cfset local.TotalRetestCount = local.TotalRetestCount + RetestCount />
			
		</cfloop>
		<cfset local.TotalCount = local.TotalBlockedCount + local.TotalFailedCount + local.TotalPassedCount + local.TotalRetestCount + local.TotalUntestedCount/>
		<cfset local.PassedPercent = (local.TotalPassedCount / local.TotalCount) * 100 />
		<cfset local.FailedPercent = (local.TotalFailedCount / local.TotalCount) * 100>
		<cfset local.UntestedPercent = (local.TotalUntestedCount / local.TotalCount) * 100>
		<cfset local.BlockedPercent = (local.TotalBlockedCount / local.TotalCount) * 100>
		<cfset local.RetestPercent = (local.TotalRetestCount / local.TotalCount) * 100> 
		<div class="col-xs-9 col-sm-9 col-md-9 col-lg-9"><canvas id="chartcanvas" name="chartcanvas" width="100%" height="300" /></div>
		<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3">
			<p><span class="label label-success">#local.TotalPassedCount# Passed</span><br />#NumberFormat(local.PassedPercent,"0.00")#% set to Passed</p>
			<p><span class="label label-default">#local.TotalBlockedCount# Blocked</span><br />#NumberFormat(local.BlockedPercent,"0.00")#% set to Blocked</p>
			<p><span class="label label-warning">#local.TotalRetestCount# Retest</span><br />#NumberFormat(local.RetestPercent,"0.00")#% set to Retest</p>
			<p><span class="label label-danger">#local.TotalFailedCount# Failed</span><br />#NumberFormat(local.FailedPercent,"0.00")#% set to Failed</p>
			<p><span class="label label-info">#local.TotalUntestedCount# Untested</span><br />#NumberFormat(local.UntestedPercent,"0.00")#% set to Untested</p>
		</div>
		<script type="text/javascript">
			var barData = {
						labels : [#Replace(QuotedValueList(qryCounts.DateTested,","),"/","\/","all")#],
						datasets : [
							{
								title : "Passed",
								strokeColor : "##5cb85c",
								data : [#ValueList(qryCounts.PassedCount,",")#]
							},
							{
								title : "Failed",
								strokeColor : "##d9534f",
							    data : [#ValueList(qryCounts.FailedCount,",")#]
							},
							{
								title : "Untested",
								strokeColor : "##5bc0de",
								data : [#ValueList(qryCounts.UntestedCount,",")#]
							},
							{
								title : "Blocked",
								strokeColor : "##777",
								data : [#ValueList(qryCounts.BlockedCount,",")#]
							},
							{
								title : "Retest",
								strokeColor : "##f0ad4e",
								data : [#ValueList(qryCounts.RetestCount,",")#]
							}
						]
					}
					var options = {
						canvasBorders : false,
						legend : false,
						yAxisMinimumInterval : 1,
						scaleStartValue : 0,
						xAxisLabel : "Date",
						yAxisLabel : "Count",
						savePng : true,
						savePngOutput : "Save",
						savePngName: "Last 14 Days",
						savePngBackgroundColor : "white",
						annotateDisplay : true,
						graphTitle: "Testing Activity - 14 Days",
						responsive: true,
						responsiveMaxHeight: 300,
						maintainAspectRatio: false
					};
					var chartObj = new Chart(document.getElementById("chartcanvas").getContext("2d")).Line(barData,options);
					// -->
				</script>
			</div>
			</div>
	</cffunction>
	
	<cffunction name="HubDonutChart" access="remote" output="true" httpmethod="POST">
		<cfargument name="projectid" required="false" default="0">
		<cfquery name="qryName" dbtype="hql">
			FROM TTestProject
			WHERE id = <cfqueryparam value="#arguments.projectid#">
		</cfquery>
		<div id="topcontent" class="panel panel-default">
		<div class="panel-heading" id="activitytitle">#qryName[1].getProjectTitle()#</div>
		<div class="panel-body">
		<cfstoredproc procedure="PReturnTestResultCountsTotal">
			<cfprocresult name="qryCounts" />
		</cfstoredproc>
		<div class="col-xs-9 col-sm-9 col-md-9 col-lg-9"><canvas id="chartcanvas" name="chartcanvas" width="100%" height="300" /></div>
		<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3">
			<cfset local.totals = 0>
			<cfloop query="qryCounts">
				<cfset local.totals += ItemCount>
			</cfloop>
			<cfloop query="qryCounts">
			<p><span class="label #returnBSLabelStyle(Status)#">#ItemCount# #Status#</span><br />#NumberFormat((ItemCount / local.totals) * 100,"0.0")#% set to #Status#</p>
			</cfloop>
		</div>
		<script type="text/javascript">
			var donutData = [
							<cfloop query="qryCounts">
							{
								title : "#Status#",
								<cfswitch expression="#Status#">
								<cfcase value="Passed">
								color : "##5cb85c",
								</cfcase>
								<cfcase value="Failed">
								color : "##d9534f",
								</cfcase>
								<cfcase value="Untested">
								color : "##5bc0de",
								</cfcase>
								<cfcase value="Blocked">
								color : "##777",
								</cfcase>
								<cfcase value="Retest">
								color : "##f0ad4e",
								</cfcase>
								</cfswitch>
								value : #ItemCount#
							}
							<cfif currentRow LT qryCounts.RecordCount>,</cfif>
							</cfloop>
						];
					
					var donutoptions = {
						canvasBorders : false,
						legend : false,
						scaleOverride : false,
						scaleStartValue : null,
						savePng : true,
						savePngOutput : "Save",
						savePngName: "System Totals",
						savePngBackgroundColor : "white",
						annotateDisplay : true,
						inGraphDataShow: true,
						graphTitle : "System Totals",
						responsive: true,
						responsiveMaxHeight: 300,
						maintainAspectRatio: false
					};
					var chartObj = new Chart(document.getElementById("chartcanvas").getContext("2d")).Doughnut(donutData,donutoptions);
				</script>
				</div>
			</div>
	</cffunction>
	
	<cffunction name="AllProjectsChart" access="remote" output="true">
		<cfstoredproc procedure="PGeneralActivityByProject">
			<cfprocresult name="qryGeneralActivity">
		</cfstoredproc>
		<cfset arrColor = ['red','green','blue','yellow','gray','black','pink','brown'] />
		<div class="panel panel-default">
		<div class="panel-heading" id="activitytitle">All Projects</div>
		<div class="panel-body">
			<div class="col-xs-9 col-sm-9 col-md-9 col-lg-9"><canvas id="chartcanvas" name="chartcanvas" width="100%" height="300" /></div>
			<div class="col-xs-3 col-sm-3 col-md-3 col-lg-3">
				<cfif qryGeneralActivity.RecordCount eq 0>
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 text-right" >
						<div style='width:32px;height:32px;background-color:##777;border: 1px solid ##666;float:right;'>&nbsp;</div>
					</div>
					<div class="col-xs-8 col sm-8 col-md-8, col-lg-8 text-left" style="padding-left:0px;">
						<strong>No project activity</strong>
					</div>
					<div class="clearfix">&nbsp;</div>
				</cfif>
				<cfloop query="qryGeneralActivity">
					<!--- generate random color for each row, captured in array for later use--->
					<!---<cfset arrColor[currentRow] = FormatBaseN((RandRange(0,255)+102)/2, 16) & FormatBaseN((RandRange(0,255)+205)/2, 16) & FormatBaseN((RandRange(0,255)+170)/2, 16)>--->
					<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 text-right">
						<div style='width:32px;height:32px;background-color:###qryGeneralActivity.Color#;border: 1px solid ##666;float:right;'>&nbsp;</div>
					</div>
					<div class="col-xs-8 col sm-8 col-md-8, col-lg-8 text-left" style="padding-left:0px;">
						<strong>#ProjectTitle#</strong>
					</div>
					<div class="clearfix">&nbsp;</div>
				</cfloop>
			</div>
		</div>
		<cfset local.cols = ListDeleteAt(ArrayToList(qryGeneralActivity.getColumnNames()),1,",")>
		<cfset local.cols = ListDeleteAt(local.cols,1,",")> <!--- do this twice to purge the color column value, too --->
		<script type="text/javascript">
			var barData = {
						labels : [<cfloop list="#cols#" index="col">"#col#"<cfif ListFindNoCase(cols,col,",") LT ListLen(cols)>,</cfif></cfloop>],
						datasets : [
							<cfif qryGeneralActivity.RecordCount eq 0>
							{
								title : "",
								strokeColor: "##777",
								data: [0]
							}
							</cfif>
							<cfloop query="qryGeneralActivity">
							{
								title : "#qryGeneralActivity.ProjectTitle#",
								strokeColor : "###qryGeneralActivity.Color#",
								data : [<cfloop list="#cols#" index="col">#qryGeneralActivity[col][currentRow]#<cfif ListFindNoCase(cols,col,",") LT ListLen(cols)>,</cfif></cfloop>]
							}
							<cfif currentRow NEQ qryGeneralActivity.RecordCount>,</cfif>
							</cfloop>
						]
					}
					var options = {
						canvasBorders : false,
						legend : false,
						yAxisMinimumInterval : 8,
						scaleStartValue : 0,
						//xAxisLabel : "Date",
						//yAxisLabel : "Count",
						savePng : true,
						savePngOutput : "Save",
						savePngName: "Last 14 Days",
						savePngBackgroundColor : "white",
						responsive: true,
						responsiveMaxHeight: 300,
						maintainAspectRatio: false,
						annotateDisplay : true //,
						//graphTitle: "Testing Activity - 14 Days"
					};
					var chartObj = new Chart(document.getElementById("chartcanvas").getContext("2d")).Line(barData,options);
		</script>
		</div>
		</div>
	</cffunction>
	
	<cffunction name="chartList" access="remote" returnformat="JSON" returntype="string">
		<cfset var data="" />
		<cfset var result= ArrayNew(1) />
				
		<cfscript>
			hubChart = StructNew();
			hubchart["opticon"] = "fa-line-chart";
			hubChart["optlabel"] = "Activity (14 days)";
			hubChart["optvalue"] = "HubChart";
			ArrayAppend(result,hubChart);
			hubPieChart = StructNew();
			hubPieChart["opticon"] = "fa-pie-chart";
			hubPieChart["optlabel"] = "System Activity";
			hubPieChart["optvalue"] = "HubDonutChart";
			ArrayAppend(result,hubPieChart);
		</cfscript>
		<cfreturn serializeJSON(result) />
	</cffunction>

	<!--- other non report/chart sections that return rich content --->
	
	<cffunction name="Actions" access="remote" output="true">
		<cfif !StructKeyExists(Session,"ProjectID")>
			<cfexit>
		</cfif>
		<cfquery name="qryProject" dbtype="hql">
			FROM TTestProject
			WHERE id = <cfqueryparam value="#Session.ProjectID#">
		</cfquery>
		<div id="panel-actions" class="panel panel-default">
			<div class="panel-heading"><i class="fa fa-rocket"></i> Actions</div>
			<div class="panel-body">
					<div class="row rowoffset">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 text-right" style="padding-right:0px;"><h1 style="margin:0px;"><span class="label label-primary" style="padding:5px;"><i class="fa fa-map-marker fa-fw"></i></span></h1></div>
					<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10"><span style="font-weight:bold;">Milestones</span><br /><a href="##" id="lnkViewMilestones">View All</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="##" id="lnkAddMilestone">Add</a></div>
					</div>
					<div class="row rowoffset">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 text-right" style="padding-right:0px;"><h1 style="margin:0px;"><span class="label label-primary" style="padding:5px;"><i class="tests fa fa-tachometer fa-fw"></i></span></h1></div>
					<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10"><span style="font-weight: bold;">Tests</span><br /><a href="##" id="lnkViewTests">View All</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="##" id="lnkAddTest">Add</a></div>
					</div>
					<cfif qryProject[1].getRepositoryType() eq 2>
					<div class="row rowoffset">
						<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 text-right" style="padding-right: 0xp;"><h1 style="margin:0px;"><span class="label label-primary" style="padding:5px;"><i class="tests fa fa-suitcase fa-fw"></i></span></h1></div>
						<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10"><span style="font-weight: bold;">Test Scenarios</span><br /><a href="##" id="lnkViewTestScenarios">View All</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="##" id="lnkAddTestScenario">Add</a></i></span></h1></div>
					</div>
					</cfif>
					<!---<div class="row rowwoffset">
					<div class="col-xs-2 col-sm-2 col-md-2 col-lg-2 text-right" style="padding-right:0px;"><h1 style="margin:0px;"><span class="label label-primary" style="padding:5px;"><i class="projects fa fa-wrench fa-fw"></i></span></h1></div>
					<div class="col-xs-10 col-sm-10 col-md-10 col-lg-10"><span style="font-weight: bold;">Projects</span><br /><a href="##" id="lnkViewProjects">View All</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="##" id="lnkAddProject">Add</a></div>
					</div>--->
				</div>
			</div>
		</div>
	</cffunction>
	
	<cffunction name="assignedTestsGrid" access="remote" output="true">
		<cfargument name="userid" type="numeric" required="true">
		<cfargument name="page" type="numeric" required="true" default="1">
		<cfargument name="pageSize" type="numeric" required="true" default="10">
		<cfif (!StructKeyExists(SESSION,"Loggedin") || !Session.Loggedin)>
			<cfexit>
		</cfif>
		<cfscript>
			objData = createObject("component","Data");
			arrTests = objData.getAssignedTestCasesByTesterId(arguments.userid);
			local.testCount = ArrayLen(arrTests);
			arrTestsForGrid =  ormExecuteQuery("FROM TTestCaseHistory WHERE TesterID = :testerid AND Action = 'Assigned' AND DateActionClosed IS NULL",{testerid=arguments.userid},{maxResults=arguments.pageSize,offset=arguments.page-1});
			local.pageCount = Round(local.testCount / arguments.pageSize);
		</cfscript>
		<div class="panel panel-default">
		<div class="panel-heading">Tests Assigned To You</div>
		<div class="panel-body">
		<cfif local.pageCount gt 1>
			<cfset local.nav='<div id="paging_nav">'>
			<cfif arguments.page gt 1><cfset local.nav &= '<a href="" id="paging_nav_previous">'></cfif>
			<cfset local.nav &= 'Previous'>
			<cfif arguments.page gt 1><cfset local.nav &= '</a>'></cfif>
			<cfloop from="1" to="#local.pageCount#" index="index">
				<cfset local.nav &= '<a href="" class="paging_nav_a">' & #index# >
			</cfloop>
			<cfif arguments.page lt local.pageCount><cfset local.nav &= '<a href="" id="paging_nav_next">'></cfif>
			<cfset local.nav &= "Next">
			<cfif arguments.page lt local.pageCount><cfset local.nav &= "</a>"></cfif>
			<cfset local.nav &="</div>">
			<cfoutput>#local.nav#</cfoutput>
		</cfif>
		<table class="table table-striped">
		<tbody>
			
		<cfloop array="#arrTestsForGrid#" index="test">
			<cfquery dbtype="hql" name="case">
				FROM TTestCase t WHERE t.id = <cfqueryparam value="#test.getCaseID()#">
			</cfquery>
			<cfloop array="#case#" index="i">
				<cfquery dbtype="hql" name="latestresult" ormoptions=#{maxResults=1}#>
					FROM TTestResult as a
					WHERE a.TestCaseID = <cfqueryparam value="#i.getID()#">
					ORDER BY a.id DESC
				</cfquery>
				
				<cfoutput>
					<tr>
					<td class="right">
						<span class="label #returnBSLabelStyle(latestresult[1].getTTestStatus().getStatus())#">#latestresult[1].getTTestStatus().getStatus()#</span>
					</td>
					<td>#i.getTestTitle()#</td>
					<td>Last tested by <span style="font-weight:bold;">#latestresult[1].getTTestTester().getUserName()#</span></td>
					</tr>
				</cfoutput>
			</cfloop>
		</cfloop>
		</tbody>
		</table>
		</div>
		</div>
	</cffunction>

	<cffunction name="mostRecentTests" access="remote" output="true">
		<cfif (!StructKeyExists(SESSION,"Loggedin") || !Session.Loggedin)>
			<cfexit>
		</cfif>
		<cfquery name="recenttests" dbtype="hql" ormoptions=#{maxResults=10}#>
			FROM TTestResult
		</cfquery>
		
		<div class="clearfix"></div>	
		<div class="panel panel-default">
		<div class="panel-heading">Activity</div>
		<div class="panel-body">
		<table class="table table-striped table-condensed">
			<thead>
				<tr>
					<th>Test Status</th>
					<th>Test Title</th>
					<th>Last Tester</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
		<cfloop array="#recenttests#" index="test">
			<cfquery name="caseinfo" dbtype="hql" ormoptions=#{maxResults=1}#>
				FROM TTestCase WHERE id = <cfqueryparam value="#test.getTestCaseID()#">
			</cfquery>
			<tr><cfoutput>
				<td class="right"><h4 style="margin:0px;"><span class="label #returnBSLabelStyle(test.getTTestStatus().getStatus())#">#test.getTTestStatus().getStatus()#</span></h4></td>
				<td>#caseinfo[1].getTestTitle()#</td>
				<td>Tested by <span style="font-weight: bold;">#test.getTTestTester().getUserName()#</span></td>
				<td><a href="##" class="testcaseeditlink" editid="#test.getTestCaseID()#">Edit</a>&nbsp;&nbsp;</td>
				</cfoutput>
			</tr>
		</cfloop>
			</tbody>
		</table>
		</div>
		</div>
	</cffunction>

	<cffunction name="getMilestones" access="remote" output="true" httpmethod="post">
		<cfargument name="projectid" required="true">
		<cfif (!StructKeyExists(SESSION,"Loggedin") || !Session.Loggedin)>
			<cfexit>
		</cfif>
		<cfquery name="qryMilestones" dbtype="hql">
			FROM TTestMilestones
			WHERE ProjectID = <cfqueryparam value="#arguments.projectid#">
			AND DueOn >= <cfqueryparam value="#DateFormat(now(),'yyyy-mm-dd')#">
		</cfquery>
		<div id="panelmilestones" class="col-xs-6 col-sm-6 col-md-6 col-lg-6" style="padding-left:0px;">
			<div class="panel panel-default">
				<div class="panel-heading">Milestones</div>
				<div class="panel-body">
					<table class="table table-striped table-condensed">
						<thead>
							<th>Milestone</th>
							<th>Due On</th>
						</thead>
						<tbody>
							<cfloop array="#qryMilestones#" index="milestone">
							<tr>
								<td>#milestone.getMilestone()#</td>
								<td>#milestone.getDueOn()#</td>
							</tr>
							</cfloop>
						</tbody>
					</table>
				</div>
			</div>
		</div>			
	</cffunction>
	
	<cffunction name="getTestScenarios" access="remote" output="true" httpmethod="post">
		<cfargument name="projectid" required="true">
		<cfif (!StructKeyExists(SESSION,"Loggedin") || !Session.Loggedin)>
			<cfexit>
		</cfif>
		<div id="paneltestscenarios" class="col-xs-6 col-sm-6 col-md-6 col-lg-6" style="padding-right:0px;">
			<div class="panel panel-default">
				<div class="panel-heading">Test Scenario Status</div>
				<div class="panel-body">
					<table class="table table-striped table-condensed">
						<thead>
							<th>Test Scenario</th>
							<th>Test Date</th>
							<th>Run By</th>
						</thead>
						<tbody>
							<tr><td></td><td></td><td></td></tr>
							
							<tr><td></td><td></td><td></td></tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</cffunction>
	
	<!--- JSON and single value functions --->
		
	<cffunction name="TodosBySection" access="remote" returnformat="JSON" returntype="string">
		<cfstoredproc procedure="PTodos">
			<cfprocresult name="qryTodos" />
		</cfstoredproc>
		<cfreturn serializeJSON(qryTodos) />
	</cffunction>
	
	<cffunction name="MilestonesJSON" access="remote" returnformat="JSON" returntype="string">
		<cfscript>
			objData = CreateObject("component","Data");
			arrMilestones = objData.getAllMilestones();
			return serializeJSON(arrMilestones);
		</cfscript>
	</cffunction>
	
	<cffunction name="LinksJSON" access="remote" returnformat="JSON" returntype="string">
		<cfscript>
			objData = createObject("component","Data");
			arrLinks = objData.getAllLinks();
			return serializeJSON(arrLinks);
		</cfscript>
	</cffunction>
	
	<cffunction name="allProjectsCount" access="remote" returnformat="JSON" returntype="string">
		<cfscript>
			objData = createObject("component","Data");
			arrProjects = objData.getAllProjects();
			returnData = StructNew();
			returnData["TotalProjects"] = IsNull(ArrayLen(arrProjects)) ? 0 : ArrayLen(arrProjects);
		</cfscript>
		<!--- active projects --->
		<cfquery name="qryActiveProjects" dbtype="hql">
			FROM TTestProject
			WHERE ProjectStartDate <= <cfqueryparam value="#now()#">
			AND Closed = 0
		</cfquery>
		<cfset returnData["ActiveProjects"] = arrayLen(qryActiveProjects) >
		<!--- closed projects --->
		<cfquery name="qryCompletedProjects" dbtype="hql">
			FROM TTestProject
			WHERE Closed = 1
		</cfquery>
		<cfset returnData["CompletedProjects"] = arrayLen(qryCompletedProjects)>
		<cfreturn serializeJSON(returnData)>
	</cffunction>
	
	<cffunction name="allProjectsJSON" access="remote" returnformat="JSON" returntype="string">
		<cfargument name="includeInactiveProjects" type="boolean" required="false" default="false">
		<cfif (!StructKeyExists(SESSION,"Loggedin") || !Session.Loggedin)>
			<cfexit>
		</cfif>
		<cfquery name="qryActiveProjects" dbtype="hql">
			FROM TTestProject
			<CFIF !includeInactiveProjects>WHERE Closed = false</CFIF>
			ORDER BY ProjectStartDate
		</cfquery>
		<cfreturn serializeJSON(qryActiveProjects)>
	</cffunction>
	
	<cffunction name="assignedTestsCount" access="remote" returntype="numeric">
		<cfargument name="userid" type="numeric">
		<cfscript>
			objData = createObject("component","Data");
			arrTests = objData.getAssignedTestCasesByTesterId(arguments.userid);
			return ArrayLen(arrTests);
		</cfscript>
	</cffunction>
	
	<cffunction name="setSessionProject" access="remote" returntype="void" httpmethod="POST">
		<cfargument name="projectid" required="true" type="numeric">		
		<cfif (!StructKeyExists(SESSION,"Loggedin") || !Session.Loggedin)>
			<cfexit>
		</cfif>
		<cfset Session.ProjectID = arguments.projectid>
	</cffunction>
	
	<cffunction name="removeSessionProject" access="remote" returntype="void" httpmethod="post">
		<cfif (!StructKeyExists(Session,"LoggedIn") || !Session.Loggedin)>
			<cfexit>
		</cfif>
		<cfset StructDelete(Session,"ProjectID")>
	</cffunction>
	
	<cffunction name="returnBSLabelStyle" access="private" returntype="string">
		<cfargument name="labelExpression" required="true">
		<cfset local.labelstyle = "">
		<cfswitch expression="#arguments.labelExpression#">
				<cfcase value="Passed">
					<cfset local.labelstyle = "label-success">
				</cfcase>
				<cfcase value="Failed">
					<cfset local.labelstyle = "label-danger">
				</cfcase>
				<cfcase value="Blocked">
					<cfset local.labelstyle = "label-default">
				</cfcase>
				<cfcase value="Untested">
					<cfset local.labelstyle = "label-info">
				</cfcase>
				<cfcase value="Retest">
					<cfset local.labelstyle = "label-warning">
				</cfcase>
				<cfdefaultcase>
					<cfset local.labelstyle = "label-default">
				</cfdefaultcase>
			</cfswitch>
		<cfreturn local.labelstyle>
	</cffunction>
</cfcomponent>