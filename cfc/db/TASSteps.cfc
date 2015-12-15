component table="TASSteps" persistent="true"
{
	property name="id" column="id" fieldtype="id" generator="identity";
	property name="TestID" ormtype="integer";
	property name="Action";
	property name="ValueOne";
	property name="ValueTwo";
	property name="ValueThree";
	property name="ValueFour";
	property name="AssertionMessage";
	property name="OrderOfOperation" ormtype="integer";
}