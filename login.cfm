<html>
	<head>
		<title>COG Test Tracker :: Login</title>
		<link rel="icon" href="favicon.ico" type="image/x-icon" />
		<link rel="stylesheet" type="text/css" href="style/style.css">
		<link rel="stylesheet" type="text/css" href="style/bootstrap.css">
		<script type="text/javascript" src="scripts/jquery-1.10.2.min.js"></script>
		<script type="text/javascript" src="scripts/bootstrap.min.js"></script>
		<cfif !Application.useLDAP>
		<script type="text/javascript">
			$(document).ready(function(){
				$("#btnSave").click(function(event){
					event.preventDefault();
					$.ajax({
						url: "/CFTestTrack/CFC/Logon.cfc?method=createFormAccount",
						type: "POST",
						data: {
							ADID : $("#txtADID").val(),
							UserName : $("#txtUserName").val(),
							password : $("#txtPassword").val(),
							password2 : $("#txtPassword2").val(),
							email : $("#txtEmail").val()
						}
					}).done(function(data) {
						if ( data != "success") { 
							$("#errMessage").html(data);
							$("#creationError").fadeIn("fast");
						} else {
							$('#largeModal').modal('hide');
							$('#creationSuccess').fadeIn("fast");
						}
					});
				});
			});
		</script>
		</cfif>
	</head>
	<body>
<div id="wrapper">

	<form name="login-form" class="login-form" action="index.cfm" method="post">
		
		<div class="header">
		<h1>Login Form</h1>
		<cfif Application.useLDAP>
			<span>Enter your Windows login, the same you use to access your workstation.</span>
		</cfif>
		<cfif Application.AxoSoftIntegration>
			<span>If this is your first time logging in since registration, ensure you've logged into your AxoSoft instance prior to logging in here.</span>
		</cfif>
		</div>
	
		<div class="content">
		<input name="username" id="username" type="text" class="input username" placeholder="Username" />
		<div class="user-icon"></div>
		<input name="password" id="password" type="password" class="input password" placeholder="Password" />
		<div class="pass-icon"></div>		
		</div>

		<div class="footer">
			<cfif !Application.useLDAP><input type="button" class="button" data-toggle="modal" data-target="#largeModal" value="New User" /></cfif> <input type="submit" name="submit" value="Login" class="button" />
		</div>
	
	</form>
<cfif !Application.UseLDAP>
	<div id="creationSuccess" class="alert alert-success" role="alert" style="display:none;">
					  <h4>Account Created</h4>
					  <p><strong>You can't login yet, though.</strong>  You'll be notified when your account is activated.</p>
			    </div>
	</div>
</cfif>
<div class="gradient"></div>

		 <div class="modal fade" id="largeModal" tabindex="-1" role="dialog" aria-labelledby="largeModal" aria-hidden="true">
		  <div class="modal-dialog modal-lg" style="background-color:#FFF;">
		    <div class="modal-content" style="background-color:#FFF;">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		        <h4 class="modal-title" id="myModalLabel">Create New Account</h4>
		      </div>
		      <div class="modal-body">
		      	<div id="creationError" class="alert alert-danger" role="alert" style="display:none;">
					  <h4>Oh snap!</h4>
					  <p id="errMessage"></p>
			    </div>
		        <div class="form-group">
		        	<label for="txtADID">User ID</label>
		        	<input type="text" id="txtADID" class="form-control" placeholder="Create unique login id" />
		        </div>
		        <div class="form-group">
		        	<label for="txtUserName">User Name</label>
		        	<input type="text" id="txtUserName" class="form-control" placeholder="Enter your name" />
		        </div>
		        <div class="form-group">
		        	<label for="txtPassword">Enter a Password</label>
		        	<input type="password" id="txtPassword" class="form-control" placeholder="Enter a password" />
		       	</div>
		       	<div class="form-group">
		       		<input type="password" id="txtPassword2" class="form-control" placeholder="Repeat password" />
		       	</div>
		       	<div class="form-group">
		       		<label for="txtEmail">Enter Email Address</label>
		       		<input type="email" id="txtEmail" class="form-control" placeholder="youremail@domain.com" />
		       	</div>
		      </div><div class="clearfix"></div>
		      <div class="modal-footer">
		        <button id="btnClose" type="button" class="btn btn-default" data-toggle="modal" data-target="#largeModal" style="float:left;">Cancel</button>
		        <button id="btnSave" type="button" class="btn btn-primary">Create Account</button>
		      </div>
		    </div>
  	  </div>
	</body>
	</html>
		