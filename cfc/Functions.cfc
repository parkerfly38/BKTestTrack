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
	
	<cffunction name="toWddx" access="public" returnType="string" output="false">
<cfargument name="input" type="any" required="true">
<cfargument name="useTimezoneInfo" type="boolean" required="false" default="true">
<cfset var result = "">
<cfwddx action="cfml2wddx" input="#arguments.input#" output="result" useTimezoneInfo="#arguments.useTimezoneInfo#">
<cfreturn result>

</cffunction>

<cffunction name="toCFML" access="public" returnType="any" output="false">
<cfargument name="input" type="any" required="true">
<cfargument name="validate" type="boolean" required="false" default="false">

<cfset var result = "">
<cfwddx action="wddx2cfml" input="#arguments.input#" output="result" validate="#arguments.validate#">
<cfreturn result>

</cffunction>
	
</cfcomponent>