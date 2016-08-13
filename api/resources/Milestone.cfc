component  extends="taffy.core.resource" taffy_uri="/milestones/{id}"
{
	objData = createObject("component","/CFTestTrack/cfc/Data");
	
	public function get(string id) hint='Retrieves a milestone by id.'
	{
		return representationOf(objData.getMilestone(id));
	}
	
	public function delete(string id) hint='Deletes a milestone by id.'
	{
		objData.deleteMilestone(id);
		return noData();
	}
}