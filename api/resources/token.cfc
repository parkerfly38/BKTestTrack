component extends="taffy.core.resource" taffy_uri="/token"
{
	public function post()
	{
		if (cgi.content_type eq "application/json")
		{
			datapayload = deserializeJSON(ToString(getHttpRequestData().content));
		}
		if (!structKeyexists(datapayload,"username"))
			return noData().withStatus(401);
		if (!structkeyexists(datapayload,"password"))
			return noData().withStatus(401);
		if (!structkeyexists(datapayload,"deviceuuid"))
			datapayload.deviceuuid = "";
		if (!structkeyexists(datapayload,"deviceos"))
			datapayload.deviceos = "";
		objLogon = createObject("component", "/CFTestTrack/cfc/Logon");
		var newstruct = structnew();
		newstruct = objLogon.tokenAuthenticate(datapayload.username, datapayload.password, datapayload.deviceuuid, datapayload.deviceos);
		if (StructKeyExists(newstruct,"access_token"))
		{
			newstruct.datecreated = DateFormat(Now(), "mm/dd/yyyy");
			newstruct.dateexpires = DateFormat(DateAdd("d",15,Now()),"mm/dd/yyyy");
			try {
				
				insertToken = new Query();
				insertToken.setSql("INSERT INTO TTestTokens (TesterID, access_token, DateCreated, DateExpires) VALUES (:testerid, :access_token, :datecreated, :dateexpires)");
				insertToken.addParam(name="testerid", value=newstruct.testerid, cfsqltype="cf_sql_integer");
				insertToken.addParam(name="access_token", value=newstruct.access_token, cfsqltype="cf_sql_varchar");
				insertToken.addParam(name="datecreated", value=newstruct.datecreated, cfsqltype="cf_sql_date");
				insertToken.addParam(name="dateexpires", value=newstruct.dateexpires, cfsqltype="cf_sql_date");
				insertToken.Execute();
			} catch (any exception)
			{
				updateToken = new Query();
				updateToken.setSql("UPDATE TTestTokens SET access_token = :access_token, DateCreated = :datecreated, DateExpires = :dateexpires WHERE TesterID = :testerid");
				updateToken.addParam(name="testerid", value=newstruct.testerid, cfsqltype="cf_sql_integer");
				updateToken.addParam(name="access_token", value=newstruct.access_token, cfsqltype="cf_sql_varchar");
				updateToken.addParam(name="datecreated", value=newstruct.datecreated, cfsqltype="cf_sql_date");
				updateToken.addParam(name="dateexpires", value=newstruct.dateexpires, cfsqltype="cf_sql_date");
				updateToken.Execute();
			}
			return representationOf(newstruct);
		} else {
			return noData().withStatus(403);
		}
		 
	}
	
	private struct function tokenAuthenticate(string username, string password, string deviceuuid = "", string deviceos = "")
	{
		
		objLogon = createObject("component", "/CFTestTrack/cfc/Logon");
		objData = createObject("component", "/CFTestTrack/cfc/Data");
		qryLogin = createObject("component", "/CFTestTrack/cfc/db/TTestTester");
		qryLogin = objData.getTesterByUsername(arguments.username);
		
		if (isnull(qrtLogin))
			return structnew();
			
		if (Len(qryLogin.getSalt()) gt 0)
		{
			hashedFormPassword = objLogon.computeHash(arguments.password, qryLogin.getSalt());
		} else {
			hashedFormPassword = "";
		}
		
		if (qryLogin.getPassword() eq hashedFormPassword)
		{
			if (len(arguments.deviceuuid) gt 0 && len(arguments.deviceos) gt 0)
			{
				//qryDevices = EntityLoad("TTestDevices",{TesterID = qryLogin.getId(), DeviceUUID = arguments.deviceuuid, DeviceOIS = arguments.deviceos}, true);
				qryDevices = objData.getDevices(qryLogin.getId(), arguments.deviceuuid, arguments.deviceos);
				if ( isnull(qryDevices))
				{
					objData.saveDevice(arguments.deviceuuid, arguments.deviceos, qryLogin.getId());
				}
			}
			returnstruct = structnew();
			returnstruct.access_token = CSRFGenerateToken();
			returnstruct.testerid = qryLogin.getId();
			return returnstruct;
		} else {
			return structnew();
		}
	}
}