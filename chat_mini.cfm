<cfwebsocket name="generalChat" onMessage="msgHandlerMini" subscribeto="general" onOpen="openHandler"/>
<cfset objData = new CFTestTrack.cfc.Data()>
<cfset qryLog = objData.qryGetChatLogMini()>
<cfset queryAddColumn(qryLog,"longDate","Date",ArrayNew(1))>
<cfloop from="1" to="#qryLog.RecordCount#" index="i">
	<cfset querySetCell(qryLog,"longDate",DateFormat(qryLog.messagedate[i],"long"),i)>
</cfloop>
<script>
var msgHandler = function(message)
{
	 // Get data from the recieved message token
	 var data = message.data;
	
	 if(data)
	 {
	    // If data is present write it to the div
	    var txt=document.getElementById("myDiv");
	    //txt.innerHTML+= data + "<br>";
	    txt.innerHTML += '<h6 class="text-center"><small>' + data.TIME + '</small></h6><span class="label label-primary">' + data.USERNAME + '</span> : <em>' + data.MESSAGE + '</em><br />';
	    $('#myDiv').scrollTop($('#myDiv')[0].scrollHeight);
	 }
}
var msgHandlerMini = function(message)
   {
         // Get data from the recieved message token
         var data = message.data;

         if(data)
         {
            //delete last message li
            $("#messagesdd li:nth-last-child(2)").remove();
            $("#messagesdd li:nth-last-child(2)").remove(); //kill divider too
            $("#messagesdd").prepend('<li><a href="#"><div><strong>'+data.USERNAME+'</strong><span class="pull-right text-muted"><em>'+data.TIME+'</em></span></div><div>' + data.MESSAGE.substring(0,255) + ' ...</div></a></li><li class="divider"></li>');
         }
}


var sayHello = function()
{
         generalChat.authenticate("<cfoutput>#Session.Name#</cfoutput>","password");
         generalChat.publish("general",document.getElementById("messagetext").value);
         document.getElementById("messagetext").value = null;
}
var openHandler = function()
{
       // do nothing
}

</script>
<cfoutput>
	<cfloop query="qryLog" startrow="1" endrow="3">
		<li>
        	<a href="##">
                <div>
                    <strong>#qryLog.username#</strong>
                	<span class="pull-right text-muted">
                		<em>#DateFormat(qryLog.messagedate,"long")#</em>
                    </span>
                </div>
                <div>#Left(qryLog.messagebody, 255)#...</div>                
            </a>
        </li>
        <li class="divider"></li>
    </cfloop>                
    <li>
        <a class="text-center" id="readAllMessages" href="##">
            <strong>Read All Messages</strong>
            <i class="fa fa-angle-right"></i>
        </a>
    </li>
</cfoutput>