<cfwebsocket name="generalChat" onMessage="msgHandler" subscribeto="general" onOpen="openHandler"/>
<cfset objData = new CFTestTrack.cfc.Data()>
<cfset qryLog = objData.qryGetChatLog()>
<cfset queryAddColumn(qryLog,"longDate","Date",ArrayNew(1))>
<cfloop from="1" to="#qryLog.RecordCount#" index="i">
	<cfset querySetCell(qryLog,"longDate",qryLog.messagedate[i],i)>
</cfloop>
<script>

var openHandler = function()
{
       // do nothing
}

var refreshChat = function()
{
	$("#chatwindow").load("chat.cfm");
	return false;
}

</script>
<script type="text/javascript">
	$(document).ready(function() {
		$('#chatDiv').scrollTop($('#chatDiv')[0].scrollHeight);
	});
    </script>
<div class="chat-panel panel panel-default">
                        <div class="panel-heading">
                            <i class="fa fa-comments fa-fw"></i> Chat
                            <div class="btn-group pull-right">
                                <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                                    <i class="fa fa-chevron-down"></i>
                                </button>
                                <ul class="dropdown-menu slidedown">
                                    <li>
                                        <a href="#" onclick="refreshChat();">
                                            <i class="fa fa-refresh fa-fw"></i> Refresh
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <i class="fa fa-check-circle fa-fw"></i> Available
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <i class="fa fa-times fa-fw"></i> Busy
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <i class="fa fa-clock-o fa-fw"></i> Away
                                        </a>
                                    </li>                                    
                                </ul>
                            </div>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body" id="chatDiv">
                            <ul class="chat" id="chatUl">
	                            	<cfoutput>	
										<cfloop query="qryLog">
											<li class="#iif((qryLog.currentRow MOD 2 EQ 0), DE('right'), DE('left'))# clearfix">
												<span class="chat-img pull-#iif((qryLog.currentRow MOD 2 EQ 0), DE('right'), DE('left'))#">
													<img src="http://placehold.it/50/FA6F57/fff" alt="User Avatar" class="img-circle" />
												</span>
												<div class="chat-body clearfix">
													<div class="header">
														<small class="text-muted #iif((qryLog.currentRow MOD 2 EQ 0), DE(''), DE('pull-right'))#">
															<i class="fa fa-clock-o fa-fw"></i> 
																<cfscript>
																	seconds = datediff("s",qryLog.longDate,now());
																	if (seconds gte 60)
																	{
																		minutes = datediff("n",qryLog.longDate,now());
																		if (minutes gte 60)
																		{
																			hours = datediff("h",qryLog.longDate,now());
																			if (hours gte 24)
																			{
																				days = datediff("d",qryLog.longDate,now());
																				if (days gte 7)
																				{
																					if (days gte 28)
																					{
																						months = datediff("m",qryLog.longDate,now());
																						if (months gte 12)
																						{
																							years = datediff("yyyy",qryLog.longDate,now());
																							writeOutput(years & "years ago");
																						} else {
																							WriteOutput(months & " months ago");
																						}
																					} else {
																						weeks = datediff("ww", qryLog.longDate,now());
																						writeOutput(weeks & " weeks ago");
																					}
																				} else {
																					WriteOutput(days & " days ago");
																				}
																			} else {
																				WriteOutput(hours & " hours ago");
																			}
																		} else {
																			WriteOutput(minutes & " mins ago");
																		}
																	} else {
																		WriteOutput(seconds & " secs ago");
																	}
																</cfscript>
														</small>
														<strong class="#iif((qryLog.currentRow MOD 2 EQ 0), DE('pull-right'), DE(''))#">#qryLog.username#</strong>
													</div>
													<p>
														#qryLog.messagebody#
													</p>
												</div>
											</li>
										</cfloop>
									</cfoutput>
                            </ul>
                        </div>
                        <!-- /.panel-body -->
                        <div class="panel-footer">
                            <div class="input-group">
                                <input id="messagetext" type="text" class="form-control input-sm" placeholder="Type your message here...">
                                <span class="input-group-btn">
                                    <button onclick="sayHello();" class="btn btn-warning btn-sm" id="btn-chat">
                                        Send
                                    </button>
                                </span>
                            </div>
                        </div>
                        <!-- /.panel-footer -->
                    </div>