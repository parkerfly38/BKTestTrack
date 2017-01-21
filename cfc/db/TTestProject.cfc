component table="TTestProject" persistent="true"
{
	property name="id" column="id" fieldtype="id" generator="identity";
	property name="ProjectTitle" ormtype="string" length="1000";
	property name="AxoSoftID" ormtype="integer";
	property name="ProjectDescription" ormtype="string" length="4000";
	property name="ProjectStartDate" ortmype="date" notnull="true";
	property name="ProjectProjectedEndDate" ormtype="date" notnull="true";
	property name="ProjectActualEndDate" ormtype="date" notnull="false" default="";
	property name="IncludeAnnouncement" ormtype="boolean";
	property name="RepositoryType" ormtype="string";
	property name="Closed" ormtype="boolean" notnull="false";
	property name="Color" getter="false";
	property name="AxoSoftProjectID" ormtype="string" notnull="false" default="";
	property name="AxoSoftSystemID" ormtype="string" notnull="false";
	property name="AxoSoftClient" ormtype="string" notnull="false";
	property name="CodePath" ormtype="string" notnull="false" default="";
	property name="TestProjectPath" ormtype="string" notnull="false" default="";
	
	public TTestProject function init()
	{
		if (isNull(variables.Color)) {
			variables.Color = writeColor();
		}
		return this;
	}
	public void function postLoad()
	{
		if (isNull(variables.Color)) {
			variables.Color = writeColor();
		}
	}
	public function getColor() {
		if (isNull(variables.Color)) {
			variables.Color = writeColor();
		}
		return variables.Color;
	}
	
	private string function writeColor() {
		return FormatBaseN((RandRange(0,255)+102)/2, 16) & FormatBaseN((RandRange(0,255)+205)/2, 16) & FormatBaseN((RandRange(0,255)+170)/2, 16);
	}
}
