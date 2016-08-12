component extends="taffy.core.resource" taffy_uri="/testcasehistory"
{
	objData = createObject("component","/CFTestTrack/cfc/Data");
	
	public function get() hint='Retrieves all test case history records.'
	{
		return representationOf(objData.getAllTestCaseHistory());
	}
	
	public function post() hint='Adds new test case history with the following JSON:
		{
			"id" : 0,
			"Action" : "",
			"CaseId" : 0,
			"DateOfAction" : "",
			"DateActionClosed" : "",
			"TesterID" : 0
		}'
	{
		if (cgi.content_type eq "application/json")
		{
			datapayload = deserializeJSON(ToString(getHttpRequestData().content));
		}
		objMetaData = GetMetaData(createObject("component", "/CFTestTrack/cfc/db/TTestCaseHistory")).properties;
		if (objHelpers.testStruct(dataPayload, objMetaData) eq "true")
		{
			newTestCaseHistory = createObject("component","/CFTestTrack/cfc/db/TTestCaseHistory");
			newTestCaseHistory.setAction(datapayload.ACTION);
			newTestCaseHistory.setCaseId(datapayload.CASEID);
			newTestCaseHistory.setDateOfAction(datapayload.DATEOFACTION);
			newTestCaseHistory.setDateActionClosed(datapayload.DATEACTIONCLOSED);
			newTestCaseHistory.setTesterID(datapayload.TESTERID);
			EntitySave(newTestCaseHistory);
			return representationOf(newTestCaseHistory);
		} else {
			return representationOf(objHelpers.testStruct(dataPayload, objMetaData));
		}
	}
	
	public function update() hint='Updates test case history with the following JSON:
		{
			"id" : 0,
			"Action" : "",
			"CaseId" : 0,
			"DateOfAction" : "",
			"DateActionClosed" : "",
			"TesterID" : 0
		}'
	{
		if (cgi.content_type eq "application/json")
		{
			datapayload = deserializeJSON(ToString(getHttpRequestData().content));
		}
		objMetaData = GetMetaData(createObject("component", "/CFTestTrack/cfc/db/TTestCaseHistory")).properties;
		if (objHelpers.testStruct(dataPayload, objMetaData) eq "true")
		{
			newTestCaseHistory = createObject("component","/CFTestTrack/cfc/db/TTestCaseHistory");
			newTestCaseHistory.setId(datapayload.ID);
			newTestCaseHistory.setAction(datapayload.ACTION);
			newTestCaseHistory.setCaseId(datapayload.CASEID);
			newTestCaseHistory.setDateOfAction(datapayload.DATEOFACTION);
			newTestCaseHistory.setDateActionClosed(datapayload.DATEACTIONCLOSED);
			newTestCaseHistory.setTesterID(datapayload.TESTERID);
			EntitySave(newTestCaseHistory);
			return representationOf(newTestCaseHistory);
		} else {
			return representationOf(objHelpers.testStruct(dataPayload, objMetaData));
		}
	}
}