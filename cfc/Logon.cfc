<cfcomponent>

	<cffunction name="ldapAuthenticate" access="public" returntype="boolean">
		<cfargument name="username" required="true" type="string" />
		<cfargument name="password" required="true" type="string" />
		
		<cfset isAuthenticated=false />
		
		<cftry>
			<cfscript>
				nauth = createObject("java","coldfusion.security.NTAuthentication");
				nauth.init("CORNEROPS");
				nauth.authenticateUser(arguments.username,arguments.password);
			</cfscript>
			<cfset isAuthenticated = true />
			<cfldap action="QUERY"  name="results" attributes="cn,o,l,st,sn,mail, givenname,SamAccountname"
			 start="dc=CORNEROPS,dc=local" filter="(&(objectclass=user)(SamAccountName=#arguments.username#))" server="COGFILE01.cornerops.local" 
    			username="CORNEROPS\#arguments.username#" password="#arguments.password#">
    		<cfscript>
    			arrUser = entityLoad("TTestTester",{ADID=results.samaccountname[1]},true);
    			if (!isDefined("arrUser") ) {
    				arrUser = createObject("component","db.TTestTester");
    				arrUser.setADID(results.samaccountname[1]);
    				arrUser.setUserName(results.cn[1]);
    				entitySave(arrUser);
    			}
    			arrUser = entityLoad("TTestTester",{ADID=results.samaccountname[1]},true);
    		</cfscript>
    		<cfset Session.UserIDInt = arrUser.getID() />
    		<cfset Session.LoggedIn = true />
    		<cfset Session.Email = results.mail[1] />
    		<cfset Session.Name = results.cn[1] />
    		<cfset Session.UserId = results.samaccountname[1] />
			<cfcatch>
				<cfset isAuthenticated = false />
				<cfset Session.LoggedIn = false />
			</cfcatch>
		</cftry>
		<cfreturn isAuthenticated />
	</cffunction>
	
	<cffunction name="Logout" access="remote" returntype="void">
		<cfset StructClear(SESSION) />
		<cflocation url="/#application.applicationname#/">
	</cffunction>

</cfcomponent>