component 
{
	remote any function viewAllLinks() output="true" {
		writeOutput("<script type='text/javascript'>" & chr(13));
		writeOutput("	$(document).ready(function() { " & chr(13));
		writeOutput("	  $(document).on('click','a.lnkSaveLink',function() { "&chr(13));
		writeOutput("		var row = $(this).closest('tr');" & chr(13));
		writeOutput("		var description = row.find('##linkdesc').val(); " & chr(13) );
		writeOutput("		var linkid = row.find('##linkid').val(); " & chr(13) );
		writeOutput("		var link = row.find('##linkhref').val(); " & chr(13));
		writeOutput("		$.ajax({url:'cfc/Admin.cfc?method=saveLink',type:'POST',data : { id : linkid, linkhref : link, linkdesc : description}}).done(function() { location.href = 'settings.cfm?ac=links'; });");
		writeOutput("	  });" & chr(13));
		writeOutput("	 $(document).on('click','a.lnkDeleteLink',function() { " & chr(13));
		writeOutput("		var row = $(this).closest('tr');" & chr(13));
		writeOutput("		var id = row.find('##linkid').val(); " & chr(13));
		writeOutput("		$.ajax({url:'cfc/Admin.cfc?method=deleteLink',type:'POST',data: { linkid : id}");
		writeOutput("	  }).done(function() { location.href = 'settings.cfm?ac=links'; });" & chr(13));
		writeOutput("	 });" & chr(13));
		writeOutput("	});" & chr(13));
		writeOutput("</script>"&chr(13));
		arrLinks = EntityLoad("TTestLinks");
		writeOutput("<table class='table table-condensed table-striped table-hover'><thead><tr><th>Link</th><th>Link Description</th><th></th></tr></thead><tbody>");
		for (i = 1; i <= ArrayLen(arrLinks); i++)
		{
			writeOutput("<tr><td><input type='hidden' id='linkid' value='" & arrLinks[i].getId() & "' /><input type='text' class='form-control' id='linkhref' value='" & arrLinks[i].getLinkHref() & "' /></td><td><input type='text' id='linkdesc' class='form-control' value='" & arrLinks[i].getLinkDesc() & "' /></td><td><a href='##' class='lnkSaveLink btn btn-xs btn-primary'>Save</a> <a href='##' class='lnkDeleteLink btn btn-xs btn-danger'>Delete</a></td></tr>" & chr(13));
		}
		writeOutput("<tr><td><input type='hidden' id='linkid' value='0' /><input type='text' class='form-control' id='linkhref' class='form-control' placeholder='New Href' /></td><td><input type='text' id='linkdesc' class='form-control' placeHolder='Link Description' /></td><td><a href='##' class='lnkSaveLink btn btn-xs btn-primary'>Save</a> <a href='##' class='lnkDeleteLink btn btn-xs btn-danger'>Delete</a></td></tr>"&chr(13));
		writeOutput("</tbody></table>");
	}
		
	remote any function viewAllUsers() output="true" {
		writeOutput("<script type='text/javascript'>" & chr(13));
		writeOutput("	$(document).ready(function() { "&chr(13));
		writeOutput("	  $(document).on('click','a.lnkSaveUserChanges',function() { "&chr(13));
		writeOutput("		var row = $(this).closest('tr');" & chr(13));
		writeOutput("		var useremail = row.find('##useremail').val(); " & chr(13) );
		writeOutput("		var userid = row.find('##userid').val(); " & chr(13) );
		writeOutput("		var password = row.find('##userpassword').val(); " & chr(13));
		writeOutput("		var isapproved; " & chr(13) );
		writeOutput("		if ( row.find('##isApproved').is(':checked') ) { " & chr(13));
		writeOutput("			isapproved = true; " & chr(13));
		writeOutput("		} else { " & chr(13));
		writeOutput("			isapproved = false; " & chr(13));
		writeOutput("		}");
		writeOutput("		$.ajax({url:'cfc/Admin.cfc?method=saveUser',type:'POST',data : { userid : userid, email : useremail, password : password, isApproved : isapproved}}).done(function() { location.href = 'settings.cfm?ac=users'; });");
		writeOutput("	  });" & chr(13));
		writeOutput("	 $(document).on('click','a.lnkDeleteUser',function() { " & chr(13));
		writeOutput("		var row = $(this).closest('tr');" & chr(13));
		writeOutput("		var userid = row.find('##userid').val(); " & chr(13));
		writeOutput("		$.ajax({url:'cfc/Admin.cfc?method=deleteUser',type:'POST',data: { userid : userid}");
		writeOutput("	  }).done(function() { location.href = 'settings.cfm?ac=users'; });" & chr(13));
		writeOutput("	 });" & chr(13));
		writeOutput("	});" & chr(13));
		writeOutput("</script>"&chr(13));
		arrUsers = EntityLoad("TTestTester");
		writeOutput("<table class='table table-condensed table-striped table-hover'><thead><tr><th>User Name</th><th>Email</th><th>Password</th><th>Is Approved</th><th></th></tr></thead><tbody>");
		for (i = 1; i <= ArrayLen(arrUsers); i++)
		{
			writeOutput("<tr><td><input type='hidden' id='userid' value='" & arrUsers[i].getId() & "' />" & arrUsers[i].getUserName() & "</td><td><input type='email' class='form-control' id='useremail' value='" & arrUsers[i].getEmail() & "' /></td><td><input type='password' id='userpassword' class='form-control' value='" & arrUsers[i].getPassword() & "' /></td><td><input type='checkbox' id='isApproved'");
			if ( arrUsers[i].getisApproved() ) {
				writeOutput(" checked='checked'");
			}
			writeOutput(" /></td><td><a href='##' class='lnkSaveUserChanges btn btn-primary'>Save</a> <a href='##' class='lnkDeleteUser btn btn-danger'>Delete</a> <a href='settings.cfm?ac=userkeys&user=" & arrUsers[i].getId() & "' class='btn btn-primary'>API Keys</a></td></tr>");
		}
		writeOutput("</tbody></table>");
	}
	
	remote any function saveUserKey(required integer id, required boolean activated)
	{
		userkey = EntityLoadByPk("TTestAPIUserKeys",arguments.id);
		userkey.setActivated(arguments.activated);
		EntitySave(userkey);
	}
	
	remote any function addUserKey(required integer testerid)
	{
		objData = new CFTestTrack.cfc.Data();
		objData.generatePublicPrivateKeys(arguments.testerid);
	}
	
	remote any function deleteUserKey(required integer id)
	{
		userkey = EntityLoadByPk("TTestAPIUserKeys", arguments.id);
		EntityDelete(userkey);
	}
	
	remote any function viewAPIByUser(integer testerid) output="true" 
	{
		writeOutput("<script type='text/javascript'>" & chr(13));
		writeOutput("	$(document).ready(function() { "&chr(13));
		writeOutput("	  $(document).on('click','a.lnkSaveUserChanges',function() { "&chr(13));
		writeOutput("		var row = $(this).closest('tr');" & chr(13));
		writeOutput("		var id = row.find('##id').val(); " & chr(13) );
		writeOutput("		var activated; " & chr(13) );
		writeOutput("		if ( row.find('##activated').is(':checked') ) { " & chr(13));
		writeOutput("			activated = true; " & chr(13));
		writeOutput("		} else { " & chr(13));
		writeOutput("			activated = false; " & chr(13));
		writeOutput("		}");
		writeOutput("		$.ajax({url:'cfc/Admin.cfc?method=saveUserKey',type:'POST',data : { id : id, activated : activated}}).done(function() { location.href = 'settings.cfm?ac=userkeys&user="&arguments.testerid&"'; });");
		writeOutput("	  });" & chr(13));
		writeOutput("	 $(document).on('click','a.lnkDeleteUser',function() { " & chr(13));
		writeOutput("		var row = $(this).closest('tr');" & chr(13));
		writeOutput("		var id = row.find('##id').val(); " & chr(13));
		writeOutput("		$.ajax({url:'cfc/Admin.cfc?method=deleteUserKey',type:'POST',data: { id : id}");
		writeOutput("	  }).done(function() { location.href = 'settings.cfm?ac=userkeys&user="&arguments.testerid&"'; });" & chr(13));
		writeOutput("	 });" & chr(13));
		writeOutput("	 $(document).on('click','a.lnkAddNewKey', function() {" & chr(13));
		writeOutput("		var testerid = '" & arguments.testerid & "';" & chr(13));
		writeOutput("		$.ajax({url:'cfc/Admin.cfc?method=addUserKey',type:'POST',data: {testerid:testerid}" & chr(13));
		writeOutput("		}).done(function() { location.href = 'settings.cfm?ac=userkeys&user="&arguments.testerid&"'; });" &chr(13));
		writeOutput("	 });" & chr(13));
		writeOutput("	});" & chr(13));
		writeOutput("</script>"&chr(13));
		arrUsers = EntityLoad("TTestAPIUserKeys",{testerid=arguments.testerid});
		writeOutput("<a href='##' class='lnkAddNewKey btn btn-primary'>Add New API Key</a><br />"&chr(13));
		writeOutput("<table class='table table-condensed table-striped table-hover'><thead><tr><th>Public Key</th><th>Private Key</th><th>Is Approved</th><th></th></tr></thead><tbody>");
		for (i = 1; i <= ArrayLen(arrUsers); i++)
		{
			writeOutput("<tr><td><input type='hidden' id='id' value='" & arrUsers[i].getId() & "' />");
			writeOutput("<input type='text' class='form-control' id='clientid' value='" & arrUsers[i].getclientid() & "' disabled='disabled' /></td><td><input type='text' disabled='disabled' id='privatekey' class='form-control' value='" & arrUsers[i].getprivatekey() & "' /></td><td><input type='checkbox' id='activated'");
			if ( arrUsers[i].getactivated() ) {
				writeOutput(" checked='checked'");
			}
			writeOutput(" /></td><td><a href='##' class='lnkSaveUserChanges btn btn-primary'>Save</a> <a href='##' class='lnkDeleteUser btn btn-danger'>Delete</a></td></tr>");
		}
		writeOutput("</tbody></table>");
			
	}
	
	public array function saveUser(required numeric userid, required string email, required string password, required boolean isApproved )
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
		return arrUser;
	}
	
	public numeric function deleteUser(required numeric userid) {
		arrUser = EntityLoadByPK("TTestTester",arguments.userid);
		EntityDelete(arrUser);
		return 1;
	}
	
	public any function addUser(required string email, required string password, required boolean isApproved, required string userName, required string adid)
	{
		arrUser = createObject("component","CFTestTrack.cfc.db.TTestTester");
		arrUser.setEmail(arguments.email);
		objLogon = createObject("component","CFTestTrack.cfc.Logon");
		salt = objLogon.genSalt();
		newpassword = objLogon.computeHash(arguments.password, salt);
		arrUser.setPassword(newpassword);
		arrUser.setIsApproved(arguments.isApproved);
		arrUser.setSalt(salt);
		arrUser.setUserName(arguments.userName);
		arrUser.setADID(arguments.adid);
		EntitySave(arrUser);
		return arrUser;
	}
	
	remote any function saveLink(required numeric id, required string linkhref, required string linkdesc)
	{
		if (id == 0) {
			arrLink = EntityNew("TTestLinks");
		} else {
			arrLink = EntityLoadByPK("TTestLinks",arguments.id);
		}
		arrLink.setLinkDesc(arguments.linkdesc);
		arrLink.setLinkHref(arguments.linkhref);
		EntitySave(arrLink);
		//location("settings.cfm?ac=links",false);
	}
	
	remote any function deleteLink(required numeric linkid) {
		arrLink = EntityLoadByPK("TTestLinks",arguments.linkid);
		EntityDelete(arrLink);
		//location("settings.cfm?ac=links",false);
	}
	
	remote any function viewSettings() output="true" {
		writeOutput("<script type='text/javascript'>" & chr(13));
		writeOutput("	$(document).ready(function() { "&chr(13));
		writeOutput("	  $(document).on('click','a.lnkSaveSettingChanges',function() { "&chr(13));
		writeOutput("		var row = $(this).closest('tr');" & chr(13));
		writeOutput("		var settingid = row.find('.settingid').val(); " & chr(13) );
		writeOutput("		var settingvalue = row.find('.settingvalue').val();" & chr(13) );
		writeOutput("		$.ajax({url:'cfc/Admin.cfc?method=saveSetting',type:'POST',data : { settingid : settingid, settingvalue : settingvalue }}).done(function() { location.href = 'settings.cfm?ac=settings'; });");
		writeOutput("	  });" & chr(13));
		writeOutput("	});" & chr(13));
		writeOutput("</script>"&chr(13));
		writeOutput("<table class='table table-condensed table-striped table-hover'><thead><tr><th>Setting</th><th>Value</th><th></th></tr></thead><tbody>");
		arrTestSettings = EntityLoad("TTestSettings");
		for ( i = 1; i <= ArrayLen(arrTestSettings); i++)
		{
			writeOutput("<tr><td><input type='hidden' class='settingid' value='" & arrTestSettings[i].getId() & "' /><input type='hidden' class='settingname' value='" & arrTestSettings[i].getSetting() & "' />" & arrTestSettings[i].getSetting() & "</td><td><input type='text' class='settingvalue form-control' value='" & arrTestSettings[i].getSettingValue() & "' /></td>");
			writeOutput("<td><a href='##' class='lnkSaveSettingChanges btn btn-primary'>Save</a></td></tr>");
		}
		writeOutput("</tbody></table>");
	}
	
	remote any function saveSetting(required numeric settingid, required string settingvalue) {
		arrSetting = EntityLoadByPK("TTestSettings",arguments.settingid);
		arrSetting.setSettingValue(arguments.settingvalue);
		EntitySave(arrSetting);	
	}
	
	remote any function viewAllScheduledTasks() output="true" {
		objDash = createObject("component","Dashboard");
		objDash.AllReports();
		objAutomation = createObject("component","AutomationStudio");
		objAutomation.viewAutomatedTasks();
	}
}
