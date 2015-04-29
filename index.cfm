<cfscript>
	objData = createObject("component","cfc.Data");
	objDashboard = createObject("component","cfc.Dashboard");
	local.testsAssigned = objDashboard.assignedTestsCount(Session.UserIDInt);
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
	    <link rel="icon" href="favicon.ico" type="image/x-icon" />
		<link rel="stylesheet" href="style/bootstrap.css" />
		<link href="font-awesome-4.2.0/css/font-awesome.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="style/datepicker3.css" />
		<link rel="stylesheet" href="style/bootstrap-select.min.css" />
		<script type="text/javascript" src="scripts/jquery-1.10.2.min.js"></script>
		<script type="text/javascript" src="scripts/bootstrap.min.js"></script>
		<cfoutput>
		<script type="text/javascript">
			
			var projectid;
			<cfif StructKeyExists(Session,"ProjectID")>projectid = #Session.ProjectID#;</cfif>
			
		</script>
		</cfoutput>
		<script type="text/javascript" src="scripts/cftracker.js"></script>
		<cfif StructKeyExists(URL,"TR")>
		<script type="text/javascript">
			$(document).ready(function() {
				var trid = <cfoutput>#URL.TR#</cfoutput>;
				$("#largeModal .modal-title").text("Test Result");
				$("#largeModal .modal-body").load("cfc/dashboard.cfc?method=getTestResult&testresultid="+trid);
				$("#largeModal").modal("show");
			});
		</script>
		</cfif>
		<script type="text/javascript" src="scripts/ChartNew.js"></script>
		<script type="text/javascript" src="scripts/bootstrap-datepicker.js"></script>
		<script type="text/javascript" src="scripts/bootstrap-select.min.js"></script>
		<cfif StructKeyExists(URL,"TC")>
		<script type="text/javascript">
			$(document).ready(function() {
			$("#largeModal .modal-title").text("Edit Test Case");
			$("#largeModal .modal-body").load("cfc/forms.cfc?method=TestCaseForm&testcaseid="+<cfoutput>#url.TC#</cfoutput>);
			$("#largeModal").modal("show");
			});
		</script>
		</cfif>
		<style>
			body { padding-top: 60px; background: url('images/bg.png'); }
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
	<body>
		<nav class="navbar navbar-inverse navbar-fixed-top">
		    <div class="container">
		      <div class="navbar-header">
		      	<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
		            <span class="sr-only">Toggle navigation</span>
		            <span class="icon-bar"></span>
		            <span class="icon-bar"></span>
	            	<span class="icon-bar"></span>
	          	</button>
	          	<a class="navbar-brand" href="#" id="lnkHome">CFTestTrack</a>
	          </div>
		      <div id="navbar" class="navbar-collapse collapse">
		        <ul id="uldashboard" class="nav navbar-nav navbar-right" <cfif !StructKeyExists(Session,"ProjectID")>style="display:none;"</cfif>>
		        	<li><a id="lnkReturnAllProjects" href="#" style="display:none;"><i class="fa fa-long-arrow-left"></i> All Projects Dashboard</a></li>
		        </ul>
		        <ul class="nav navbar-nav">
		          <li><a id="lnkReturnToProject" class="pjlink" style="display:none;" href="#"><!---<i class="fa fa-home"></i>---> Project Home</a></li>
		          <li class="dropdown ddmMilestones" style="display:none;"><a href="##" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="true"><!---<i class="fa fa-map-marker"> </i> --->Milestones</a>
		          	<ul class="dropdown-menu" role="menu">
		          		<li><a class="lnkViewMilestones" href="#">View All</a></li>
		          		<li><a class="lnkAddMilestone" href="##">Add</a></li>
		          		<li class="divider"></li>
		          		<li class="dropdown-header">Reports</li>
		          	</ul>
		          </li>
		          <li class="dropdown ddmScenarios" style="display:none;"><a href="##" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="true"><!---<i class="fa fa-suitcase"> </i>---> Test Scenarios</a>
		          	<ul class="dropdown-menu" role="menu">
		          		<li><a class="lnkViewScenarios" href="##">View All</a></li>
		          		<li><a class="lnkAddScenario" href="##">Add</a></li>
		          	</ul>
		          </li>
		          <li class="dropdown ddmTestCases" style="display:none;"><a href="##" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="true"><!---<i class="fa fa-tachometer"> </i>--->Test Cases</a>
		          	<ul class="dropdown-menu" role="menu">
		          		<li><a class="lnkViewTests" href="#">View All</a></li>
		          		<li><a class="lnkAddTest" href="#">Add</a></li>
		          		<li class="divider"></li>
		          		<li class="dropdown-header">Bulk Actions</li>
		          		<li><a class="lnkDownloadTestCaseTemplate" href="#">Download Template</a></li>
		          		<li><a class="lnkUploadTestCases" href="#">Upload Via Excel</a></li>
		          	</ul>
		          </li>
		          <li class="dropdown ddmAutomationStudio" style="display:none;"><a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="true"><!---<i class="fa fa-list-alt"> </i> --->Automation Studio</a>
		          	<ul class="dropdown-menu" role="menu">
		          		<li><a class="lnkBuildAutomatedTest" href="#">Build Test</a></li>
		          		<li><a class="lnkScheduleTests" href="#">Schedule Tests</a></li>
		          		<li><a class="lnkTestScriptLibrary" href="#">Test Script Library</a></li>
		          		<li class="divider"></li>
		          		<li><a class="lnkViewScheduledTests" href="#">View Scheduled Tests</a></li>
		          		<li><a class="" href="#">Automated Test Activity</a></li>
		          	</ul>
		          </li>
		          <li><a class="lnkViewReports" href="#" style="display:none;"><!---<i class="fa fa-bars"> </i> --->Reporting</a></li>
		          <li><a href="settings.cfm"> <!---<i class="fa fa-gear"></i>---> Settings</a></li>
		          <li><a href="cfc/Logon.cfc?method=Logout"> <!---<i class="fa fa-power-off"></i>---> Log out</a></li>
		        </ul>
		      </div><!--/.nav-collapse -->
		    </div>
	    </nav>
	    
	  <div class="container-fluid" style="background:none;">
		  <div class="row">
		  	<div id="featurecontent" class="col-xs-9 col-sm-9 col-md-9 col-lg-9">
		  		<div id="midrow" class="row"></div>
		  	</div>
		  	<div id="actioncontent" class="col-xs-3 col-sm-3 col-md-3 col-lg-3"></div>
		  </div>
	  </div>
	  
	  <div class="modal fade" id="largeModal" tabindex="-1" role="dialog" aria-labelledby="largeModal" aria-hidden="true">
		  <div class="modal-dialog modal-lg" style="background-color:#FFF;">
		    <div class="modal-content" style="background-color:#FFF;">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		        <h4 class="modal-title" id="myModalLabel">Large Modal</h4>
		      </div>
		      <div class="modal-body">
		        <h3>Modal Body</h3>
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
		        <h3>Modal Body</h3>
		      </div><div class="clearfix"></div>
		      <div class="modal-footer">
		        <button id="btnClose" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		        <button id="btnSave" type="button" class="btn btn-primary">Save changes</button>
		      </div>
		    </div>
  	   	</div> 
	 </div>
	 <div class="modal fade" id="chatModal" tabindex="-1" role="dialog" aria-labelledby="chatModal" aria-hidden="true">
		  <div class="modal-dialog modal-sm" style="background-color:#FFF;">
		    <div class="modal-content" style="background-color:#FFF;">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		        <h4 class="modal-title" id="myModalLabel">Chat</h4>
		      </div>
		      <div class="modal-body" style="overflow:scroll;height:300px;">
		        <h3>Modal Body</h3>
		      </div><div class="clearfix"></div>
		      <div class="modal-footer">
		        <div class="input-group">
		        	<input type="text" id="chatmessage" class="form-control" placeholder="Type your chat message..." />
		        	<span class="input-group-btn"><button class='sendchat btn btn-info' type='button' fromid='0' toid='0'>Send</button></span>
		        </div>		        
		      </div>
		    </div>
  	   	</div> 
	 </div>
</body>
</html>