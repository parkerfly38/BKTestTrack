component
{
	public Reports function init(IReports report)
	{
		variables.report = arguments.report;	
		return this;
	}
	
	public void function runReport()
	{
		variables.report.runReport();
	}
	
	public any function saveReport()
	{
		variables.report.saveReport();	
	}
	public numeric function getReportId() {
		return variables.report.getReportId();
	}
}