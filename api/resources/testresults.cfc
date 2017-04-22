component extends="taffy.core.resource" taffy_uri="/testresults/{projectId}"
{
	public function get(string projectId) hint='Returns project by id.'
	{
		objData = createObject("component","/CFTestTrack/cfc/Data");
		return representationOf(objData.qryCounts(projectId));
	}
} 