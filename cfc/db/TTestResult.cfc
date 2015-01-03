component table="TTestResult" persistent="true"
{
	property name="id" column="id" fieldtype="id" generator="identity";
	//property name="TesterID";
	property name="Version";
	property name="ElapsedTime";
	property name="Comment";
	property name="DateTested";
	property name="AttachmentList";
	property name="TestCaseID";
	property name="TTestStatus" fieldtype="one-to-one" cfc="TTestStatus" fkcolumn="StatusID";
	property name="TTestTester" fieldtype="one-to-one" cfc="TTestTester" fkcolumn="TesterID";
}