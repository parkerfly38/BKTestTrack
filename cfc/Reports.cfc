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
	
	public void function saveReport()
	{
		variables.report.saveReport();	
	}
}