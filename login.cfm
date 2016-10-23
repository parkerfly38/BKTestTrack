<!DOCTYPE html>
<html lang="en">
	<head>
		<title>The Crucible :: Login</title>
		<link rel="icon" href="favicon.ico" type="image/x-icon" />		
	    <meta charset="utf-8">
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	    <meta name="viewport" content="width=device-width, initial-scale=1">
	    <meta name="description" content="">
	    <meta name="author" content="">
    	<!-- Bootstrap Core CSS -->
		<link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
		
		<!-- MetisMenu CSS -->
		<link href="vendor/metisMenu/metisMenu.min.css" rel="stylesheet">
		
		<!-- Custom CSS -->
		<link href="dist/css/sb-admin-2.css" rel="stylesheet">
		
		<!-- Custom Fonts -->
		<link href="vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
			
		
	    <!-- jQuery -->
	    <script src="vendor/jquery/jquery.min.js"></script>
		
		<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
		<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
		<!--[if lt IE 9]>
		    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
		    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
		<![endif]-->

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
<div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="login-panel panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">Please Sign In</h3>
                    </div>
                    <div class="panel-body">
                        <form role="form" name="login-form" class="login-form" action="index.cfm" method="post">
                            <fieldset>
                                <div class="form-group">
                                    <input class="form-control" placeholder="Username" name="username" type="text" autofocus>
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="Password" name="password" type="password" value="">
                                </div>
                                <div class="checkbox">
                                    <label>
                                        <input name="remember" type="checkbox" value="Remember Me">Remember Me
                                    </label>
                                </div>
                                <!-- Change this to a button or input when using this as a form -->
                                <!--<a href="index.html" class="btn btn-lg btn-success btn-block">Login</a>-->
                                <cfif !Application.useLDAP><input type="button" class="btn btn-lg btn-success btn-block" data-toggle="modal" data-target="#largeModal" value="New User" /></cfif> <input type="submit" name="submit" value="Login" class="btn btn-lg btn-success btn-block" />
                            </fieldset>
                        </form>
                        <cfif !Application.UseLDAP>
	<div id="creationSuccess" class="alert alert-success" role="alert" style="display:none;">
					  <h4>Account Created</h4>
					  <p><strong>You can't login yet, though.</strong>  You'll be notified when your account is activated.</p>
			    </div>
	</div>
</cfif>
                    </div>
                </div>
            </div>
        </div>
    </div>
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

    <!-- Bootstrap ore JavaScript -->
    <script src="vendor/bootstrap/js/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="vendor/metisMenu/metisMenu.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="dist/js/sb-admin-2.js"></script>

</body>

</html>

		