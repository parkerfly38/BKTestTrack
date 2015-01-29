component
{
	public Reports function init(IReports report)
	{
		variables.report = arguments.report;	
		return this;
	}
	
	public any function runReport()
	{
		return variables.report.runReport();
	}
	
	public any function saveReport()
	{
		variables.report.saveReport();	
	}
	public numeric function getReportId() {
		return variables.report.getReportId();
	}
	
	public string function getFormFields() {
		return variables.report.getFormFields();
	}
	
	public string function getReportTypeName() {
		return variables.report.getReportTypeName();
	}
	public string function getGroup()
	{
		return variables.report.getGroup();
	}
	public string function getAuthor() {
		return variables.report.getAuthor();
	}
	public string function getVersion() {
		return variables.report.getVersion();
	}
	public string function getReportDescription() {
		return variables.report.getReportDescription();
	}
}