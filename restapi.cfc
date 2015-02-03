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
}