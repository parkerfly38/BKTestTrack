component  extends="taffy.core.resource" hint="Return test types." taffy_uri="/types"
{
	objData = createObject("component","/CFTestTrack/cfc/Data");
	
	public function get() hint="Returns test type records."
	{
		return representationOf(objData.getTestTypes());
	}
}