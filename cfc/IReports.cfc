interface hint="this shapes the expected output from any report - please use implements=IReports in all report components" 
{
	public string function getReportTypeName();
	public string function getGroup();
	public string function getAuthor();
	public string function getVersion();
	public numeric function getReportId();
	
	public string function getReportName();
	public string function getReportDescription();
	
	public struct function getReportOptions();
	public struct function getAccessAndScheduling();
	
	public void function setReportOptions(required struct reportoptions);
	public void function setAccessAndScheduling(required struct accessandscheduling);
	
	public string function getFormFields();
	public string function getJSONFormDataForPost();
	
	public void function saveReport();
	public any function runReport();
	
}