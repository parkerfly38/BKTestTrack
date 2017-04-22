component  extends="taffy.core.resource" taffy_uri="/milestones"
{
	objData = createObject("component","/CFTestTrack/cfc/Data");
	
	public function get() hint='Returns all milestones'
	{
		return representationOf(objData.getAllMilestones());
	}
	
	public function post() hint='Add a milestone with the following JSON:
		{
			"id" : integer,
			"Milestone" : string,
			"MilestoneDescription" : string,
			"DueOn" : datetime,
			"Closed" : boolean,
			"ProjectID" : integer
		}
	'
	{
		if (cgi.content_type eq "application/json")
		{
			datapayload = deserializeJSON(ToString(getHttpRequestData().content));
		}
		objMetaData = GetMetaData(createObject("component", "/CFTestTrack/cfc/db/TTestMilestones")).properties;
		if (objHelpers.testStruct(dataPayload, objMetaData) eq "true")
		{
			milestone = createObject("component","/CFTestTrack/cfc/db/TTestMilestones");
			milestone.setMilestone(datapayload.MILESTONE);
			milestone.setMilestoneDescription(datapayload.MILESTONEDESCRIPTION);
			milestone.setDueOn(datapayload.DUEON);
			milestone.setClosed(datapayload.CLOSED);
			milestone.setProjectID(datapayload.PROJECTID);
			EntitySave(milestone);
			return representationOf(milestone);
		} else {
			return representationOf(objHelpers.testStruct(dataPayload, objMetaData));
		}
	}
	
	public function put() hint='Update a milestone with the following JSON:
		{
			"id" : integer,
			"Milestone" : string,
			"MilestoneDescription" : string,
			"DueOn" : datetime,
			"Closed" : boolean,
			"ProjectID" : integer
		}
	'
	{
		if (cgi.content_type eq "application/json")
		{
			datapayload = deserializeJSON(ToString(getHttpRequestData().content));
		}
		objMetaData = GetMetaData(createObject("component", "/CFTestTrack/cfc/db/TTestMilestones")).properties;
		if (objHelpers.testStruct(dataPayload, objMetaData) eq "true")
		{
			milestone = createObject("component","/CFTestTrack/cfc/db/TTestMilestones");
			milestone.setId(datapayload.ID);
			milestone.setMilestone(datapayload.MILESTONE);
			milestone.setMilestoneDescription(datapayload.MILESTONEDESCRIPTION);
			milestone.setDueOn(datapayload.DUEON);
			milestone.setClosed(datapayload.CLOSED);
			milestone.setProjectID(datapayload.PROJECTID);
			EntitySave(milestone);
			return representationOf(milestone);
		} else {
			return representationOf(objHelpers.testStruct(dataPayload, objMetaData));
		}
	}
}