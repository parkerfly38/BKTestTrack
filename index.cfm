<cfscript>
	Session.PageActivity = Now();
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
	    <title>The Crucible Test Suite</title>
	    <!-- Bootstrap Core CSS -->
	    <link href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	    <!-- MetisMenu CSS -->
	    <link href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">
	    <!-- Custom CSS -->
	    <link href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/dist/css/sb-admin-2.css" rel="stylesheet">
	    <!-- Morris Charts CSS -->
	    <link href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/vendor/morrisjs/morris.css" rel="stylesheet">
	    <!-- Custom Fonts -->
	    <link href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
	    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
	    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	    <!--[if lt IE 9]>
	        <script src="http://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
	        <script src="http://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	    <![endif]-->
	    <link rel="icon" href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/favicon.ico" type="image/x-icon" />
		<link rel="stylesheet" href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/style/datepicker3.css" />
		<link rel="stylesheet" href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/style/bootstrap-select.min.css" />
	    <!-- jQuery -->
    	<script src="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/vendor/jquery/jquery.min.js"></script>
	    <!-- Bootstrap Core JavaScript -->
	    <script src="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/vendor/bootstrap/js/bootstrap.min.js"></script>
	    <!-- Metis Menu Plugin JavaScript -->
	    <script src="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/vendor/metisMenu/metisMenu.min.js"></script>
	    <!-- Morris Charts JavaScript -->
	    <!---<script src="../vendor/raphael/raphael.min.js"></script>
	    <script src="../vendor/morrisjs/morris.min.js"></script>
	    <script src="../data/morris-data.js"></script>--->
	    <!-- Custom Theme JavaScript -->
	    <script src="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/dist/js/sb-admin-2.js"></script>
		<cfoutput>
		<script type="text/javascript">
			var projectid;
			<cfif StructKeyExists(url,"ProjectID")>projectid = #url.ProjectID#;</cfif>
		</script>
		</cfoutput>
		<script type="text/javascript" src="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/scripts/cftracker.js"></script>
		<cfif StructKeyExists(URL,"TR")>
		<script type="text/javascript">
			$(document).ready(function() {
				var trid = <cfoutput>#URL.TR#</cfoutput>;
				$("#largeModal .modal-title").text("Test Result");
				$("#largeModal .modal-body").load("http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/cfc/dashboard.cfc?method=getTestResult&testresultid="+trid);
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
		<script type="text/javascript" src="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/scripts/ChartNew.js"></script>
		<script type="text/javascript" src="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/scripts/bootstrap-datepicker.js"></script>
		<script type="text/javascript" src="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/scripts/bootstrap-select.min.js"></script>
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
			/*body { padding-top: 60px; }*/
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
	
      	
	    <div id="wrapper">
	    	
	    <!-- Navigation -->
		<nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
		      <div class="navbar-header">
		      	<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
		            <span class="sr-only">Toggle navigation</span>
		            <span class="icon-bar"></span>
		            <span class="icon-bar"></span>
	            	<span class="icon-bar"></span>
	          	</button>
	          	<cfif (StructKeyExists(url,"projectid") && isNumeric(url.projectid)) || isNumeric(Session.projectID)>
	          		<!--- get at our project title --->
	          		<cfset projectid = (StructKeyExists(url,"projectid") ? url.projectid : Session.projectid) >
	          		<a class="navbar-brand" href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/<cfoutput>project/#session.projectID#/</cfoutput>" id="lnkHome">
	          		&nbsp;<cfoutput>#EntityLoadByPk("TTestProject",projectid).getProjectTitle()#</cfoutput>
	          		</a>
	          		<cfelse><a class="navbar-brand">The Crucible</a>
	          		</cfif>
	          </div>
		      <ul class="nav navbar-top-links navbar-right">
                <cfif Application.EnableChat>
                <li class="dropdown">
                    <a id="ddmess" class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-envelope fa-fw"></i> <i class="fa fa-caret-down"></i>
                    </a>
                    <ul id="messagesdd" class="dropdown-menu dropdown-messages">
                        <cfinclude template="chat_mini.cfm" />
                    </ul>
                    <!-- /.dropdown-messages -->
                </li>
                </cfif>
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-user">
                        <!---<li><a href="#"><i class="fa fa-user fa-fw"></i> User Profile</a>
                        </li>--->
                        <cfif STructKeyExists(Session, "isadmin") AND SESSION.IsAdmin eq "true"><li><a href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/settings/"><i class="fa fa-gear fa-fw"></i> Settings</a>
                        </li>
                        <li class="divider"></li></cfif>
                        <li><a href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/logout/"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                        </li>
                    </ul>
                    <!-- /.dropdown-user -->
                </li>
                <!-- /.dropdown -->
            </ul>
            <!-- /.navbar-top-links -->
            <div class="navbar-default sidebar" role="navigation">
                <div class="sidebar-nav navbar-collapse">
                    <ul class="nav" id="side-menu">
                    	<cfif StructKeyExists(url,"projectid") || isNumeric(Session.projectID)>
  		<li><a href="/CFTestTrack/" <!---class="btn btn-default" style="position: fixed; top: -3px; left: -3px;z-index:9999;"--->><i class="fa fa-arrow-left"></i>&nbsp;Main Dashboard</a></li>
      	</cfif>
                    	<cfif Application.AxoSoftIntegration>
		  				<cfoutput>#objDashboard.listAxoSoftProjects(objAxoSoft.getProjects(Session.AxoSoftToken))#</cfoutput>
		  				<cfelse>
		  				<cfoutput>#objDashboard.listProjects()#</cfoutput>
		  				</cfif>
		          <cfif (StructKeyExists(url,"projectid") && isNumeric(url.projectid))  || isNumeric(Session.projectID)>
		       		<!---<li><a href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/project/<cfoutput>#session.projectid#</cfoutput>/"><!---<i class="fa fa-home"></i>---> Project Home</a></li>--->
		          	<li>
		          	<a href="#"><i class="fa fa-map-marker fa-fw"> </i> Milestones<span class="fa arrow"></span></a>
		          	<ul class="nav nav-second-level">
		          		<li><a href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/project/<cfoutput>#session.projectid#</cfoutput>/allmilestones/">View All</a></li>
		          		<li><a class="lnkAddMilestone" href="##">Add</a></li>
		          	</ul>
		          </li>
		          <li><a href="#"><i class="fa fa-suitcase fa-fw"> </i> Test Scenarios<span class="fa arrow"></span></a>
		          	<ul class="nav nav-second-level">
		          		<li><a href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/project/<cfoutput>#session.projectid#</cfoutput>/allscenarios/">View All</a></li>
		          		<li><a class="lnkAddScenario" href="##">Add</a></li>
		          		<li><a class="lnkAddSections" href="##">Add Test Sections</a></li>
		          	</ul>
		          </li>
		          <li><a href="#"><i class="fa fa-tachometer fa-fw"> </i> Test Cases<span class="fa arrow"></span></a>
		          	<ul class="nav nav-second-level">
		          		<li><a href="http://<cfoutput>#Application.HttpsUrl#</cfoutput>/CFTestTrack/project/<cfoutput>#session.projectid#</cfoutput>/alltests/">View All</a></li>
		          		<li><a class="lnkAddTest" href="#">Add</a></li>
		          		<li class="divider"></li>
		          		<li class="dropdown-header">Bulk Actions</li>
		          		<li><a class="lnkDownloadTestCaseTemplate" href="#">Download Template</a></li>
		          		<li><a class="lnkUploadTestCases" href="#">Upload Via Excel</a></li>
		          	</ul>
		          </li>
		          <li><a href="#"><i class="fa fa-list-alt fa-fw"> </i> Automation Studio<span class="fa arrow"></span></a>
		          	<ul class="nav nav-second-level">
		          		<li><a class="lnkBuildAutomatedTest" href="#">Build Test</a></li>
		          		<li><a class="lnkScheduleTests" href="#">Schedule Tests</a></li>
		          		<li><a class="lnkTestScriptLibrary" href="#">Test Script Library</a></li>
		          		<li class="divider"></li>
		          		<li><a class="lnkViewScheduledTests" href="#">View Scheduled Tests</a></li>
		          		<li><a class="" href="#">Automated Test Activity</a></li>
		          	</ul>
		          </li>
		          <li>
		          	<a class="lnkViewReports" href="#"><i class="fa fa-bars fa-fw"> </i> Reporting</a>
		          </li>
		          </cfif>
		        </ul>
		      </div><!--/.nav-collapse -->
		      </div>
	    </nav>
	    <!-- end navigation -->
	    
	 <div id="page-wrapper">
            <cfif StructIsEmpty(url)>	  		
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Dashboard</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <div class="row">
            	<div class="col-lg-12">
            		<cfif !Application.AxoSoftIntegration>
            			<cfoutput>#objDashboard.UserDashPart()#</cfoutput>
		  				<cfoutput>#objDashboard.AllProjectsChart()#</cfoutput>
		  			</cfif>
		  		</div>
		  	</div>
            </cfif>
            <cfif StructKeyExists(url,"scenarioid")>
            <div class="row">
            	<div class="col-lg-12">
            	<cfif isNumeric(url.scenarioid)>
		  			<cfoutput>#objDashboard.TestScenarioHub(url.scenarioid)#</cfoutput>
		  		</cfif>
		  		</div>
		  	</div>
		  	</cfif>
		  	<cfif StructKeyExists(url,"projectid")>
		  	<div class="row">
		  		<div class="col-lg-12">
		  			<cfif isNumeric(url.projectid) && !StructKeyExists(url,"edit")>
		  				<cfif StructKeyExists(url, "allmilestones")>
		  					<cfoutput>#objDashboard.AllMilestones(session.ProjectID)#</cfoutput>
		  				<cfelseif StructKeyExists(url, "allscenarios")>
		  					<cfoutput>#objDashboard.AllScenarios(session.ProjectID)#</cfoutput>
		  				<cfelseif StructKeyExists(url, "alltests")>
		  					<cfoutput>#objDashboard.AllTests(session.ProjectID)#</cfoutput>
		  				<cfelse>
			  				<cfoutput>#objDashboard.HubChart(url.projectid)#</cfoutput>
			  				<cfoutput>#objDashboard.mileStoneTimeline(url.projectid)#</cfoutput>
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
			  			</cfif>
		  			<cfelse>
					  	<cfif isNumeric(url.projectid)>
						  	<cfoutput>#objForm.ProjectForm(url.projectid)#</cfoutput>
						<cfelse>
		  					<cfoutput>#objForm.ProjectForm()#</cfoutput>
						</cfif>
		  			</cfif>
		  			</div>
		  			</div>
		  		</cfif>
     </div>
		  	
		  	
		  		
		  		<cfif StructKeyExists(url, "testcase")>
		  			<cfif isNumeric(url.testcase)>
		  				<cfoutput>#objForm.TestCaseForm(url.testcase)#</cfoutput>
		  			</cfif>
		  		</cfif>
		  		
		  		
		  		<cfif StructKeyExists(url,"item")>
		  			<cfoutput>#objDashboard.TestCaseHub(url.item)#</cfoutput>
		  		</cfif>
		  		<div id="midrow" class="row"></div>
		  	</div>
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
	 <!---<cfdump var="#session#">--->
	 </div>
</body>
</html>
