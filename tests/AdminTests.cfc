<cfcomponent displayname="AdminTests" extends="mxunit.framework.TestCase">
	
	<cfscript>
		Application.ormenabled = "true"; 
		Application.datasource = "COGDataPG";
	</cfscript>
	
	<cfset variables.userid = 0 >
	
	<cffunction name="viewAllLinksTest" access="public" returntype="void">
		<cfscript>
			objAdmin = createObject("component","CFTestTrack.cfc.Admin");
			output = objAdmin.viewAllLinks();
			assertTrue(output.FindNoCase("cfc/Admin.cfc?method=saveLink"),"viewAllLinks: Good");
		</cfscript>
	</cffunction>
	
	<cffunction name="viewAllUsersTest" access="public" returntype="void">
		<cfscript>
			objAdmin = createObject("component","CFTestTrack.cfc.Admin");
			output = objAdmin.viewAllUsers();
			assertTrue(output.FindNoCase("settings.cfm?ac=users"), "viewAllUsersTest: good");
		</cfscript>
	</cffunction>
	
	<cffunction name="addUserTest" access="public" returntype="void">
		<cfscript>
			objAdmin = createObject("component","CFTestTrack.cfc.Admin");
			arrUser = objAdmin.addUser("testinguser@test.com","password",true,"test user","testuser");
			assertIsTypeOf(arrUser,"CFTestTrack.cfc.db.TTestTester");
			variables.userid = arrUser.getid();
		</cfscript>
	</cffunction>			
	
	<cffunction name="saveUserTest" access="public" returntype="void">
		<cfscript>
			objAdmin = createObject("component","CFTestTrack.cfc.Admin");
			assertIsArray(objAdmin.saveUser(variables.userid,"testuser@test.com","password",true),"variable: " & variables.userid);
		</cfscript>
	</cffunction>
	
	<cffunction name="deleteUserTest" access="public" returntype="void">
		<cfscript>
			objAdmin = createObject("component","CFTestTrack.cfc.Admin");
			assertEquals("1",objAdmin.deleteUser(variables.userid));
		</cfscript>
	</cffunction>
	
</cfcomponent>