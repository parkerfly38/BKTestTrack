<cfscript>
	if ( StructKeyExists(url,"logout") ) {
		objLogon = createObject("component","cfc.Logon");
		objLogon.Logout();
	}
	if (StructKeyExists(url,"projectid"))
	{
		Session.ProjectID = url.projectid;
	}
	if (StructIsEmpty(url) )
	{
		Session.ProjectID = "";
	}
	objData = createObject("component","cfc.Data");
	objDashboard = createObject("component","cfc.Dashboard");
	objAxoSoft = createObject("component","cfc.AxoSoft");
	objForm = createObject("component","cfc.Forms");
	local.testsAssigned = objDashboard.assignedTestsCount(Session.UserIDInt);
	if ( StructKeyExists(form,"addCase") ) {
		objForm.saveTestCase(0,form.txtTestTitle,form.txtTestDetails,form.ddPriorityId,form.ddlTypeId,url.item,form.txtPreconditions,form.txtSteps, form.txtExpectedResult, 0, form.txtEstimate);
	}
	if ( StructKeyExists(form,"saveCase") ) {
		objForm.saveTestCase(form.saveCase, form.txtTestTitle, form.txtTestDetails, form.ddPriorityId, form.ddlTypeId, url.item, form.txtPreconditions,form.txtSteps, form.txtExpectedResult,0, form.txtEstimate);
	}
</cfscript>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	    <meta name="viewport" content="width=device-width, initial-scale=1">
	    <meta name="description" content="">
	    <meta name="author" content="">
	    <title>CFTestTracker</title>
	    <link rel="icon" href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/favicon.ico" type="image/x-icon" />
		<link rel="stylesheet" href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/style/bootstrap.css" />
		<link href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/font-awesome-4.2.0/css/font-awesome.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/style/datepicker3.css" />
		<link rel="stylesheet" href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/style/bootstrap-select.min.css" />
		<script type="text/javascript" src="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/scripts/jquery-1.10.2.min.js"></script>
		<script type="text/javascript" src="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/scripts/bootstrap.min.js"></script>
		<cfoutput>
		<script type="text/javascript">
			
			var projectid;
			<cfif StructKeyExists(url,"ProjectID")>projectid = #url.ProjectID#;</cfif>
			
		</script>
		</cfoutput>
		<script type="text/javascript" src="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/scripts/cftracker.js"></script>
		<cfif StructKeyExists(URL,"TR")>
		<script type="text/javascript">
			$(document).ready(function() {
				var trid = <cfoutput>#URL.TR#</cfoutput>;
				$("#largeModal .modal-title").text("Test Result");
				$("#largeModal .modal-body").load("http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/cfc/dashboard.cfc?method=getTestResult&testresultid="+trid);
				$("#largeModal").modal("show");
			});
		</script>
		</cfif>
		<cfif StructKeyExists(url,"addTestCase") || StructKeyExists(url,"edittc")>
		<script type="text/javascript">
			$(document).ready(function() {
				$("#largeModal").modal("show");
			});
		</script>
		</cfif>
		<script type="text/javascript" src="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/scripts/ChartNew.js"></script>
		<script type="text/javascript" src="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/scripts/bootstrap-datepicker.js"></script>
		<script type="text/javascript" src="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/scripts/bootstrap-select.min.js"></script>
		<cfif StructKeyExists(URL,"TC")>
		<script type="text/javascript">
			$(document).ready(function() {
			$("#largeModal .modal-title").text("Edit Test Case");
			$("#largeModal .modal-body").load("/CFTestTrack/cfc/forms.cfc?method=TestCaseForm&testcaseid="+<cfoutput>#url.TC#</cfoutput>);
			$("#largeModal").modal("show");
			});
		</script>
		</cfif>
		<style>
			body { padding-top: 60px; }
			.rowoffset { margin-bottom: 20px; }
			.form-group.required .control-label:after {
				content:"*";
				color:red;
			}
			.linkhide {
				display: none;
			}
			.linkshow {
				display: block;
			}
			 canvas{
		        width: 100% !important;
		        /*max-width: 800px;
		        height: auto !important;*/
		    }
	        .btn-file {
			    position: relative;
			    overflow: hidden;
    		}
    		.btn-file input[type=file] {
			    position: absolute;
			    top: 0;
			    right: 0;
			    min-width: 100%;
			    min-height: 100%;
			    font-size: 100px;
			    text-align: right;
			    filter: alpha(opacity=0);
			    opacity: 0;
			    outline: none;
			    background: white;
			    cursor: inherit;
			    display: block;
			}
    		.avatar {
			    float: left;
			    margin-top: 1em;
			    margin-right: 1em;
			    position: relative;
			
			    -webkit-border-radius: 50%;
			    -moz-border-radius: 50%;
			    border-radius: 50%;
			
			    -webkit-box-shadow: 0 0 0 3px #fff, 0 0 0 4px #999, 0 2px 5px 4px rgba(0,0,0,.2);
			    -moz-box-shadow: 0 0 0 3px #fff, 0 0 0 4px #999, 0 2px 5px 4px rgba(0,0,0,.2);
			    box-shadow: 0 0 0 3px #fff, 0 0 0 4px #999, 0 2px 5px 4px rgba(0,0,0,.2);
			}
    		@media screen and (min-width: 768px) {
    			#largeModal .modal-dialog {width:95%;}
    		}
		</style>
	</head>
	<body style="background-color: #9F5F9F;">
		<nav class="navbar navbar-default navbar-fixed-top">
		    <div class="container">
		      <div class="navbar-header">
		      	<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
		            <span class="sr-only">Toggle navigation</span>
		            <span class="icon-bar"></span>
		            <span class="icon-bar"></span>
	            	<span class="icon-bar"></span>
	          	</button>
	          	<a class="navbar-brand" href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/" id="lnkHome" style="padding:3px;"><img src="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/images/TestTrack.png" border="0" style="height: 45px; width: auto;" /></a>
	          </div>
		      <div id="navbar" class="navbar-collapse collapse">
		      	
		        
		        <ul class="nav navbar-nav">
		        <cfif StructKeyExists(url,"projectid") || isNumeric(Session.projectID)>
		          <li><a href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/project/<cfoutput>#session.projectid#</cfoutput>/"><!---<i class="fa fa-home"></i>---> Project Home</a></li>
		          <li class="dropdown ddmMilestones"><a href="##" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="true"><!---<i class="fa fa-map-marker"> </i> --->Milestones</a>
		          	<ul class="dropdown-menu" role="menu">
		          		<li><a class="lnkViewMilestones" href="milestones">View All</a></li>
		          		<li><a class="lnkAddMilestone" href="##">Add</a></li>
		          	</ul>
		          </li>
		          <li class="dropdown ddmScenarios"><a href="##" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="true"><!---<i class="fa fa-suitcase"> </i>---> Test Scenarios</a>
		          	<ul class="dropdown-menu" role="menu">
		          		<li><a class="lnkViewScenarios" href="##">View All</a></li>
		          		<li><a class="lnkAddScenario" href="##">Add</a></li>
		          	</ul>
		          </li>
		          <li class="dropdown ddmTestCases"><a href="##" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="true"><!---<i class="fa fa-tachometer"> </i>--->Test Cases</a>
		          	<ul class="dropdown-menu" role="menu">
		          		<li><a class="lnkViewTests" href="#">View All</a></li>
		          		<li><a class="lnkAddTest" href="#">Add</a></li>
		          		<li class="divider"></li>
		          		<li class="dropdown-header">Bulk Actions</li>
		          		<li><a class="lnkDownloadTestCaseTemplate" href="#">Download Template</a></li>
		          		<li><a class="lnkUploadTestCases" href="#">Upload Via Excel</a></li>
		          	</ul>
		          </li>
		          <li class="dropdown ddmAutomationStudio"><a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="true"><!---<i class="fa fa-list-alt"> </i> --->Automation Studio</a>
		          	<ul class="dropdown-menu" role="menu">
		          		<li><a class="lnkBuildAutomatedTest" href="#">Build Test</a></li>
		          		<li><a class="lnkScheduleTests" href="#">Schedule Tests</a></li>
		          		<li><a class="lnkTestScriptLibrary" href="#">Test Script Library</a></li>
		          		<li class="divider"></li>
		          		<li><a class="lnkViewScheduledTests" href="#">View Scheduled Tests</a></li>
		          		<li><a class="" href="#">Automated Test Activity</a></li>
		          	</ul>
		          </li>
		          <li><a class="lnkViewReports" href="#"><!---<i class="fa fa-bars"> </i> --->Reporting</a></li>
		          <li><a href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/settings/"> <!---<i class="fa fa-gear"></i>---> Settings</a></li>
		         
		      	</cfif>
		      	<li><a href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/logout/"> <i class="fa fa-power-off"></i> Log out</a></li>
		        </ul>
		      </div><!--/.nav-collapse -->
		    </div>
	    </nav>
	    
	  <div class="container" style="background:none;">
		  <div class="row">
		  	<!--- do some cool stuff here to change layout --->
		  	<cfif !StructKeyExists(url,"projectid") && !isNumeric(Session.projectID)>
		  	<div id="projectcontent" class="col-xs-3 col-sm-3 col-md-3 col-lg-3">
		  		<cfif Application.AxoSoftIntegration>
		  			<cfoutput>#objDashboard.listAxoSoftProjects(objAxoSoft.getProjects(Session.AxoSoftToken))#</cfoutput>
		  		<cfelse>
		  			<cfoutput>#objDashboard.listProjects()#</cfoutput>
		  		</cfif>
		  	</div>
		  	<cfset local.panelsizeint = 6 />
		  	<cfelse>
		  	<cfset local.panelsizeint = 9 />
		  	</cfif>
		  	
		  	<cfoutput><div id="featurecontent" class="col-xs-#local.panelsizeint# col-sm-#local.panelsizeint# col-md-#local.panelsizeint# col-lg-#local.panelsizeint#"></cfoutput>
		  		<cfif StructKeyExists(url,"scenarioid")>
		  			<cfif isNumeric(url.scenarioid)>
		  				<cfoutput>#objDashboard.TestScenarioHub(url.scenarioid)#</cfoutput>
		  			</cfif>
		  		</cfif>
		  		<cfif StructKeyExists(url,"projectid")>
		  			<cfif isNumeric(url.projectid)>
		  			<cfoutput>#objDashboard.HubChart(url.projectid)#</cfoutput>
		  			<cfif StructKeyExists(url,"ppage")>
		  				<cfset local.ppaging = url.ppage>
		  			<cfelse>
		  				<cfif StructKeyExists(url,"bpage")>
		  					<cfset local.ppaging = 0>
		  				<cfelse>
		  					<cfset local.ppaging = 1>
		  				</cfif>
		  			</cfif>
		  			<cfif StructKeyExists(url,"bpage")>
		  				<cfset local.bpaging = url.bpage>
		  			<cfelse>
		  				<cfif StructKeyExists(url,"ppage")>
		  					<cfset local.bpaging = 0>
		  				<cfelse>
		  					<cfset local.bpaging = 0>
		  				</cfif>
		  			</cfif>
		  				<cfif Application.AxoSoftIntegration>
		  				<cfoutput>#objDashboard.listAxoSoftItems(objAxoSoft.getItems(url.projectid,Session.AxoSoftToken),url.projectid,local.ppaging,local.bpaging)#</cfoutput>
		  				<cfelse>
		  					<cfoutput>#objDashboard.listTestScenarios(url.projectid)#</cfoutput>
		  				</cfif>
		  			<cfelse>
		  				<cfoutput>#objForm.ProjectForm()#</cfoutput>
		  			</cfif>
		  		</cfif>
		  		<cfif StructIsEmpty(url)>
		  			<cfif !Application.AxoSoftIntegration>
		  				<cfoutput>#objDashboard.AllProjectsChart()#</cfoutput>
		  			</cfif>
		  		</cfif>
		  		<cfif StructKeyExists(url,"item")>
		  			<cfoutput>#objDashboard.TestCaseHub(url.item)#</cfoutput>
		  		</cfif>
		  		<div id="midrow" class="row"></div>
		  	</div>
		  	<div id="actioncontent" class="col-xs-3 col-sm-3 col-md-3 col-lg-3">
		  		<cfif Application.EnableChat>
		  			<div class="panel panel-default">
		  				<div class="panel-heading"><i class="fa fa-users"></i> Chat</div>
		  				<div class="panel-body"><cfinclude template="chat.cfm" /></div>
		  			</div>
		  		</cfif>
		  		<cfif !StructKeyExists(url,"reports")>
		  			<cfoutput>#objDashboard.GetLinks()#</cfoutput>
		  		</cfif>
		  		<!---<cfif StructKeyExists(url,"projectid") && IsNumeric(url.projectId)>
		  			<cfoutput>#objDashboard.getMilestones(url.projectid)#</cfoutput>
		  		</cfif>	  		--->
		  	</div>
		  </div>
	  </div>
	  
	  <div class="modal fade" id="largeModal" tabindex="-1" role="dialog" aria-labelledby="largeModal" aria-hidden="true">
		  <div class="modal-dialog modal-lg" style="background-color:#FFF;">
		    <div class="modal-content" style="background-color:#FFF;">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		        <h4 class="modal-title" id="myModalLabel">
		        	<cfif StructKeyExists(url,"addTestCase")>Add/Edit Test Case</cfif>
		        </h4>
		      </div>
		      <div class="modal-body">
		      	<cfif StructKeyExists(url,"addTestCase")>
		      		<cfoutput>#objForm.TestCaseForm(0,url.item)#</cfoutput>
		      	<cfelseif StructKeyExists(url,"edittc")>
		      		<cfoutput>#objForm.TestCaseForm(url.edittc,url.item)#</cfoutput>
		      	<cfelse>
		        <h3><i class="fa fa-cog fa-spin"></i></h3>
		        </cfif>
		      </div><div class="clearfix"></div>
		      <div class="modal-footer">
		        <button id="btnClose" type="button" class="btn btn-default">Close</button>
		        <button id="btnSave" type="button" class="btn btn-primary">Save changes</button>
		      </div>
		    </div>
  	  	  </div>
  	  </div>
  	  
  	  <div class="modal fade" id="smallModal" tabindex="-1" role="dialog" aria-labelledby="smallModal" aria-hidden="true">
		  <div class="modal-dialog modal-sm" style="background-color:#FFF;">
		    <div class="modal-content" style="background-color:#FFF;">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		        <h4 class="modal-title" id="myModalLabel">Small Modal</h4>
		      </div>
		      <div class="modal-body">
		        <h3><i class="fa fa-cog fa-spin"></i></h3>
		      </div><div class="clearfix"></div>
		      <div class="modal-footer">
		        <button id="btnClose" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		        <button id="btnSave" type="button" class="btn btn-primary">Save changes</button>
		      </div>
		    </div>
  	   	</div> 
	 </div>
	 
</body>
</html>