component extends="taffy.core.resource" taffy_uri="/projects/{projectId}"
{
	public function get(string projectId)
	{
		objData = createObject("component","/CFTestTrack/cfc/Data");
		return representationOf(objData.getProject(projectId));
	}
	
	public function delete(string projectId)
	{
		objData = createObject("component","/CFTestTrack/cfc/Data");
		objData.deleteProject(projectId);
	}
} 