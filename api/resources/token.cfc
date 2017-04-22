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
			insertToken = new Query();
			insertToken.setSql("INSERT INTO TTestTokens (TesterID, access_token, DateCreated, DateExpires) VALUES (:testerid, :access_token, :datecreated, :dateexpires)");
			insertToken.addParam(name="testerid", value=newstruct.testerid, cfsqltype="cf_sql_integer");
			insertToken.addParam(name="access_token", value=newstruct.access_token, cfsqltype="cf_sql_varchar");
			insertToken.addParam(name="datecreated", value=newstruct.datecreated, cfsqltype="cf_sql_date");
			insertToken.addParam(name="dateexpires", value=newstruct.dateexpires, cfsqltype="cf_sql_date");
			insertToken.Execute();
			return representationOf(newstruct);
		} else {
			return noData().withStatus(403);
		}
		 
	}
}