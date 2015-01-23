interface hint="this shapes the expected output from any report - please use implements=IReports in all report components" 
{
	public string function getReportTypeName();
	public string function getGroup();
	public string function getAuthor();
	public string function getVersion();
	
	public string function getReportName();
	public string function getReportDescription();
	
	public struct function getReportOptions();
	public struct function getAccessAndScheduling();
	
	public void function saveReport();
	public any function runReport();
	
}