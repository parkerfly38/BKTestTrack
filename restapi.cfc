component restpath="restapi" rest="true"
{
	private boolean function CheckAuthorization() {
		try {
			EncodedCredentials = ListLast(GetHttpRequestData().headers.authorization," ");
			Credentials = ToString(ToBinary(EncodedCredentials));
			Username = ListFirst(Credentials,":");
			Password = ListLast(Credentials,":");
			objLogon = createObject("component","cfc.Logon");
			if ( Application.useLDAP) {
				return objLogon.ldapAuthenticate(Username,Password);
			} else {
				return objLogon.formAuthenticate(Username,Password);
			}
		} catch(any e) {
			return false;
		}
	}
	
	remote any function getTestsByScenario(string scenarioid restargsource="path") httpmethod="post" restpath="getTestsByScenario/{scenarioid}" returnformat="JSON"
	{
		if (!CheckAuthorization())
			throw (errorcode="401", type="Unauthorized");
		querynew = new Query();
		querynew.setSql("SELECT TestTitle, TTestCase.id FROM TTestCase INNER JOIN TTestScenarioCases ON TTestScenarioCases.CaseId = TTestCase.id WHERE ScenarioId = :scenarioid");
		querynew.addParam(name="scenarioid",value=arguments.scenarioid);
		return serializeJSON(querynew.execute().getResult());
	}
}