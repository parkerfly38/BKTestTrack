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
	    var txt=document.getElementById("chatUl");
	    var liclass;
	    var spanclass;
	    var smallclass;
	    var strongclass;
	    if ($('#chatUl').children().last().hasClass("right"))
	    {
	    	liclass = "left";
	    	spanclass = "pull-left";
	    	smallclass = "pull-right";
	    	strongclass = "";	
	    } else {
	    	liclass = "right";
	    	spanclass = "pull-right";
	    	smallclass = "";
	    	strongclass = "pull-right";
	    }
	    txt.innerHTML += '<li class="' + liclass +' clearfix"><span class="chat-img ' + spanclass + '"><img src="http://placehold.it/50/FA6F57/fff" alt="User Avatar" class="img-circle" /></span><div class="chat-body clearfix"><div class="header"><small class="text-muted '+smallclass+'"><i class="fa fa-clock-o fa-fw"></i> Now</small><strong class="' + strongclass + '">' + data.USERNAME + '</strong></div><p>' + data.MESSAGE + '</p></div></li>';
	    $('#chatDiv').scrollTop($('#chatDiv')[0].scrollHeight);
	    //$('<span class="badge progress-bar-danger">!</span>').insertAfter('#ddmess i.fa-envelope');
	    $('#messagebadge').text("!");
	    $('#messagebadge').show();
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