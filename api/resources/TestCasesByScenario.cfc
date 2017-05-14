component extends="taffy.core.resource" taffy_uri="/testcasesbyscenario/{projectid}/{scenarioid}"
{
	
	objHelpers = createObject("component","/CFTestTrack/api/helpers");
	objData = createObject("component", "/CFTestTrack/cfc/Data");
	
	public function get(projectid, scenarioid)
	{
		tests = objData.getTestCasesByScenarioId(projectid, scenarioid);
		return representationOf(tests);
	}
}