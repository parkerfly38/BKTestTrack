component  extends="taffy.core.resource" taffy_uri="/status"
{
	objData = createObject("component","/CFTestTrack/cfc/Data");
	
	public function get() hint='Returns all available statuses.'
	{
		return representationOf(objData.getAllStatuses());	
	}
}