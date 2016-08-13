component  extends="taffy.core.resource" taffy_uri="/results"
{
	objData = createObject("component","/CFTestTrack/cfc/Data");
	
	public function get() hint="Returns all test results."
	{
		return representationOf(objData.getAllTestResults());
	}
	
	public function post() hint='Adds test result using the following JSON:
	{
		"id" : integer,
		"Version": string,
		"ElapsedTime" : string,
		"Comment" : string,
		"DateTested" : datetime,
		"AttachmentList" : string,
		"TestCaseID" : integer,
		"Defects" : string,
		"StatusID" : integer,
		"TesterID" : integer
	}'
	{
		if (cgi.content_type eq "application/json")
		{
			datapayload = deserializeJSON(ToString(getHttpRequestData().content));
		}
		objMetaData = GetMetaData(createObject("component", "/CFTestTrack/cfc/db/TTestResult")).properties;
		if (objHelpers.testStruct(dataPayload, objMetaData) eq "true")
		{
			testresult = createObject("component","/CFTestTrack/cfc/db/TTestResult");
			testresult.setComment(datapayload.COMMENT);
			testresult.setDateTested(datapayload.DATETESTED);
			testresult.setDefects(datapayload.DEFECTS);
			testresult.setElapsedTime(datapayload.ELAPSEDTIME);
			testresult.setStatusID(datapayload.STATUSID);
			testresult.setTestCaseID(datapayload.TESTCASEID);
			testresult.setTesterID(datapayload.TESTERID);
			testresult.setVersion(datapayload.VERSION);
			testresult.setAttachmentList(datapayload.ATTACHMENTLIST);
			EntitySave(testresult);
			return representationOf(testresult);
		} else {
			return representationOf(objHelpers.testStruct(dataPayload, objMetaData));
		}
	}
	
	public function put() hint='Updates test result using the following JSON:
	{
		"id" : integer,
		"Version": string,
		"ElapsedTime" : string,
		"Comment" : string,
		"DateTested" : datetime,
		"AttachmentList" : string,
		"TestCaseID" : integer,
		"Defects" : string,
		"StatusID" : integer,
		"TesterID" : integer
	}'
	{
		if (cgi.content_type eq "application/json")
		{
			datapayload = deserializeJSON(ToString(getHttpRequestData().content));
		}
		objMetaData = GetMetaData(createObject("component", "/CFTestTrack/cfc/db/TTestResult")).properties;
		if (objHelpers.testStruct(dataPayload, objMetaData) eq "true")
		{
			testresult = createObject("component","/CFTestTrack/cfc/db/TTestResult");
			testresult.setId(datapayload.ID);
			testresult.setComment(datapayload.COMMENT);
			testresult.setDateTested(datapayload.DATETESTED);
			testresult.setDefects(datapayload.DEFECTS);
			testresult.setElapsedTime(datapayload.ELAPSEDTIME);
			testresult.setStatusID(datapayload.STATUSID);
			testresult.setTestCaseID(datapayload.TESTCASEID);
			testresult.setTesterID(datapayload.TESTERID);
			testresult.setVersion(datapayload.VERSION);
			testresult.setAttachmentList(datapayload.ATTACHMENTLIST);
			EntitySave(testresult);
			return representationOf(testresult);
		} else {
			return representationOf(objHelpers.testStruct(dataPayload, objMetaData));
		}
	}
}