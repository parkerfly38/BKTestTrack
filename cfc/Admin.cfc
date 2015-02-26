component 
{
	remote any function viewAllUsers() output="true" {
		arrUsers = EntityLoad("TTestTester");
		writeOutput("<table class='table table-condensed table-striped table-hover'><thead><tr><th>User Name</th><th>Email</th><th>Password</th><th>Is Approved</th><th></th></tr></thead><tbody>");
		for (i = 1; i <= ArrayLen(arrUsers); i++)
		{
			writeOutput("<tr><td><input type='hidden' id='userid' value='" & arrUsers[i].getId() & "' />" & arrUsers[i].getUserName() & "</td><td><input type='email' class='form-control' id='useremail' value='" & arrUsers[i].getEmail() & "' /></td><td><input type='password' id='userpassword' class='form-control' value='" & arrUsers[i].getPassword() & "' /></td><td><input type='checkbox' id='isApproved'");
			if ( arrUsers[i].getisApproved() ) {
				writeOutput(" checked='checked'");
			}
			writeOutput(" /></td><td><a href='##' class='lnkSaveUserChanges btn btn-primary'>Save</a> <a href='##' class='lnkDeleteUser btn btn-danger'>Delete</a></td></tr>");
		}
		writeOutput("</tbody></table>");
	}
	
	remote any function saveUser(required numeric userid, required string email, required string password, required boolean isApproved )
	{
		arrUser = EntityLoadByPK("TTestTester",arguments.userid);
		if ( arrUser.getPassword() != arguments.password) {
			objLogon = createObject("component","Logon");
			salt = objLogon.genSalt();
			newpw = objLogon.computeHash(arguments.password,salt);
			arrUser.setPassword(newpw);
			arrUser.setSalt(salt);
		}
		arrUser.setEmail(arguments.email);
		arrUser.setIsApproved(arguments.isApproved);
		EntitySave(arrUser);
		location("settings.cfm?ac=users",false);
	}
}