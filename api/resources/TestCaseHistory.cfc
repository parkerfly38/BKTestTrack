component  extends="taffy.core.resource" taffy_uri="/testcasehistory/{testcaseid}"
{
	objData = createObject("component","/CFTestTrack/cfc/Data");
	
	public function get(string id) hint='Retrieves test case history by test case id.'
	{
		return representationOf(objData.getTestCaseHistoryByTestCase(id));	
	}
	
	public function delete(string id) hint='Deletes individual test case history by id.'
	{
		objData.deleteTestCaseHistory(id);
		return noData();
	}
}