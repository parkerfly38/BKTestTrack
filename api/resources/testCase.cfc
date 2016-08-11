component extends="taffy.core.resource" taffy_uri="/testcases/{testCaseId}"
{
	public function get(string testCaseId)
	{
		objData = createObject("component","/CFTestTrack/cfc/Data");
		return representationOf(objData.getTestCase(testCaseId));
	}
}