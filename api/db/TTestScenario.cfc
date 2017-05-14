component table="TTestScenario" persistent="true"
{
	property name="id" column="id" fieldtype="id" generator="identity";
	property name="TestScenario";
	property name="MilestoneID" ormtype="integer" notnull="false";
	property name="TestDescription";
	property name="ProjectID" ormtype="integer" notnull="true";
	property name="CreatorUserId" ormtype="integer" notnull="true";
	property name="SectionID" ormtype="integer" notnull="false";
	property name="AxoSoftNumber";
}