component  extends="taffy.core.resource" taffy_uri="/testresultsbyscenario/{scenarioid}"
{
	public function get(string scenarioid) hint='Returns scenario data by id.'
	{
		objData = createObject("component","/CFTestTrack/cfc/Data");
		return representationOf(objData.qryTestCaseHistoryForScenarios(scenarioid));
	}
}