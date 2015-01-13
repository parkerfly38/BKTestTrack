component table="TTestCase" persistent="true"
{
	property name="id" column="id" fieldtype="id" generator="identity";
	property name="TestTitle";
	property name="TestDetails";
	property name="PriorityId";
	property name="TypeId";
	property name="SectionId";
	property name="Preconditions";
	property name="Steps";
	property name="ExpectedResult";
	property name="MilestoneId";
	property name="Estimate";
	property name="ProjectID";
	property name="TTestCaseHistory" fieldtype="one-to-many" cfc="TTestCaseHistory" inversejoincolumn="id" fkcolumn="CaseId";
	property name="TTestResult" fieldtype="one-to-many" cfc="TTestResult" inversejoincolumn="id" fkcolumn="TestCaseID";
}