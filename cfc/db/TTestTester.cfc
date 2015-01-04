component table="TTestTester" persistent="true"
{
	property name="id" column="id" fieldtype="id" generator="identity";
	property name="ADID";
	property name="UserName";
	property name="password";
	property name="salt";
	property name="email";
	property name="samaccountname";
	property name="isApproved";
}