component extends="taffy.core.resource" taffy_uri="/testcases/{testCaseId}"
{
	public function get(string testCaseId) hint='Retrieves a test case by id.'
	{
		objData = createObject("component","/CFTestTrack/cfc/Data");
		return representationOf(objData.getTestCase(testCaseId));
	}
	
	public function delete(string testCaseId) hint='Deletes a test case by id.'
	{
		objData = createObject("component","/CFTestTrack/cfc/Data");
		objData.deleteTestCase(testCaseId);
		return noData();
	}
}