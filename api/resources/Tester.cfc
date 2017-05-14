component  extends="taffy.core.resource" hint="Read only, returns tester IDs and User names." taffy_uri="/testers/{id}"
{
	
	objData = createObject("component","/CFTestTrack/cfc/Data");
	
	public function get(string id) hint="Returns individual test system user."
	{
		tester = objData.getTester(id);
		return representationOf(tester);
	}
}