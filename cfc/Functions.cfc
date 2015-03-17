<cfcomponent>
	
	<cffunction returntype="binary" name="createPDFfromContent" access="public">
		<cfargument name="incomingcontent">
		<cfsavecontent variable="presentedcontent">
			<!DOCTYPE html>
			<html lang="en">
				<head>
					<script type="text/javascript" src="scripts/jquery-1.10.2.min.js"></script>
					<script type="text/javascript" src="scripts/ChartNew.js"></script>
					<script type="text/javascript" src="scripts/bootstrap-select.min.js"></script>
					<style type="text/css" media="screen">@import "style/bootstrap.css";</style>
				</head>
				<body style="font-family: Arial, Helvetica, sans-serif">
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
	
	<cffunction name="piechart" access="public" returntype="any">
		<cfargument name="dataquery" type="query">
		<cfargument name="charttitle">
		
		<cfsavecontent variable="donutchart">--->
		<cfsilent>
			<cfchart title="#arguments.charttitle#" name="mychart" pieslicestyle="sliced" showborder="false" format="png" font="arialunicodeMS" fontsize="11" show3d="true" showlegend="false" chartwidth="600" chartheight="300">
				<cfchartseries type="pie" query="dataquery" valueColumn="ItemCount"  itemColumn="Item" />
			</cfchart>
		</cfsilent>
		
		<cfset imgnew = ImageNew(mychart)>
		<cfimage action="writeToBrowser" source="#imgnew#">
		</cfsavecontent>
		<cfreturn donutchart>
	</cffunction>
	
	<cffunction name="sendchat" access="remote" returntype="void">
		<cfargument name="fromid" type="numeric" required="true">
		<cfargument name="toid" type="numeric" required="true">
		<cfargument name="timeofmessage" type="date">
		<cfargument name="body" type="string">
		<cfif !StructKeyExists(Application,"ChatLog")>
			<cfset Application.ChatLog = ArrayNew(1)>
		</cfif>
		<cfset x = ArrayLen(Application.ChatLog) + 1>
		<cfset Application.ChatLog[x] = { from = arguments.fromid, to = arguments.toid, mdate = arguments.timeofmessage, messagebody = arguments.body} >
	</cffunction>
	
	<cffunction name="getchats" access="remote" output="true">
		<cfargument name="fromid" type="numeric" required="true">
		<cfargument name="toid" type="numeric" required="true">
		<cfset arrToPerson = EntityLoadByPK("TTestTester",arguments.toid)>
		<cfset arrFromPerson = EntityLoadByPK("TTestTester",arguments.fromid)>
		<script type="text/javascript">
			$(document).ready(function() {
				$(document).off('click','button.sendchat');
				$(document).on('click','button.sendchat', function(event) {
					event.preventDefault();
					$.ajax({ type: 'POST',url: "CFC/Functions.cfc?method=sendchat",data: { fromid : #arguments.fromid#, toid : #arguments.toid#, timeofmessage : '#DateFormat(Now(),"MM/DD/YYYY")#', body : $("##chatmessage").val() }}).done( function() {
						$("##chatModal .modal-body").load("cfc/Functions.cfc?method=getchats&fromid=#arguments.fromid#&toid=#arguments.toid#", 
							function() {
								$("##chatModal .modal-body").animate({ scrollTop: $("##chatModal .modal-body")[0].scrollHeight},1000);
							});
						$("##chatmessage").val("");	
					});
				});
			});
		</script>
		<cfscript>
		if ( StructKeyExists(Application,"ChatLog") ) {
			for (i=1; i <= ArrayLen(Application.ChatLog); i++) {
				if ( (Application.ChatLog[i].from == arguments.toid || Application.ChatLog[i].from == arguments.fromid) && (Application.ChatLog[i].to == arguments.toid || Application.ChatLog[i].to == arguments.fromid) ) {
					writeOutput("<p>");
					if ( Application.ChatLog[i].from == arguments.fromid ) {
						writeOutput("<span class='label label-success'>" & arrFromPerson.getUserName());
					} else if ( Application.ChatLog[i].from == arguments.toid ) {
						writeOutput("<span class='label label-info'>" & arrToPerson.getUserName());
					}
					writeOutput(": " & Application.ChatLog[i].mdate & "</span> - " & Application.ChatLog[i].messagebody & "</p>");
				}
			}
		}
		</cfscript>
		
	</cffunction>
	
	<cffunction name="linechartbydate" access="public" returntype="any" output="true">
		<cfargument name="groupingquery" type="query">
		<cfargument name="dataquery" type="query">
		<cfargument name="charttitle">
		<cfquery dbtype="query" name="qryreorder">
			SELECT [Action],[DateOfAction],[TestTitle]
			FROM arguments.dataquery
			ORDER BY [DateOfAction]
		</cfquery>
		<!---<cfsavecontent variable="linechart">---><cfsilent>
			<cfchart title="#arguments.charttitle#" showborder="false" format="jpg" tipstyle="none" font="arialunicodeMS" fontsize="11" show3d="false" showlegend="true" chartwidth="600" chartheight="300" name="mychart" scalefrom="0" scaleto="20" xaxistype="category" sortxaxis="true" >
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
			</cfsilent>
		<!---</cfsavecontent>--->
		<cfset imgnew = ImageNew(mychart)>
		<cfimage action="writeToBrowser" source="#imgnew#">
	</cffunction>
</cfcomponent>