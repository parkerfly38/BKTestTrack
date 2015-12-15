component table="TTestCaseHistory" persistent="true"
{
	property name="id" ormtype="integer" column="id" fieldtype="id" generator="identity";
	property name="Action" ormtype="string" notnull="false";
	property name="TesterID" ormtype="integer" notnull="true";
	property name="DateOfAction" ormtype="timestamp" notnull="true";
	property name="CaseId" ormtype="integer" notnull="true";
	property name="DateActionClosed" ormtype="timestamp" notnull="false";
}