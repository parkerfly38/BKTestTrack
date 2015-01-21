<cfcomponent>
	
	<cffunction returntype="binary" name="createPDFfromContent" access="public">
		<cfargument name="incomingcontent">
		<cfdocument>
		</cfdocument>
	</cffunction>
	
	<cffunction returntype="void" name="MailerFunction" access="public">
		<cfargument name="toemail" required="true">
		<cfargument name="fromemail" required="true">
		<cfargument name="subject" required="true">
		<cfargument name="body" required="true">
		
	</cffunction>
	
</cfcomponent>