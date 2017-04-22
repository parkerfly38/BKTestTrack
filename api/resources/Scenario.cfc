component  extends="taffy.core.resource" taffy_uri="/scenarios/{scenarioid}"
{
	objData = createObject("component","/CFTestTrack/cfc/Data");
	
	public function get(string scenarioid) hint="Retrieves scenario by scenario id."
	{
		return representationOf(objData.getScenario(scenarioid));
	}
	
	public function delete(string scenarioid) hint="Deletes scenario by scenario id."
	{
		objData.deleteScenario(scenarioid);
		return noData();
	}
}