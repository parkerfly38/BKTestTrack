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
	    <title>COG Test Tracker</title>
		<link rel="stylesheet" href="style/bootstrap.css" />
		<link href="font-awesome-4.2.0/css/font-awesome.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="style/datepicker3.css" />
		<link rel="stylesheet" href="style/bootstrap-select.min.css" />
		<script type="text/javascript" src="scripts/jquery-1.10.2.min.js"></script>
		<script type="text/javascript" src="scripts/bootstrap.min.js"></script>
		<script type="text/javascript">
			// <!--
			var projectid<cfif StructKeyExists(Session,"ProjectID")> = <cfoutput>#Session.ProjectID#</cfoutput></cfif>;
			// -->
		</script>
		<script type="text/javascript" src="scripts/functions.js"></script>
		<script type="text/javascript" src="scripts/ChartNew.js"></script>
		<script type="text/javascript" src="scripts/bootstrap-datepicker.js"></script>
		<script type="text/javascript" src="scripts/bootstrap-select.min.js"></script>
		<style>
			body { padding-top: 60px; background: url('images/bg.png'); }
			.rowoffset { margin-bottom: 20px; }
			.form-group.required .control-label:after {
				content:"*";
				color:red;
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
		        	<li><a id="lnkReturnAllProjects" href="#"><i class="fa fa-long-arrow-left"></i> All Projects Dashboard</a></li>
		        	<li><a id="lnkReturnToProject" class="pjlink" href="#" style="display:none;"><i class="fa fa-long-arrow-left"></i>  Back to Project</a></li>
		        </ul>
		        <ul class="nav navbar-nav">
		          <li><a id="lnkAssignedTests" href="#" userid="<cfoutput>#Session.UserIDInt#</cfoutput>"> <i class="fa fa-tasks"></i> Tests Assigned <span class="badge"><cfoutput>#local.testsAssigned#</cfoutput></span></a></li>
		          <li><a href="index.html"> <i class="fa fa-gear"></i> Settings</a></li>
		          <li><a href="cfc/Logon.cfc?method=Logout"> <i class="fa fa-power-off"></i> Log out</a></li>
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
</body>
</html>