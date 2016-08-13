component  extends="taffy.core.resource" taffy_uri="/prioritytypes"
{
	objData = createObject("component","/CFTestTrack/cfc/Data");
	
	public function get() hint='Returns all priority types.'
	{
		return representationOf(objdata.getallpriorityTypes());
	}
}