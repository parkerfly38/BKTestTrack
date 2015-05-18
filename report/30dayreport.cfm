<cfstoredproc procedure="PReturnTestResultCounts" datasource="COGData">
	<cfprocresult name = ReportQuery> 
	<cfprocparam value="6" cfsqltype="CF_SQL_INTEGER">
</cfstoredproc>
<cfreport query="#ReportQuery#" template="30DayActivityReport.cfr" format="PDF">