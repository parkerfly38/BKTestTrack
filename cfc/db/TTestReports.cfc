component table="TTestReports" persistent="true"
{
	property name="id" column="id" fieldtype="id" generator="identity";
	property name="ReportTypeName";
	property name="ReportGroup";
	property name="ReportAuthor";
	property name="ReportVersion";
	property name="ReportName";
	property name="ReportDescription";
	property name="ReportOptions";
	property name="ReportAccessAndScheduling";
	property name="ProjectID";
}