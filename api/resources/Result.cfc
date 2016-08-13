component  extends="taffy.core.resource" taffy_uri="/results/{testcaseid}"
{
	objData = createObject("/CFTestTrack/cfc/Data");
	
	public function get(string testcaseid) hint="Returns all test results for a case id."
	{
		return representationOf(objData.getTestResults(testcaseid));
	}
}