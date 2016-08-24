<cfcomponent>

	<cffunction name="ldapAuthenticate" access="public" returntype="boolean">
		<cfargument name="username" required="true" type="string" />
		<cfargument name="password" required="true" type="string" />
		
		<cfset isAuthenticated=false />
		
		<cftry>
			<cfscript>
				nauth = createObject("java","coldfusion.security.NTAuthentication");
				nauth.init(Application.DOMAIN);
				nauth.authenticateUser(arguments.username,arguments.password);
			</cfscript>
			<cfset isAuthenticated = true />
			<cfldap action="QUERY"  name="results" attributes="cn,o,l,st,sn,mail, givenname,SamAccountname"
			 start="dc=#Application.DOMAIN#,dc=local" filter="(&(objectclass=user)(SamAccountName=#arguments.username#))" server="COGFILE01.cornerops.local" 
    			username="#Application.DOMAIN#\#arguments.username#" password="#arguments.password#">
    		<cfscript>
    			arrUser = entityLoad("TTestTester",{ADID=results.samaccountname[1]},true);
    			if (!isDefined("arrUser") ) {
    				arrUser = entityNew("TTestTester");
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
    		<cfif arrUser.getIsAdmin() gt 0>
    			<cfset Session.IsAdmin = true />
    		<cfelse>
    			<cfset Session.IsAdmin = false />
    		</cfif>
    		<cfif Application.AxoSoftIntegration>
    			<cfset Session.AxoSoftToken = arrUser.getAxoSoftToken() />
    		</cfif>
			<cfcatch>
				<cflog text="#cfcatch.message# #cfcatch.detail# #cfcatch.ExtendedInfo#"log="APPLICATION" type="Error" application="yes">
				<cfset isAuthenticated = false />
				<cfset Session.LoggedIn = false />
			</cfcatch>
		</cftry>
		<cfset wsPublish("general",Session.Name + "has logged in.") />
		<cfreturn isAuthenticated />
	</cffunction>
	
	<cffunction access="public" name="formAuthenticate" returntype="boolean" >
		<cfargument name="username" required="true">
		<cfargument name="password" required="true">
				
		<cfset qryLogin = EntityLoad("TTestTester",{ADID=arguments.username},true) >
		
		<cfif isnull(qryLogin)>
			<cfset Session.LoggedIn = false>
			<cfreturn false>
		</cfif>
		<!--- testing code only --->
		<cfif Len(qryLogin.getSalt()) gt 0>
	 	<cfset hashedFormPassword = computeHash(arguments.password, qryLogin.getSalt()) ><!--- this is the only part that stays in production --->
		<cfelse>
		<cfset hashedFormPassword = "">
		</cfif> 
	  	<cfif qryLogin.getPassword() eq hashedFormPassword>
	  		<cfset Session.UserIDInt = qryLogin.getId()>
	  		<cfset Session.LoggedIn = true>
	  		<cfset Session.Email = qryLogin.getEmail()>
	  		<cfset Session.Name = qryLogin.getUserName()>
	  		<cfset Session.UserID = qryLogin.getADID()>
	  		<!--- adding new token routine, get one per session instead of reusing one --->
	  		<cfif Application.AxoSoftIntegration>
	  			<!--- todo:  please change to variables for axosoft --->
	  			<cfhttp url="https://cornerops.axosoft.com/api/oauth2/token?grant_type=password&username=bkresge&password=nugget38&client_id=84a344d7-9034-4ed7-8a01-ba35f9642648&client_secret=yUNiYAek30KibBtietQVo9UktJz8gv8GLdniTvzyv7rzWW4n2Xq0cSmedoJKMB_PUX5aWUyb2y5LXimFX-1wIJeCQocZSF6HTE7Q&scope=read" method="get" result="tokenResult" />
				<cfset accessToken = DeSerializeJSON(tokenResult.filecontent).access_token>
	  			<cfset Session.AxoSoftToken = accessToken>
			</cfif>
			<cfset wsPublish("general","<strong>" & Session.Name & "</strong> has logged in.") />
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif> 
	</cffunction>
	
	<cffunction access="remote" name="createFormAccount" httpmethod="POST" returnformat="plain" returntype="string">
		<cfargument name="ADID" required="true">
		<cfargument name="UserName" required="true">
		<cfargument name="password" required="true">
		<cfargument name="password2" required="true">
		<cfargument name="email" required="true">
		<cfif !(len(arguments.password) gt 0) || !(len(arguments.password2) gt 0)>
			<cfreturn "Please actually enter a password and then repeat it.">
		</cfif>
		<cfif arguments.password neq arguments.password2>
			<cfreturn "Passwords don't match.">
		</cfif>
		<cfif !isValid("email", arguments.email)>
			<cfreturn "Invalid email.">
		</cfif>		
		<cfset arrCheckADID = EntityLoad("TTestTester",{ADID=arguments.ADID},true)>
		<cfif !isNull(arrCheckADID) && ArrayLen(arrCheckADID) gt 0>
			<cfreturn "User ID already used.">
		</cfif>
		<cfset arrCheckEmail = EntityLoad("TTestTester",{email=arguments.email},true)>
		<cfif !isNull(arrCheckEmail) && ArrayLen(arrCheckEmail) gt 0>
			<cfreturn "Email address already used.">
		</cfif>
		<cfscript>
			local.salt = genSalt();
			local.passwordsave = computeHash(arguments.password, local.salt);
			objNewUser = createObject("component","db.TTestTester");
			objNewUser.setADID(arguments.ADID);
			objNewUser.setUserName(arguments.UserName);
			objNewUser.setPassword(local.passwordsave);
			objNewUser.setEmail(arguments.email);
			objNewUser.setSalt(local.salt);
			objNewUser.setisApproved(false);
			EntitySave(objNewUser);
		</cfscript>		
		<cfreturn "success">
	</cffunction>
	
	<cffunction name="Logout" access="remote" returntype="void">
		
		<cfset wsPublish("general","<strong>" & Session.Name &  "</strong> has logged out.") />
		<cfset StructDelete(Application.SessionTracker,Session.UserIDInt,false) />
		<cfset StructClear(SESSION) />
		<cflocation url="/CFTestTrack/" addtoken="false">
	</cffunction>
	
	<cffunction name="genSalt" access="public" returnType="string">
    	<cfargument name="size" type="numeric" required="false" default="16" />
    	<cfscript>
     		var byteType = createObject('java', 'java.lang.Byte').TYPE;
		    var bytes = createObject('java','java.lang.reflect.Array').newInstance( byteType , size);
		    var rand = createObject('java', 'java.security.SecureRandom').nextBytes(bytes);
		    return toBase64(bytes);
    	</cfscript>
	</cffunction>

	<cffunction name="computeHash" access="public" returntype="String">
		<cfargument name="password" type="string" />
		<cfargument name="salt" type="string" />
		<cfargument name="iterations" type="numeric" required="false" default="1024" />
		<cfargument name="algorithm" type="string" required="false" default="SHA-512" />
		<cfscript>
			var hashed = '';
			var i = 1;
			hashed = hash( password & salt, arguments.algorithm, 'UTF-8' );
			for (i = 1; i <= iterations; i++) {
				hashed = hash( hashed & salt, arguments.algorithm, 'UTF-8' );
			}
			return hashed;
		</cfscript>
	</cffunction>

</cfcomponent>