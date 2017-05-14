component table="TTestTokens" persistent="true"
{
	property name="TesterID" fieldtype="id" ormtype="integer";
	property name="access_token" ormtype="string";
	property name="DateCreated" ormtype="date";
	property name="DateExpires" ormtype="date";
	
	public function getDateCreated()
	{
	}
}