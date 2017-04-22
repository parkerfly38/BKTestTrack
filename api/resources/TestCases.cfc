component extends="taffy.core.resource" taffy_uri="/testcases"
{
	objHelpers = createObject("component","/CFTestTrack/api/helpers");
	objData = createObject("component", "/CFTestTrack/cfc/Data");
	
	public function get()
	{
		tests = objData.getAllTestCases();
		return representationOf(tests);
	}

	public function post() hint='
		{
		   "Id" : "0",
		   "TestTitle" : "",
		   "TestDetails" : "",
		   "PriorityId" : "",
		   "TypeId" : "",
		   "Preconditions" : "",
		   "Steps" : "",
		   "ExpectedResult" : "",
		   "MilestoneId" : "",
		   "Estimate" : "",
		   "ProjectID" : ""
		}'
	{
		if (cgi.content_type eq "application/json")
		{
			datapayload = deserializeJSON(ToString(getHttpRequestData().content));
		}
		objMetaData = GetMetaData(createObject("component", "/CFTestTrack/cfc/db/TTestCase")).properties;
		if (objHelpers.testStruct(dataPayload, objMetaData) eq "true")
		{
			testCase = createObject("component","/CFTestTrack/cfc/db/TTestCase");
			testCase.setTestTitle(datapayload.TESTTITLE);
			testCase.setTestDetails(datapayload.TESTDETAILS);
			testCase.setPriorityId(datapayload.PRIORITYID);
			testCase.setTypeId(datapayload.TYPEID);
			testCase.setPreconditions(datapayload.PRECONDITIONS);
			testCase.setSteps(datapayload.STEPS);
			testCase.setExpectedResult(datapayload.EXPECTEDRESULT);
			testCase.setMilestoneId(datapayload.MILESTONEID);
			testCase.setEstimate(datapayload.ESTIMATE);
			testCase.setProjectID(datapayload.PROJECTID);
			return representationOf(objData.saveTestCase(testCase));						
		} else {
			return representationOf(objHelpers.testStruct(datapayload, objMetaData));
		}
	}
	
	public function put() hint='
		{
		   "Id" : "0",
		   "TestTitle" : "",
		   "TestDetails" : "",
		   "PriorityId" : 0,
		   "TypeId" : 0,
		   "Preconditions" : "",
		   "Steps" : "",
		   "ExpectedResult" : "",
		   "MilestoneId" : 0,
		   "Estimate" : "",
		   "ProjectID" : 0
		}'
	{
		if (cgi.content_type eq "application/json")
		{
			datapayload = deserializeJSON(ToString(getHttpRequestData().content));
		}
		objMetaData = GetMetaData(createObject("component", "/CFTestTrack/cfc/db/TTestCase")).properties;
		if (objHelpers.testStruct(dataPayload, objMetaData) eq "true")
		{
			testCase = createObject("component","/CFTestTrack/cfc/db/TTestCase");
			testcase.setId(datapayload.ID);
			testCase.setTestTitle(datapayload.TESTTITLE);
			testCase.setTestDetails(datapayload.TESTDETAILS);
			testCase.setPriorityId(datapayload.PRIORITYID);
			testCase.setTypeId(datapayload.TYPEID);
			testCase.setPreconditions(datapayload.PRECONDITIONS);
			testCase.setSteps(datapayload.STEPS);
			testCase.setExpectedResult(datapayload.EXPECTEDRESULT);
			testCase.setMilestoneId(datapayload.MILESTONEID);
			testCase.setEstimate(datapayload.ESTIMATE);
			testCase.setProjectID(datapayload.PROJECTID);
			return representationOf(objData.saveTestCase(testCase));						
		} else {
			return representationOf(objHelpers.testStruct(datapayload, objMetaData));
		}
	}

}