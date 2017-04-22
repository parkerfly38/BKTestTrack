<cfwebsocket name="generalChat" onMessage="msgHandler" subscribeto="general" onOpen="openHandler"/>
<cfset objData = new CFTestTrack.cfc.Data()>
<cfset qryLog = objData.qryGetChatLog()>
<cfset queryAddColumn(qryLog,"longDate","Date",ArrayNew(1))>
<cfloop from="1" to="#qryLog.RecordCount#" index="i">
	<cfset querySetCell(qryLog,"longDate",DateFormat(qryLog.messagedate[i],"long"),i)>
</cfloop>
<script>



var openHandler = function()
{
       // do nothing
}

</script>
<div id="myDiv" style="height: 300px;width:100%;border: 1px solid #cecece;overflow-y:scroll;max-height:300px;padding:3px;">
<cfoutput>	
	<cfloop query="qryLog" group="longDate">
		<h6 class="text-center"><small>#DateFormat(qryLog.longDate,"long")#</small></h6>
		<cfloop>
			<cfif qryLog.username eq "System">
				<span class="label label-success">#qryLog.messagebody#</span><br />
			<cfelse>
				<span class="label label-primary">#qryLog.username#</span> : <em>#qryLog.messagebody#</em><br />
			</cfif>
		</cfloop>
	</cfloop>
</cfoutput>
	<script type="text/javascript">
		$('#myDiv').scrollTop($('#myDiv')[0].scrollHeight);
    </script>
</div>
<br />
<div class="input-group">
	<input type="text" class="form-control" placeholder="type your message here..." id="messagetext" />
	<span class="input-group-btn">
		<button id="hello" onclick="sayHello();" class="btn btn-default"><i class="fa fa-send"></i></button>
	</span>
</div>