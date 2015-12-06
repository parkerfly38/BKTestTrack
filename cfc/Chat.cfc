component  extends="CFIDE.websocket.ChannelListener"
{
	objData = new CFTestTrack.cfc.Data();
		
	public any function beforePublish(any message, Struct publisherInfo)
	{
		time = DateFormat(Now(), "long");
		
		//lets grab application settings if this struct is null
		if (!StructKeyExists(publisherInfo.connectionInfo,"username")) {
			objData.saveMessage("System",Now(),message);
			return "<h6 class=""text-center""><small>"&time&"</small></h6><span class=""label label-success"">"&message&"</span>";
		}
		objData.saveMessage(publisherinfo.connectionInfo.username,now(),message);
		message = "<h6 class=""text-center""><small>"&time&"</small></h6><span class=""label label-primary"">" & publisherInfo.connectionInfo.username & "</span> : <em>" & message & "</em>";
		
		return message;
	}
}