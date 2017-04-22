component extends="taffy.core.resource" taffy_uri="/projects"
{
	objHelpers = createObject("component", "/CFTestTrack/api/helpers");
	public function get() hint='Returns all projects.'
	{
		objData = createObject("component","/CFTestTrack/cfc/Data");
		return representationOf(objData.getAllProjects());
		//return representationOf(application._taffy);
	}
	
	public function post() hint='Adds a new project using the following JSON: {
		  "Id" : "0",
		  "ProjectTitle" : "Project Title",
		  "ProjectDescription" : "",
		  "ProjectStartDate" : "08/11/2016",
		  "ProjectProjectedEndDate" : "09/02/2016",
		  "ProjectActualEndDate" : "",
		  "IncludeAnnouncement" : false,
		  "Closed" : false,
		  "Color" : "red",
		  "RepositoryType" : "git",
		  "AxoSoftID" : "",
		  "AxoSoftProjectID" : "",
		  "AxoSoftSystemID" : "",
		  "AxoSoftClient" : ""
		}'
	{
		if (cgi.content_type eq "application/json")
		{
			datapayload = deserializeJSON(ToString(getHttpRequestData().content));
		}
		objMetaData = GetMetaData(createObject("component", "/CFTestTrack/cfc/db/TTestProject")).properties;
		if (objHelpers.testStruct(dataPayload, objMetaData) eq "true")
		{
			newProject = createObject("component","/CFTestTrack/cfc/db/TTestProject");
			newProject.setProjectTitle(datapayload.PROJECTTITLE);
			newProject.setProjectDescription(datapayload.PROJECTDESCRIPTION);
			newProject.setProjectStartDate(datapayload.PROJECTSTARTDATE);
			newProject.setProjectProjectedEndDate(datapayload.PROJECTPROJECTEDENDDATE);
			newProject.setProjectActualEndDate(datapayload.PROJECTACTUALENDDATE);
			newProject.setIncludeAnnouncement(datapayload.INCLUDEANNOUNCEMENT);
			newProject.setClosed(datapayload.CLOSED);
			newProject.setColor(datapayload.COLOR);
			newProject.setRepositoryType(datapayload.REPOSITORYTYPE);
			newProject.setAxoSoftID(datapayload.AXOSOFTID);
			newProject.setAxoSoftSystemID(datapayload.AXOSOFTSYSTEMID);
			newProject.setAxoSoftClient(datapayload.axosoftclient);
			EntitySave(newProject);
			return representationOf(newProject);
		} else {
			return representationOf(objHelpers.testStruct(dataPayload, objMetaData));
		}
	}
	
	public function put() hint='Updates a project using the following JSON: {
		"id" : integer,
		"ProjectTitle" : string,
		"ProjectDescription" : string,
		"ProjectStartDate" : string,
		"ProjectProjectedEndDate" : datetime,
		"ProjectActualEndDate" : datetime or null,
		"IncludeAnnouncement" : boolean,
		"Closed" : boolean,
		"Color" : string //hex,
		"RepositoryType" : string,
		"AxoSoftID" : string,
		"AxoSoftProjectID" : string,
		"AxoSoftSystemID" : string,
		"AxoSoftClient" : string,
		"CodePath" : string,
		"TestProjectPath" : string
	}'
	{
		if (cgi.content_type eq "application/json")
		{
			datapayload = deserializeJSON(ToString(getHttpRequestData().content));
		}
		objMetaData = GetMetaData(createObject("component", "/CFTestTrack/cfc/db/TTestProject")).properties;
		if (objHelpers.testStruct(dataPayload, objMetaData) eq "true")
		{
			updatedProject = EntityLoadByPK("TTestProject", datapayload.id);
			updatedProject.setProjectTitle(datapayload.PROJECTTITLE);
			updatedProject.setProjectDescription(datapayload.PROJECTDESCRIPTION);
			updatedProject.setProjectStartDate(datapayload.PROJECTSTARTDATE);
			updatedProject.setProjectProjectedEndDate(datapayload.PROJECTPROJECTEDENDDATE);
			updatedProject.setProjectActualEndDate(datapayload.PROJECTACTUALENDDATE);
			updatedProject.setIncludeAnnouncement(datapayload.INCLUDEANNOUNCEMENT);
			updatedProject.setClosed(datapayload.CLOSED);
			updatedProject.setColor(datapayload.COLOR);
			updatedProject.setRepositoryType(datapayload.REPOSITORYTYPE);
			updatedProject.setAxoSoftID(datapayload.AXOSOFTID);
			updatedProject.setAxoSoftSystemID(datapayload.AXOSOFTSYSTEMID);
			updatedProject.setAxoSoftClient(datapayload.axosoftclient);
			EntitySave(updatedProject);
			return representationOf(updatedProject);
		} else {
			return representationOf(objHelpers.testStruct(dataPayload, objMetaData));
		}
	}
}