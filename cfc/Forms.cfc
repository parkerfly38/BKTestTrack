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
					<h4 class="list-group-item-heading">Use a single test suite for all test cases</h4>
					<p class="list-group-item-text">For smaller projects where you may not have a need to compartmentalize versions or test cases.  You can still use sections to compartmentalize your testing.</p>
				</a>
				<a href="##" class="list-group-item<cfif arrProject.getRepositoryType() eq 2> active</cfif>" rtvalue="2">
					<h4 class="list-group-item-heading">Use a multiple test suites</h4>
					<p class="list-group-item-text">For projects dealing with multiple versions, it may be helpful to maintain separate test cases.</p>
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
					<label class="checkbox" for="cbxClosed"><input type="checkbox" name="cbxClosed" id="cbxClosed" value="1"<cfif arrProject.getClosed()> checked="true"</cfif> />Project is complete</label>
					<p class="help-block">Shows the project as completed on the dashboard and other reports.</p>
				</div>
			</div>
			</cfif>
		</div>
	</cffunction>
	<!--- form processing --->
	
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
				
		
</cfcomponent>