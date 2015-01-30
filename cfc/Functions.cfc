<cfcomponent>
	
	<cffunction returntype="binary" name="createPDFfromContent" access="public">
		<cfargument name="incomingcontent">
		<cfsavecontent variable="presentedcontent">
			<!DOCTYPE html>
			<html lang="en">
				<head>
					<script type="text/javascript" src="scripts/jquery-1.10.2.min.js"></script>
					<script type="text/javascript" src="scripts/ChartNew.js"></script>
				</head>
				<body>
					Test Test Test
				<cfoutput>#arguments.incomingcontent#</cfoutput>
				</body>
			</html>
		</cfsavecontent>
		<cfdocument name="tempdoc" format="PDF" pageheight="11" pagewidth="8.5" marginbottom=".5" margintop=".5" marginright=".5" marginleft=".5">
			<cfoutput>#presentedcontent#</cfoutput>
		</cfdocument>
		<cfreturn tempdoc />
	</cffunction>
	
	<cffunction returntype="void" name="MailerFunction" access="public">
		<cfargument name="toemail" required="true">
		<cfargument name="fromemail" required="true">
		<cfargument name="subject" required="true">
		<cfargument name="body" required="true">
		<cfargument name="mailtype" default="html">
		<cfargument name="attachment" type="binary" required="false">
		
		<cfmail to="#arguments.toemail#" from="#arguments.fromemail#" subject="#arguments.subject#" type="#arguments.mailtype#">
			#arguments.body#
			<cfif StructKeyExists(arguments,"attachment")>
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
	
	<cffunction name="piechart" access="public" returntype="string">
		<cfargument name="dataquery" type="query">
		<cfargument name="charttitle">
		
		<cfsavecontent variable="donutchart">
			<cfchart title="#arguments.charttitle#" pieslicestyle="sliced" showborder="false" format="png" font="arialunicodeMS" fontsize="11" show3d="true" showlegend="false" chartwidth="600" chartheight="300">
				<cfchartseries type="pie" query="dataquery" valueColumn="ItemCount"  itemColumn="Item" />
			</cfchart>
		</cfsavecontent>
		<cfreturn donutchart>
	</cffunction>
	
	<cffunction name="linechartbydate" access="public" returntype="string">
		<cfargument name="groupingquery" type="query">
		<cfargument name="dataquery" type="query">
		<cfargument name="charttitle">
		<cfquery dbtype="query" name="qryreorder">
			SELECT [Action],[DateOfAction],[TestTitle]
			FROM arguments.dataquery
			ORDER BY [DateOfAction]
		</cfquery>
		<cfsavecontent variable="linechart">
			<cfchart title="#arguments.charttitle#" showborder="false" format="png" font="arialunicodeMS" fontsize="11" show3d="false" showlegend="true" chartwidth="600" chartheight="300"  scalefrom="0" scaleto="20" xaxistype="category" sortxaxis="true" >
				<cfloop query="groupingquery">
					<cfquery dbtype="query" name="qrysub">
						SELECT Count([Action]) as [ActionCount],[DateOfAction] FROM qryreorder
						WHERE [Action] = '#arguments.groupingquery.Item#'
						GROUP BY [DateOfAction]
						Order by [DateOfAction]
					</cfquery>
				<cfchartseries type="line" markerstyle="snow" seriesLabel="#arguments.groupingquery.Item#">
					<cfloop query="qrysub">
						<cfchartdata item="#DateFormat(DateOfAction,'mm/dd/yyyy')#" value="#ActionCount#">
					</cfloop>
				</cfchartseries>
				</cfloop>
			</cfchart>
		</cfsavecontent>
		<cfreturn linechart>
	</cffunction>
</cfcomponent>