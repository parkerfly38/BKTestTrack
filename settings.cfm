<cfscript>
	objData = createObject("component","cfc.Data");
	objDashboard = createObject("component","cfc.Dashboard");
	objAdmin = createObject("component","cfc.Admin");
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
	    <title>The Crucible :: Settings</title>
	    <link rel="icon" href="favicon.ico" type="image/x-icon" />
		<link rel="stylesheet" href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/style/bootstrap.css" />
		<link href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/font-awesome-4.2.0/css/font-awesome.min.css" rel="stylesheet" />
		<script type="text/javascript" src="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/scripts/jquery-1.10.2.min.js"></script>
		<script type="text/javascript" src="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/scripts/bootstrap.min.js"></script>
		<style>
			body { padding-top: 60px; background-color: #9F5F9F; }
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
		</style>
	</head>
	<body>
		<a href="/CFTestTrack/" class="btn btn-default" style="position: fixed; top: -3px; left: -3px;z-index:9999;"><i class="fa fa-arrow-left"></i>&nbsp;Dashboard</a>
		<nav class="navbar navbar-default navbar-fixed-top">
		    <div class="container">
		      <div class="navbar-header">
		      	<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
		            <span class="sr-only">Toggle navigation</span>
		            <span class="icon-bar"></span>
		            <span class="icon-bar"></span>
	            	<span class="icon-bar"></span>
	          	</button>
	          	<a class="navbar-brand">The Crucible</a>
	          </div>
		      <div id="navbar" class="navbar-collapse collapse">
		      
		        <ul class="nav navbar-nav">
		          <li><a id="lnkReturnToProject" class="pjlink" style="display:none;" href="index.cfm"><i class="fa fa-home"></i> Home</a></li>
		          <li><a href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/settings.cfm?ac=users">Users</a></li>
		          <li><a href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/settings.cfm?ac=settings">System Settings</a></li>
		          <li><a href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/settings.cfm?ac=sked">Scheduled Tasks</a></li>
		          <li><a href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/settings.cfm?ac=links">Links</a></li>
		          <li><a href="http://<cfoutput>#cgi.server_name#</cfoutput>/CFTestTrack/logout/"> <i class="fa fa-power-off"></i> Log out</a></li>
		        </ul>
		      </div><!--/.nav-collapse -->
		    </div>
	    </nav>
	    
	  <div class="container-fluid" style="background:none;">
		  <div class="row">
		  	<div id="featurecontent" class="col-xs-9 col-sm-9 col-md-9 col-lg-9">
		  		<cfif StructKeyExists(URL,"ac")>
		  			<cfif url.ac eq "users">
		  				<div class='panel panel-default'>
		  					<div class="panel panel-heading"><h4>User Administration</h4></div>
		  					<div class="panel panel-body">
		  						<cfoutput>#objAdmin.viewAllUsers()#</cfoutput>
		  					</div>
		  				</div>
		  			</cfif>
		  			<cfif url.ac eq "settings">
		  				<div class='panel panel-default'>
		  					<div class='panel panel-heading'><h4>System Settings</h4></div>
		  					<div class='panel panel-body'>
		  						<cfoutput>#objAdmin.viewSettings()#</cfoutput>
		  					</div>
		  				</div>
		  			</cfif>
		  			<cfif url.ac eq "sked">
		  				<div class="panel panel-default">
		  					<div class="panel panel-heading"><h4>Scheduled Tasks</h4></div>
		  					<div class="panel panel-body">
		  						<cfoutput>#objAdmin.viewAllScheduledTasks()#</cfoutput>
		  					</div>
		  				</div>
		  			</cfif>
		  			<cfif url.ac eq "links">
		  				<div class="panel panel-default">
		  					<div class="panel panel-heading"><h4>Links</h4></div>
		  					<div class="panel panel-body">
		  						<cfoutput>#objAdmin.viewAllLinks()#</cfoutput>
		  					</div>
		  				</div>
		  			</cfif>
		  			<cfif url.ac eq "userkeys">
		  				<div class="panel panel-default">
		  					<div class="panel panel-heading"><h4>User API Keys</h4></div>
		  					<div class="panel panel-body">
		  						<cfoutput>#objAdmin.viewAPIByUser(url.user)#</cfoutput>
		  					</div>
		  				</div>
		  			</cfif>
		  		</cfif>
		  		<div id="midrow" class="row"></div>
		  	</div>
		  	<div id="actioncontent" class="col-xs-3 col-sm-3 col-md-3 col-lg-3"></div>
		  </div>
	  </div>
	  
	  <!---<div class="modal fade" id="largeModal" tabindex="-1" role="dialog" aria-labelledby="largeModal" aria-hidden="true">
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
	 </div>--->
</body>
</html>