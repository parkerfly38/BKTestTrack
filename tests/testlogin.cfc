<cfcomponent displayname="LdapTests" extends="mxunit.framework.TestCase">
	<cfscript>
		Application.ormenabled = "true"; 
		Application.datasource = "COGData";
	</cfscript>
	
	<cffunction name="testldapAuthenticate" access="public" returntype="void">
		<cfscript>
			objLogon = createObject("component","CFTestTracker.cfc.Logon");
    		assertTrue(objLogon.ldapAuthenticate("bkresge","COGbk1!!"),"LDAP Authentication on correct username");
    		assertFalse(objLogon.ldapAuthenticate("bkresge","password"),"LDAP Authentication on incorrect password");
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetAllProjects" access="public" returntype="void">
		<cfscript>
		objData = createObject("component","CFTestTracker.cfc.Data");
		assertTrue(isArray(objData.getAllProjects()));
		</cfscript>
	</cffunction>
		
</cfcomponent>