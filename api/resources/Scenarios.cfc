component  extends="taffy.core.resource" taffy_uri="/scenarios"
{
	objData = createObject("component","/CFTestTrack/cfc/Data");
	objHelpers = createObject("component","/CFTestTrack/api/helpers");
	
	public function get() hint='Returns all scenarios.'
	{
		return representationOf(objData.getAllScenarios());
	}
	
	public function post() hint='Adds new test scenario via the following JSON:
	{
		"id" : integer,
		"TestScenario" : string,
		"MilestoneID" : integer,
		"TestDescription" : string,
		"ProjectID" : integer,
		"CreatorUserId" : integer, //testerid
		"SectionID" : integer,
		"AxoSoftNumber" : string
	}'
	{
		if (cgi.content_type eq "application/json")
		{
			datapayload = deserializeJSON(ToString(getHttpRequestData().content));
		}
		objMetaData = GetMetaData(createObject("component", "/CFTestTrack/cfc/db/TTestScenario")).properties;
		if (objHelpers.testStruct(dataPayload, objMetaData) eq "true")
		{
			testscenario = createObject("component","/CFTestTrack/cfc/db/TTestScenario");
			testscenario.setTestScenario(datapayload.TESTSCENARIO);
			testscenario.setMilestoneID(datapayload.MILESTONEID);
			testscenario.setTestDescription(datapayload.TESTDESCRIPTION);
			testscenario.setProjectID(datapayload.PROJECTID);
			testscenario.setCreatorUserId(datapayload.CREATORUSERID);
			testscenario.setSectionID(datapayload.SECTIONID);
			testscenario.setAxoSoftNumber(datapayload.AXOSOFTNUMBER);
			EntitySave(testscenario);
			return representationOf(testresult);
		} else {
			return representationOf(objHelpers.testStruct(dataPayload, objMetaData));
		}
	}
	
	public function put() hint='Updates test scenario via the following JSON:
	{
		"id" : integer,
		"TestScenario" : string,
		"MilestoneID" : integer,
		"TestDescription" : string,
		"ProjectID" : integer,
		"CreatorUserId" : integer, //testerid
		"SectionID" : integer,
		"AxoSoftNumber" : string
	}'
	{
		if (cgi.content_type eq "application/json")
		{
			datapayload = deserializeJSON(ToString(getHttpRequestData().content));
		}
		objMetaData = GetMetaData(createObject("component", "/CFTestTrack/cfc/db/TTestScenario")).properties;
		if (objHelpers.testStruct(dataPayload, objMetaData) eq "true")
		{
			testscenario = createObject("component","/CFTestTrack/cfc/db/TTestScenario");
			testscenario.setId(datapayload.ID);
			testscenario.setTestScenario(datapayload.TESTSCENARIO);
			testscenario.setMilestoneID(datapayload.MILESTONEID);
			testscenario.setTestDescription(datapayload.TESTDESCRIPTION);
			testscenario.setProjectID(datapayload.PROJECTID);
			testscenario.setCreatorUserId(datapayload.CREATORUSERID);
			testscenario.setSectionID(datapayload.SECTIONID);
			testscenario.setAxoSoftNumber(datapayload.AXOSOFTNUMBER);
			EntitySave(testscenario);
			return representationOf(testresult);
		} else {
			return representationOf(objHelpers.testStruct(dataPayload, objMetaData));
		}
	}
}