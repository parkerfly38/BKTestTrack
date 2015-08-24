component table="TTestProject" persistent="true"
{
	property name="id" column="id" fieldtype="id" generator="identity";
	property name="ProjectTitle";
	property name="AxoSoftID";
	property name="ProjectDescription";
	property name="ProjectStartDate";
	property name="ProjectProjectedEndDate";
	property name="ProjectActualEndDate";
	property name="IncludeAnnouncement";
	property name="RepositoryType";
	property name="Closed";
	property name="Color" getter="false";
	property name="AxoSoftProjectID";
	
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