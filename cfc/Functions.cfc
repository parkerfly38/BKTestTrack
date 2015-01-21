<cfcomponent>
	
	<cffunction returntype="binary" name="createPDFfromContent" access="public">
		<cfargument name="incomingcontent">
		<cfdocument name="tempdoc" format="PDF" pageheight="11" pagewidth="8.5" marginbottom=".5" margintop=".5" marginright=".5" marginleft=".5">
			
		</cfdocument>
	</cffunction>
	
	<cffunction returntype="void" name="MailerFunction" access="public">
		<cfargument name="toemail" required="true">
		<cfargument name="fromemail" required="true">
		<cfargument name="subject" required="true">
		<cfargument name="body" required="true">
		<cfargument name="mailtype" default="html">
		<cfargument name="attachment" type="binary">
		
		<cfmail to="#arguments.toemail#" from="#arguments.fromemail#" subject="#arguments.subject#" type="#arguments.mailtype#">
			#arguments.body#
			<cfif Len(arguments.attachment) gt 0>
			<cfmailparam file="#getUTC()#.pdf" type="application/pdf" content="#arguments.attachment#">
			</cfif>
		</cfmail>
		
	</cffunction>
	
	<cffunction returntype="String" name="getUTC" access="remote">
		<cfset localdate = now()>
		<cfset utcDate = dateConvert("local2utc",localdate)>
		<cfreturn utcdate.getTime()>
	</cffunction>
	
</cfcomponent>