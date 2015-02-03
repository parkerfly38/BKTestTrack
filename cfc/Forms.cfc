<cfcomponent>

	<!--- form building --->
	<cffunction name="getTestEditForm" access="remote" output="true">
		<cfargument name="testcaseid" type="numeric" required="true">
		<cfif (!StructKeyExists(SESSION,"Loggedin") || !Session.Loggedin)>
			login
			<cfexit>
		</cfif>
		<!--- time to get our testcase ---> 
		<cfquery name="qryTestCase" dbtype="hql">
			FROM TTestCase where id = <cfqueryparam value="#arguments.testcaseid#">
		</cfquery>
		<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
			<div class="form-group">
				<label for="txtTestTitle">Title:</label><br />
				<input type="text" name="txtTestTitle" id="txtTestTitle" value="#qryTestCase[1].getTestTitle()#" />
			</div>
			<div class="form-group">
				<label for="txtTestDetails">Test Details</label><br />
				<textarea name="txtTestDetails" id="txtTestDetails">#qryTestCase[1].getTestDetails()#</textarea>
			</div>
		</div>
		<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
			<div class="panel panel-default">
				<div class="panel-heading"></div>
			</div>
		</div>
	</cffunction>
	
	<cffunction name="TestResultForm" access="remote" output="true">
		<cfargument name="testcaseids" required="true">
		<cfargument name="scenarioid">
			<cfif !(StructKeyExists(Session,"ProjectID"))>
			<cfexit>
		</cfif>
		<cfif !(StructKeyExists(Session,"LoggedIn")) || !Session.LoggedIn>
			<cfexit>
		</cfif>
		<cfset arrStatus = EntityLoad("TTestStatus")>
		<cfset arrTesters = EntityLoad("TTestTester")>
		<script type="text/javascript">
			$(document).ready(function() {
				$(".selectpicker").selectpicker();
				$(document).off("click","##btnClose");
				$(document).on("click","##btnClose",function(event) {
					event.preventDefault();					
					if (confirm("Are you sure you want to close without saving your test results?"))
					{
						$("##largeModal").modal('hide');
					}
				});
				$(document).off("click","##btnSave");
				$(document).on("click","##btnSave",function(event) {
					event.preventDefault();
					$.ajax({
						url: "CFC/forms.cfc?method=saveTestResult",
						type: "POST",
						data: {
							caseidslist : allTests.join(),
							statusid : $("##ddlStatus").val(),
							testerid : $("##ddlTester").val(),
							version : $("##txtVersion").val(),
							elapsedtime : $("##txtElapsedTime").val(),
							comment : $("##txtComment").val(),
							defects : $("##txtDefects").val()
						}
					}).done(function(data) {
						if ( data == "true" )
						{
							$("##largeModal").modal('hide');
							$("##topcontent").removeClass("panel").removeClass("panel-default");
							$("##topcontent").load("cfc/Dashboard.cfc?method=TestScenarioHub&scenarioid=#arguments.scenarioid#");
							$("##midrow").empty();
							$("##activitypanel").remove();
							$("##lnkReturnToProject").attr("pjid",#session.projectid#);
							$("##lnkReturnToProject").show();
							$("##createreportpanel").remove();
						} else {
							alert("There was an error with your save.  Please contact system administrator.");
						}
					});
				});
			});
		</script>
		<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
			<div class="form-group">
				<label for="ddlStatus">Status</label><br />
				<select name="ddlStatus" id="ddlStatus" class="selectpicker">
					<cfloop array="#arrStatus#" index="status">
					<option value="#status.getId()#" data-content="<span class='label #returnBSLabelStyle(status.getStatus())#'>#status.getStatus()#</span>">#status.getStatus()#</option>
					</cfloop>
				</select>
				<p class="help-block">Set the status of tests.  Did it pass, or fail?</p>
				<label for="txtComment">Comment</label>
				<textarea name="txtComment" id="txtComment" rows="5" class="form-control"></textarea>
				<p class="help-block">Describe your results or set of results.</p>
				<p><a href="##" id="addAttachment" class="btn btn-info btn-xs"><i class="fa fa-paperclip"></i> Upload Attachment</a></p>
			</div>
		</div>
		<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
			<div class="form-group">
				<label for="ddlTester">Assigned to</label>
				<select name="ddlTester" id="ddlTester" class="selectpicker" data-style="btn-info">
					
						<option value="0">Unassigned</option>
						<option data-divider="true"></option>
					<optgroup label="Users">
					<cfloop array="#arrTesters#" index="tester">
					<option value="#tester.getId()#">#tester.getUserName()#</option>
					</cfloop>
					</optgroup>
				</select>
				<p class="help-block">Assign to another user, or unassign.</p>
				<label for="txtVersion">Version</label>
				<input type="text" id="txtVersion" name="txtVersion" class="form-control" />
				<p class="help-block">Version tested against, if applicable.</p>
				<label for="txtElapsedTime">Elapsed Time</label>
				<input type="text" id="txtElapsedTime" name="txtElapsedTime" class="form-control" />
				<label for="txtDefects">Defects</label>
				<input type="text" id="txtDefects" name="txtDefects" class="form-control" />
				<p class="help-block">List of AxoSoft bug ids capturing defects for resolution.</p>
			</div>
		</div>
	</cffunction>
	
	<cffunction name="TestCaseForm" access="remote" output="true">
		<cfargument name="testcaseid" required="false" default="0" type="numeric">
		<cfif !(StructKeyExists(Session,"ProjectID"))>
			<cfexit>
		</cfif>
		<cfif !(StructKeyExists(Session,"LoggedIn")) || !Session.LoggedIn>
			login
			<cfexit>
		</cfif>
		<cfif arguments.testcaseid gt 0>
			<cfset arrTestCase = EntityLoadByPK("TTestCase",arguments.testcaseid)>
		<cfelse>
			<cfset arrTestCase = EntityNew("TTestCase")>
			<cfset arrTestCase.setId(0)>
			<cfset arrTestCase.setPriorityId(0)>
			<cfset arrTestCase.setTypeId(0)>
		</cfif>
		<script type="text/javascript">
			$(document).ready(function() {
				$(".selectpicker").selectpicker();
				$(".datetime").datepicker({
					format:"mm/dd/yyyy",
					todayHighlight: true,
					autoclose:true
				});
				$(document).off("click","##btnClose");
				$(document).on("click","##btnClose",function(event) {
					event.preventDefault();					
					if (confirm("Are you sure you want to close without saving your test case?"))
					{
						$("##largeModal").modal('hide');
					}
				});
				$(document).off("click","##btnSave");
				$(document).on("click","##btnSave",function(event) {
					event.preventDefault();
					$.ajax({
						url: "CFC/forms.cfc?method=saveTestCase",
						type: "POST",
						data: {
							id : "#arguments.testcaseid#",
							TestTitle : $("##txtTestTitle").val(),
							TestDetails : $("##txtTestDetails").val(),
							PriorityId : $("##ddlPriorityId").val(),
							TypeId : $("##ddlTypeId").val(),
							ProjectID : "#Session.ProjectID#",
							Preconditions : $("##txtPreconditions").val(),
							Steps : $("##txtSteps").val(),
							ExpectedResult : $("##txtExpectedResult").val(),
							MilestoneId : "0",
							Estimate : $("##txtEstimate").val()
						}
					}).done(function(data) {
						if ( data == "true" )
						{
							$("##largeModal").modal('hide');
							if ($("##panelalltestcases").length == 0) 
							{
								/* do nothing */
							} else {
								$("##panelalltestcases").remove();
								$("##topcontent").load("cfc/Dashboard.cfc?method=AllTests");	
							}
						} else {
							alert("There was an error with your save.  Please contact system administrator.");
						}
					});
				});
			});
		</script>
		<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
		<div class="form-group">
			<label for="txtTestTitle">Title</label>
			<input type="text" name="txtTestTitle" id="txtTestTitle" value="#arrTestCase.getTestTitle()#" class="form-control" />
			<label for="txtPreconditions">Preconditions and Assumptions</label>
			<textarea class="form-control" rows="5" id="txtPreconditions" name="txtPreconditions">#arrTestCase.getPreconditions()#</textarea>
			<p class="help-block">Anything that must be done prior to executing this test.  You can reference other test cases using TC + Number, like TC1 for test case 1.</p>
			<label for="txtSteps">Performance Steps</label>
			<textarea class="form-control" rows="5" id="txtSteps" name="txtSteps">#arrTestCase.getSteps()#</textarea>
			<p class="help-block">These are the steps you'll take to perform the test.  If this is to be a scripted test, annotate that here.</p>
			<label for="txtExpectedResult">Expected Result</label>
			<textarea class="form-control" rows="5" id="txtExpectedResult" name="txtExpectedResult">#arrTestCase.getExpectedResult()#</textarea>
			<p class="help-block">Describe the desired conditions that should return from testing.</p> 
		</div>
		</div>
		<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
			<div class="form-group">
				<label for="ddlPriorityId">Priority</label>
				<cfset arrPriority = EntityLoad("TTestPriorityType",{},"PriorityRank DESC")>
				<select class="form-control selectpicker" id="ddlPriorityId" name="ddPriorityId" data-style="btn-info">
					<option value="0" <cfif arrTestCase.getPriorityId() eq 0>selected</cfif>>Select a priority</option>
					<cfloop array="#arrPriority#" index="priority">
					<option value="#priority.getId()#" <cfif arrTestCase.getPriorityId() eq priority.getId()>selected</cfif>>#priority.getPriorityName()#</option>
					</cfloop>
				</select>
				<label for="ddlTypeId">Type of Test</label>
				<cfset arrTypes = EntityLoad("TTestType") >
				<select class="form-control selectpicker" id="ddlTypeId" name="ddlTypeId" data-style="btn-info">
					<option value="0" <cfif arrTestCase.getTypeId() eq 0>selected</cfif>>Select a Test Type</option>
					<cfloop array="#arrTypes#" index="type">
					<option value="#type.getId()#" <Cfif arrTestCase.getTypeId() eq type.getId()>selected</cfif>>#type.getType()#</option>
					</cfloop>
				</select>	
				<label for="txtEstimate">Estimated Time (in hours)</label>
				<input type="text" class="form-control" name="txtEstimate" id="txtEstimate" value="#arrTestCase.getEstimate()#" />
				<label for="txtTestDetails">References</label>
				<input type="text" class="form-control" name="txtTestDetails" id="txtTestDetails" value="#arrTestCase.getTestDetails()#"  />
				<p class="help-block">Insert related AxoSoft ids here, ex: <em>COG00050</em>.</p>
			</div>
		</div>
			 
	</cffunction>
	
	<cffunction name="MilestoneForm" access="remote" output="true">
		<cfargument name="milestoneid" required="false" default="0" type="numeric">
		<cfif !(StructKeyExists(Session,"ProjectID"))>
			<cfexit>
		</cfif>
		<cfif !(StructKeyExists(Session,"LoggedIn")) || !Session.LoggedIn>
			login
			<cfexit>
		</cfif>
		<cfif arguments.milestoneid gt 0>
			<cfset arrMilestone = EntityLoadByPK("TTestMilestones",arguments.milestoneid)>
		<cfelse>
			<cfset arrMilestone = EntityNew("TTestMilestones")>
			<cfset arrMilestone.setId(0)>
		</cfif>
		<script type="text/javascript">
			$(document).ready(function() {
				$(".datetime").datepicker({
					format:"mm/dd/yyyy",
					todayHighlight: true,
					autoclose:true
				});
				$(document).off("click","##btnClose");
				$(document).on("click","##btnClose",function(event) {
					event.preventDefault();					
					if (confirm("Are you sure you want to close without saving your milestone?"))
					{
						$("##largeModal").modal('hide');
					}
				});
				$(document).off("click","##btnSave");
				$(document).on("click","##btnSave",function(event) {
					event.preventDefault();
					$.ajax({
						url: "CFC/forms.cfc?method=saveMilestone",
						type: "POST",
						data: {
							id : $("##txtID").val(),
							Milestone : $("##txtMilestone").val(),
							MilestoneDescription : $("##txtMilestoneDescription").val(),
							DueOn : $("##txtDueOn").val(),
							Closed : $("##cbxClosed").is(":checked"),
							ProjectID : '#Session.ProjectID#'
						}
					}).done(function(data) {
						if ( data == "true" )
						{
							$("##largeModal").modal('hide');
							if ( $("##allmilestonespanel").length == 0)
							{
								$("##panelmilestones").remove();
								insertMilestones();
							} else {
								$("##allmilestonespanel").remove();
								$("##topcontent").load("cfc/Dashboard.cfc?method=AllMilestones");
							}
						} else {
							alert("There was an error with your save.  Please contact system administrator.");
						}
					});
				});
			});
		</script>
		<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
			<div class="form-group required">
				<input type="hidden" id="txtID" name="txtID" value="#arrMilestone.getId()#" />
				<label for="txtMilestone">Milestone Name</label>
				<input type="text" id="txtMilestone" name="txtMilestone" value="#arrMilestone.getMilestone()#" class="form-control" />
				<p class="help-block">Ex: <em>Version 3.2 or Internal Beta</em></p>
			</div>
			<div class="form-group">
				<label for="txtMilestoneDescription">Description</label>
				<textarea class="form-control" rows="5" id="txtMilestoneDescription" name="txtMilestoneDescription">#arrMilestone.getMilestoneDescription()#</textarea>
				<p class="help-block">Describe the reason for this milestone, desired endstate upon close.</p>
			</div>
		</div>
		<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
			<div class="form-group required">
				<label for="txtDueOn">Due Date</label>
				<input type="text" id="txtDueOn" name="txtDueOn" value="#arrMilestone.getDueOn()#" class="form-control datetime" />
			</div>
			<cfif arguments.milestoneid GT 0>
			<div class="form-group">
				<div class="control-group">
					<label class="checkbox" for="cbxClosed"><input type="checkbox" name="cbxClosed" id="cbxClosed" value="1"
						<cfif arrMilestone.getClosed()> checked="true"
						</cfif>>Milestone is complete</label>
					<p class="help-block">Shows the milestone as completed on the dashboard and other reports.</p>
				</div>
			</div>
			</cfif>
		</div>
			
	</cffunction>
	
	<cffunction name="TestSectionForm" access="remote" output="true">
		<cfargument name="sectionid" required="false" default="0" type="numeric">
		<cfif !(StructKeyExists(Session,"ProjectID"))>
			<cfreturn>
		</cfif>
		<cfif arguments.sectionid gt 0>
			<cfset arrSections = EntityLoadByPK("TTestProjectTestSection",arguments.sectionid)>
		<cfelse>
			<cfset arrSections = entityNew("TTestProjectTestSection")>
			<cfset arrSections.setId(0)>
			<cfset arrSections.setProjectId(0)>
		</cfif>
		<script type="text/javascript">
			$(document).ready(function() {
				$(document).off("click","##btnSave");
				$(document).on("click","##btnSave",function(event) {
					event.preventDefault();
					$.ajax({
						url: "CFC/forms.cfc?method=saveSection",
						type: "POST",
						data: {
							id : $("##txtID").val(),
							Section : $("##txtSection").val()
						}
					}).done(function(data) {
						if ( data == "true" )
						{
							$("##smallModal").modal('hide');
						} else {
							alert("There was an error with your save.  Please contact system administrator.");
						}
					});
				});		
			});
			</script>
		<div class="form-group required">
				<input type="hidden" name="txtID" id="txtID" value="#arrSections.getId()#" />
				<label for="txtSection">Section Name</label><br />
				<input type="text" name="txtSection" id="txtSection" value="#arrSections.getSection()#" />
				<p class="help-block">Ex: <i>Page-by-Page Validations</i></p>
		</div>
	</cffunction>
	
	<cffunction name="AddTestCasesForm" access="remote" output="true">
		<cfargument name="scenarioid" required="true" type="numeric">
		<cfif !(StructKeyExists(Session,"ProjectID"))>
			<cfreturn>
		</cfif>
		<cfquery name="getTestCases">
			SELECT id, TestTitle
			FROM TTestCase
			WHERE ProjectID = #Session.ProjectID#
			AND id not in (SELECT CaseID from TTestScenarioCases where ScenarioId = #arguments.scenarioid#)
		</cfquery>
		<script type="text/javascript">
			$(document).ready(function() {
				$(document).off("click","##btnClose");
					$(document).on("click","##btnClose",function(event) {
						event.preventDefault();					
						if (confirm("Are you sure you want to close without saving?"))
						{
							$("##smallModal").modal('hide');
						}
					});
				$(document).off("click","##btnSave");
				$(document).on("click","##btnSave", function(event) {
					event.preventDefault();
					
					var multipleValues = $("##testcases").val() || [];
					$.ajax({
						url : "CFC/Forms.cfc?method=saveCasesToScenario",
						type : "POST",
						data : {testcases : multipleValues.join(", "),scenarioid : "#arguments.scenarioid#"}
					}).done(function(data) {
						$("##smallModal").modal("hide");
						event.preventDefault();
						$("##topcontent").removeClass("panel").removeClass("panel-default");
						$("##topcontent").load("cfc/Dashboard.cfc?method=TestScenarioHub&scenarioid=#arguments.scenarioid#");
						$("##midrow").empty();
						$("##activitypanel").remove();
						$("##lnkReturnToProject").attr("pjid",#session.projectid#);
						$("##lnkReturnToProject").show();
						$("##createreportpanel").remove();
					});
				});
			});
		</script>
		<div class="form-group">
			<select name="testcases" id="testcases" class="form-control" multiple>
				<cfloop query="getTestCases">
					<option value="#id#">#TestTitle#</option>
				</cfloop>
			</select>
		</div>
	</cffunction>
	
	<cffunction name="ReportForm" access="remote" output="true">
		<cfargument name="reporttype" required="true">
		<cfscript>
			report = createObject("component","reports.#arguments.reporttype#");
			report.getReportOptions();
			report.getAccessAndScheduling();
			newreport = new Reports(report);
			outputbody = newreport.getFormFields();
		</cfscript>
		<script type='text/javascript'>
			$(document).ready(function() {
				$(document).off("click","##btnClose");
				$(document).on("click","##btnClose",function(event) {
					event.preventDefault();					
					if (confirm("Are you sure you want to close without saving your report?"))
					{
						$("##largeModal").modal('hide');
					}
				});
				$(document).off("click","##btnSave");
				$(document).on("click","##btnSave",function(event) {
					#report.getJSONFormDataForPost()#;
					$.ajax({
						url : "cfc/forms.cfc?method=saveReport",
						type : "POST",
						data: {  reportType : '#arguments.reporttype#',
								 reportName : $("##reportname").val(),
								 reportOptions : JSON.stringify(reportOptions),
								 reportAandS : JSON.stringify(reportAandS)
						 }
					}).done(function(data) {
						$("##largeModal").modal('hide');
						$("##topcontent").removeClass("panel").removeClass("panel-default");
						reportScreen();
					});
				});
			});
		</script>
		<div class='well well-default'>
			<h3>#newreport.getReportTypeName()#</h3>
			<table border="0" cellspacing="0" cellpadding="2">
				<tr><td>Group:</td>
					<td>#newreport.getGroup()#</td>
				<tr>
					<td>Author:</td>
					<td>#newreport.getAuthor()#</td>
				</tr>
			</table>
			<p>#newreport.getReportDescription()#</p>
		</div>
		<label>Report Name: <br /><input type="text" class="form-control" id='reportname' name='reportname' value='#arguments.reporttype# #DateFormat(now(),"mm-dd-yyyy")#' /></label>
		#outputbody#
	</cffunction>
	
	<cffunction name="TestScenarioForm" access="remote" output="true">
		<cfargument name="testscenarioid" required="False" default="0" type="numeric">
		<cfif !(StructKeyExists(Session,"ProjectID"))>
			<cfreturn>
		</cfif>
		<cfif arguments.testscenarioid gt 0>
			<cfset arrTestScenario = EntityLoadByPK("TTestScenario",arguments.testscenarioid)>
		<cfelse>
			<cfset arrTestScenario = entityNew("TTestScenario")>
			<cfset arrTestScenario.setId(0) >
		</cfif>
		<cfif (!StructKeyExists(SESSION,"Loggedin") || !Session.Loggedin)>
			login
			<cfreturn>
		</cfif>
			<script type="text/javascript">
			$(document).ready(function() {
				$(".selectpicker").selectpicker();
				$(document).on("click","a.lnkMilestone", function(event) {
					event.preventDefault();
					var rpvalue = $(this).attr("msvalue");
					var rptext = $(this).html();
					$("##txtMilestoneID").val(rpvalue);
					$(".list-group-item").removeClass("active");
					$("##mslink").html(rptext);
					$(this).addClass("active");
				});
				$(document).off("click","##btnClose");
				$(document).on("click","##btnClose",function(event) {
					event.preventDefault();					
					if (confirm("Are you sure you want to close without saving your test scenario?"))
					{
						$("##largeModal").modal('hide');
					}
				});
				$(document).off("click","##btnSave");
				$(document).on("click","##btnSave",function(event) {
					event.preventDefault();
					$.ajax({
						url: "CFC/forms.cfc?method=saveScenario",
						type: "POST",
						data: {
							id : $("##txtID").val(),
							TestScenario : $("##txtTestScenario").val(),
							TestDescription : $("##txtTestDescription").val(),
							MilestoneID : $("##txtMilestoneID").val(),
							TestDescription : $("##txtTestDescription").val(),
							ProjectID : '#Session.ProjectID#',
							SectionID : $("##ddlSectionId").val()
						}
					}).done(function(data) {
						if ( data == "true" )
						{
							$("##largeModal").modal('hide');
							if ( $("##scenariospanel").length == 0 )
							{
								$("##paneltestscenarios").remove();
								insertScenarios();
							} else {
								$("##scenariospanel").remove();
								$("##topcontent").load("cfc/Dashboard.cfc?method=AllScenarios");
							}
						} else {
							alert("There was an error with your save.  Please contact system administrator.");
						}
					});
				});		
			});
			</script>
			<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
			<div class="form-group required">
				<input type="hidden" name="txtID" id="txtID" value="#arrTestScenario.getId()#" />
				<label for="txtTestScenario">Name</label><br />
				<input type="text" name="txtTestScenario" id="txtTestScenario" value="#arrTestScenario.getTestScenario()#" />
				<p class="help-block">Ex: <i>User interface test</i></p>
			</div>
			<div class="form-group">
				<label for="txtTestDescription">Description</label><br />
				<textarea class="form-control" rows="5" id="txtTestDescription" name="txtTestDescription">#arrTestScenario.getTestDescription()#</textarea>
			</div>
			</div>
			<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
			
			<div class="form-group">
				<label for="ddlSectionId">Testing Section</label>
				<cfset arrSections = EntityLoad("TTestProjectTestSection",{ProjectID = Session.ProjectID})>
				<select class="form-control selectpicker" id="ddlSectionId" name="ddlSectionId" data-style="btn-info">
					<option value="0" <cfif arrTestScenario.getSectionId() eq 0>selected</cfif>>Select a section</option>
					<cfloop array="#arrSections#" index="section">
					<option value="#section.getId()#" <cfif arrTestScenario.getSectionId() eq section.getId()>selected</cfif>>#section.getSection()#</option>
					</cfloop>
				</select>
				<input type="hidden" name="txtMilestoneID" id="txtMilestoneID" value="#arrTestScenario.getMilestoneID()#">
				<label>Milestone</label><br />
				<div class="btn-group" style="margin-top:-5px;">
					<a id="mslink" class="btn btn-sm btn-info" href="##">
						<cfif IsNumeric(arrTestScenario.getMilestoneID()) AND arrTestScenario.getMilestoneID() gt 0>
							<cfset arrMilestone = EntityLoadByPk("TTestMilestones",arrTestScenario.getMilestoneID())>
							#arrMilestone.getMilestone()#
						<cfelse>
							Select a milestone
						</cfif>	
					</a>
					<a class="btn btn-info btn-sm dropdown-toggle" data-toggle="dropdown" href="##">
							<span class="fa fa-caret-down"></span></a>
							<ul class="dropdown-menu">
								<cfquery name="qryMilestones" dbtype="hql">
									FROM TTestMilestones
									WHERE ProjectID = <cfqueryparam value="#Session.ProjectID#">
								</cfquery>
								<cfif ArrayLen(qryMilestones) gt 0>
									<cfloop array="#qryMilestones#" index="ms">
										<li><a href='##' class='lnkMilestone' msvalue="#ms.getId()#">#ms.getMilestone()#</a></li>
									</cfloop>
								</cfif>
							</ul>	
					
				</div>
				</div>
				<div class="form-group">
				<label>Assigned Test Cases</label>
				<cfset objData = CreateObject("component","Data")>
				<cfset qryTestCases = objData.qryTestCasesAssignedScenario(arrTestScenario.getId())>
				
				<cfif qryTestCases.RecordCount eq 0>
					<div class="alert alert-warning small"><h4>No Test Cases Assigned</h4>Click below to assign a test case.</div>
				<cfelse>
					<table class="table table-condensed table-striped table-hover small">
						<thead>
							<tr>
								<th>Test</th>
								<th>Date Ass.</th>
								<th>User</th>
							</tr>
						</thead>
						<tbody>
						<cfloop query="qryTestCases">
							<tr>
								<td>#TestTitle#</td>
								<td>#DateFormat(DateOfAction,"m/d/yy")#</td>
								<td>#UserName#</td>
							</tr>
						</cfloop>
						</tbody>
					</table>								
				</cfif>
			</div>
	</cffunction>
			
	<cffunction name="ProjectForm" access="remote" output="true">
		<cfargument name="projectId" required="false" default="0" type="numeric">
		<cfif arguments.projectId gt 0>
			<cfset arrProject = EntityLoadByPK("TTestProject",arguments.projectID)>
		<cfelse>
			<cfset arrProject = createObject("component","db.TTestProject")>
			<cfset arrProject.setIncludeAnnouncement(0) >
		</cfif>
		<cfif (!StructKeyExists(SESSION,"Loggedin") || !Session.Loggedin)>
			login
			<cfexit>
		</cfif>
		<script type="text/javascript">
			$(document).ready(function() {
				$(".datetime").datepicker({
					format:"mm/dd/yyyy",
					todayHighlight: true,
					autoclose:true
				});
				$(document).on("click","a.list-group-item", function(event) {
					event.preventDefault();
					var rpvalue = $(this).attr("rtvalue");
					$("##txtRepositoryType").val(rpvalue);
					$(".list-group-item").removeClass("active");
					$(this).addClass("active");
				});
				$(document).off("click","##btnClose");
				$(document).on("click","##btnClose",function(event) {
					event.preventDefault();					
					if (confirm("Are you sure you want to close without saving your project?"))
					{
						$("##largeModal").modal('hide');
					}
				});
				$(document).off("click","##btnSave");
				$(document).on("click","##btnSave",function(event) {
					event.preventDefault();
					$.ajax({
						url: "CFC/forms.cfc?method=saveProject",
						type: "POST",
						data: {
							id : '#arguments.projectId#',
							ProjectTitle : $("##txtProjectTitle").val(),
							ProjectDescription : $("##txtProjectDescription").val(),
							ProjectStartDate : $("##txtProjectStartDate").val(),
							ProjectProjectedEndDate : $("##txtProjectProjectedEndDate").val(),
							ProjectActualEndDate : $("##ProjectActualEndDate").val(),
							IncludeAnnouncement : $("##cbxIncludeAnnouncement").is(":checked"),
							RepositoryType : $("##txtRepositoryType").val()
						}
					}).done(function(data) {
						if ( data == "true" )
						{
							$("##largeModal").modal('hide');
						} else {
							alert("There was an error with your save.  Please contact system administrator.");
						}
					});
				});		
			});
		</script>
		<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
			<div class="form-group required">
				<label for="txtProjectTitle">Name</label>
				<input type="text" name="txtProjectTitle" id="txtProjectTitle" value="#arrProject.getProjectTitle()#" />
				<p class="help-block">Ex: <i>New Client, Intranet Project, or Accounts Receivable Software</i></p>
			</div>
			<div class="form-group required">
				<label for="txtProjectDescription">Project Description</label>
				<textarea class="form-control" rows="5" id="txtProjectDescription" name="txtProjectDescription">#arrProject.getProjectDescription()#</textarea>
				<p class="help-block">You can include this description on the project overview.  If you have links to a knowledge base or issue tracker, you can include them here.</p>
			</div>
			<div class="form-group">
				<div class="control-group">
					<label class="checkbox" for="cbxIncludeAnnouncement"><input type="checkbox" name="cbxIncludeAnnouncement" id="cbxIncludeAnnouncement" value="1"<cfif arrProject.getIncludeAnnouncement()> checked="true"</cfif> />Show description on dashboard.</label>
				</div>
			</div>
			<input type="hidden" name="txtRepositoryType" id="txtRepositoryType" value="#IsNull(arrProject.getRepositoryType()) ? 1 : arrProject.getRepositoryType()#" />
			<div class="list-group">
				<a href="##" class="list-group-item<cfif arrProject.getRepositoryType() eq 1 or IsNull(arrProject.getRepositoryType())> active</cfif>" rtvalue="1">
					<h4 class="list-group-item-heading">Use a single test scenario for all test cases</h4>
					<p class="list-group-item-text">For smaller projects where you may not have a need to compartmentalize versions or test cases.  You can still use sections to compartmentalize your testing.</p>
				</a>
				<a href="##" class="list-group-item<cfif arrProject.getRepositoryType() eq 2> active</cfif>" rtvalue="2">
					<h4 class="list-group-item-heading">Use a multiple test secnarios</h4>
					<p class="list-group-item-text">For projects dealing with multiple versions, it may be helpful to maintain separate sets of test cases.</p>
				</a>
			</div>
		</div>
		<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
			<div class="form-group required">
				<label for="txtProjectStartDate">Start Date</label>
				<input type="text" id="txtProjectStartDate" name="txtProjectStartDate" value="#arrProject.getProjectStartDate()#" class="form-control datetime" />
			</div>
			<div class="form-group">
				<label for="txtProjectProjectedEndDate">Projected End Date</label>
				<input type="text" id="txtProjectProjectedEndDate" name="txtProjectProjectedEndDate" value="#arrProject.getProjectProjectedEndDate()#" class="form-control datetime" />
			</div>
			<div class="form-group">
				<label for="txtProjectActualEndDate">Actual End Date</label>
				<input type="text" id="txtProjectActualEndDate" name="txtProjectActualEndDate" value="#arrProject.getProjectActualEndDate()#" class="form-control datetime" />
			</div>
			<cfif arguments.projectId GT 0>
			<div class="form-group">
				<div class="control-group">
					<label class="checkbox" for="cbxClosed"><input type="checkbox" name="cbxClosed" id="cbxClosed" value="1"
						<cfif arrProject.getClosed()> checked="true"
						</cfif>>Project is complete</label>
					<p class="help-block">Shows the project as completed on the dashboard and other reports.</p>
				</div>
			</div>
			</cfif>
		</div>
	</cffunction>
	<!--- form processing --->
	
	<cffunction name="saveCasesToScenario" access="remote" returntype="any" returnformat="JSON">
		<cfargument name="testcases">
		<cfargument name="scenarioid">
		<cfloop list="#arguments.testcases#" index="i">
			<cfquery>
				INSERT INTO TTestScenarioCases (CaseId, ScenarioId)
				VALUES (#i#,#arguments.scenarioid#)
			</cfquery>
			<cfscript>
				updatequery = new Query();
				updatequery.setSql("UPDATE TTestCaseHistory SET DateActionClosed = :dateactionclosed WHERE caseid = :caseid AND DateActionClosed is NULL");
				updatequery.addParam(name="dateactionclosed",value=now(),cfsqltype="cf_sql_date");
				updatequery.addParam(name="caseid",value=i,cfsqltype="cf_sql_integer");
				updatequery.execute();
				newcasehistory = EntityNew("TTestCaseHistory");
				newcasehistory.setAction("Assigned");
				newcasehistory.setTesterID(Session.UserIDInt);
				newcasehistory.setDateOfAction(Now());
				newcasehistory.setCaseId(i);
				EntitySave(newcasehistory);
			</cfscript>
		</cfloop>
		<cfreturn>
	</cffunction>
	
	<cffunction name="saveSection" access="remote" returntype="any" returnFormat="JSON">
		<cfargument name="id" type="numeric">
		<cfargument name="Section">
		<cfscript>
			if ( arguments.id > 0 ){
				arrSection = EntityLoadByPK("TTestProjectTestSection",arguments.id);
			} else {
				arrSection = EntityNew("TTestProjectTestSection");
			}
			arrSection.setSection(arguments.Section);
			arrSection.setProjectID(SESSION.ProjectID);
			try
			{
				EntitySave(arrSection);
				return true;
			} catch (any ex) {
				return serializeJSON(ex);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="saveMilestone" access="remote" returntype="any" returnformat="JSON">
		<cfargument name="id" type="numeric">
		<cfargument name="Milestone" required="true">
		<cfargument name="DueOn">
		<cfargument name="MilestoneDescription">
		<cfargument name="Closed">
		<cfargument name="ProjectID">
		<cfscript>
			if ( arguments.id > 0 ) {
				arrMilestone = EntityLoadByPK("TTestMilestones",arguments.id);
			} else {
				arrMilestone = EntityNew("TTestMilestones");
			}
			arrMilestone.setMilestone(arguments.Milestone);
			arrMilestone.setDueOn(arguments.DueOn);
			arrMilestone.setMilestoneDescription(arguments.MilestoneDescription);
			arrMilestone.setClosed(arguments.Closed);
			arrMilestone.setProjectID(arguments.ProjectID);
			try {
				EntitySave(arrMilestone);
				return true;
			} catch (any ex) {
				return serializeJSON(ex);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="saveTestCase" access="remote" returntype="any" returnformat="JSON">
		<cfargument name="id" type="numeric">
		<cfargument name="TestTitle">
		<cfargument name="TestDetails">
		<cfargument name="PriorityId">
		<cfargument name="TypeId">
		<cfargument name="ProjectId">
		<cfargument name="Preconditions">
		<cfargument name="Steps">
		<cfargument name="ExpectedResult">
		<cfargument name="MilestoneId">
		<cfargument name="Estimate">
		<cfscript>
			if ( arguments.id > 0 ) {
				arrTestCase = EntityLoadByPK("TTestCase",arguments.id);
			} else {
				arrTestCase = EntityNew("TTestCase");
			}
			arrTestCase.setTestTitle(arguments.TestTitle);
			arrTestCase.setTestDetails(arguments.TestDetails);
			arrTestCase.setPriorityId(arguments.PriorityId);
			arrTestCase.setTypeId(arguments.TypeId);
			arrTestCase.setProjectID(arguments.ProjectID);
			arrTestCase.setPreconditions(arguments.preconditions);
			arrTestCase.setSteps(arguments.Steps);
			arrTestCase.setExpectedResult(arguments.expectedResult);
			arrTestCase.setMilestoneId(arguments.milestoneId);
			arrTestCase.setEstimate(arguments.Estimate);
			try {
				EntitySave(arrTestCase);
				return true;
			} catch (any ex) {
				return serializeJSON(ex);
			}
		</cfscript>
	</cffunction>	
	
	<cffunction name="saveScenario" access="remote" returntype="any" returnformat="JSON">
		<cfargument name="id" type="numeric">
		<cfargument name="TestScenario" required="true">
		<cfargument name="MilestoneID">
		<cfargument name="TestDescription">
		<cfargument name="ProjectID">
		<cfargument name="SectionID" required="true">
		<cfscript>
			if ( arguments.id > 0 ) {
				arrScenario = EntityLoadByPK("TTestScenario",arguments.id);
			} else {
				arrScenario = EntityNew("TTestScenario");
			}
			arrScenario.setTestScenario(arguments.TestScenario);
			arrScenario.setMilestoneID((isNumeric(arguments.MilestoneID)) ? arguments.MilestoneID : 0);
			arrScenario.setTestDescription(arguments.TestDescription);
			arrScenario.setProjectId(arguments.ProjectID);
			arrScenario.setCreatorUserId(SESSION.UserIDInt);
			arrScenario.setSectionId(isNumeric(arguments.SectionID) ? arguments.SectionID : 0);
			try {
				EntitySave(arrScenario);
				return true;
			} catch (any ex) {
				return serializeJSON(ex);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="saveProject" access="remote" returntype="any" returnformat="JSON">
		<cfargument name="id" type="numeric">
		<cfargument name="ProjectTitle" required="true">
		<cfargument name="AxoSoftID" default="" hint="unimplemented" required="true">
		<cfargument name="ProjectDescription" required="true">
		<cfargument name="ProjectStartDate" required="true">
		<cfargument name="ProjectProjectedEndDate" required="true">
		<cfargument name="ProjectActualEndDate" required="false" default="">
		<cfargument name="IncludeAnnouncement" required="true">
		<cfargument name="RepositoryType" required="true">
		<cfargument name="Closed" required="false" default="false">
		<!--- if id > 0, we're going to load an entity to modify, otherwise create new --->
		<cfscript>
			if ( arguments.id > 0 ) {
				arrProject = EntityLoadByPK("TTestProject",arguments.id);
			} else {
				arrProject = createObject("component","db.TTestProject");
			}
			arrProject.setProjectTitle(arguments.ProjectTitle);
			arrProject.setProjectDescription(arguments.ProjectDescription);
			arrProject.setProjectStartDate(arguments.ProjectStartDate);
			arrProject.setProjectProjectedEndDate(arguments.ProjectProjectedEndDate);
			arrProject.setProjectActualEndDate(arguments.ProjectActualEndDate);
			arrProject.setIncludeAnnouncement(arguments.IncludeAnnouncement);
			arrProject.setRepositoryType(arguments.RepositoryType);
			arrProject.setClosed((isNull(arguments.Closed) ? 0 : arguments.Closed));
			try {
				EntitySave(arrProject);
				return true;
			} catch (any ex) {
				return serializeJSON(ex);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="saveTestResult" access="remote" returntype="any" returnformat="JSON">
		<cfargument name="caseidslist" required="true">
		<cfargument name="statusid" type="numeric" required="true">
		<cfargument name="testerid" type="numeric" required="true">
		<cfargument name="version">
		<cfargument name="elapsedtime">
		<cfargument name="comment">
		<cfargument name="AttachmentList" default="">
		<cfargument name="defects" default="">
		<cfloop index="ListElement" list="#arguments.caseidslist#">
			<cfscript>
				var testresult = EntityNew("TTestResult");
				StatusObj = EntityLoadByPk("TTestStatus",arguments.statusid);
				testresult.setTTestStatus(StatusObj);
				TesterObj = EntityLoadByPk("TTestTester",arguments.testerid);
				testresult.setTTestTester(TesterObj);
				testresult.setVersion(arguments.version);
				testresult.setElapsedTime(arguments.elapsedtime);
				testresult.setComment(arguments.comment);
				testresult.setAttachmentList(arguments.attachmentlist);
				testresult.setDefects(arguments.defects);
				testresult.setDateTested(Now());
				testresult.setTestCaseID(ListElement);
				EntitySave(testresult);
			</cfscript>
		</cfloop>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="saveReport" access="remote" returntype="any" returnformat="JSON">
		<cfargument name="reportType" required="true">
		<cfargument name="reportName" required="true">
		<cfargument name="reportOptions" type="string">
		<cfargument name="reportAandS" type="string">
		<!--- convert options and ands to cfml from wddx --->
		<cfset s1 = deserializeJSON(arguments.reportOptions,false)>
		<cfset s2 = deserializeJSON(arguments.reportAandS,false)>
		
		<cfscript>
			report = createObject("component","reports.#arguments.reportType#").init(0,arguments.reportName,s1,s2);
			newreport = new Reports(report);
			newreport.saveReport();
			if ( s2.CreateReport == "Once")
				newreport.runReport();
		</cfscript>
		
	</cffunction>
	
	<cffunction name="deleteTestCase" access="remote" returntype="void">
		<cfargument name="tcid" type="numeric" required="true">
		<cfif (!StructKeyExists(SESSION,"Loggedin") || !Session.Loggedin)>
			login
			<cfexit>
		</cfif>
		<cfset testcase = EntityLoadByPK("TTestCase",arguments.tcid)>
		<cfscript>
			EntityDelete(testcase);
			// delete related stuff
			arrTCScenarios = EntityLoad("TTestScenarioCases",{CaseId = arguments.tcid});
			for (tcasescenario in arrTCScenarios) {
				EntityDelete(tcasescenario);
			}
			arrTestHistory = EntityLoad("TTestCaseHistory",{CaseId = arguments.tcid});
			for ( history in arrTestHistory) {
				EntityDelete(history);
			}
			arrTestResults = EntityLoad("TTestResult",{TestCaseId = arguments.tcid});
			for ( result in arrTestResults )
			{
				EntityDelete(result);
			}
		</cfscript> 
	</cffunction>
	
	<cffunction name="deleteReport" access="remote" returntype="any" returnformat="JSON">
		<cfargument name="reportid" required="true" type="numeric">
		<cfscript>
			report = EntityLoadByPK("TTestReports",arguments.reportid);
			objMaintenance = createobject("component","Maintenance");
			try {
				EntityDelete(report);
				objMaintenance.deleteTask(arguments.reportid);
			} catch (any e)
			{
				return false;
			}
			FileDelete(ExpandPath("/reportpdfs/") & arguments.reportid & ".pdf");
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="returnBSLabelStyle" access="private" returntype="string">
		<cfargument name="labelExpression" required="true">
		<cfargument name="element" required="false" default="label">
		<cfset local.labelstyle = "">
		<cfswitch expression="#arguments.labelExpression#">
				<cfcase value="Passed">
					<cfset local.labelstyle = "#arguments.element#-success">
				</cfcase>
				<cfcase value="Failed">
					<cfset local.labelstyle = "#arguments.element#-danger">
				</cfcase>
				<cfcase value="Blocked">
					<cfset local.labelstyle = "#arguments.element#-default">
				</cfcase>
				<cfcase value="Untested,Assigned">
					<cfset local.labelstyle = "#arguments.element#-info">
				</cfcase>
				<cfcase value="Retest">
					<cfset local.labelstyle = "#arguments.element#-warning">
				</cfcase>
				<cfdefaultcase>
					<cfset local.labelstyle = "#arguments.element#-default">
				</cfdefaultcase>
			</cfswitch>
		<cfreturn local.labelstyle>
	</cffunction>
</cfcomponent>