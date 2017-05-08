component table="TTestScenarioCases" persistent="true"
{
	property name="id" column="id" fieldtype="id" generator="identity";
	property name="ScenarioId" ormtype="integer" notnull="true";
	property name="CaseId" ormtype="integer" notnull="true";
}