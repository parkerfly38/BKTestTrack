component table="TTestTester" persistent="true"
{
	property name="id" column="id" fieldtype="id" ormtype="integer" generator="identity";
	property name="ADID" ormtype="string" length="50" notnull="true";
	property name="UserName" ormtype="string" length="255" notnull="true";
	property name="password" ormtype="string" length="1000" notnull="false";
	property name="email" ormtype="string" length="255" notnull="false";
	property name="salt" ormtype="string" length="1000" notnull="false";
	property name="samaccountname" ormtype="string" length="255" notnull="false";
	property name="isApproved" getter="false" ormtype="boolean" notnull="true";
	property name="AxoSoftToken" ormtype="string" length="50" notnull="false";
	
	public TTestTester function init() 
	{
		if (IsNull(variables.isApproved)) 
		{
			variables.isApproved = 0;
		}
		return this;
	}
	public any function getIsApproved() {
		if (IsNull(variables.isApproved)) {
			return 0;
		} else {
			return variables.isApproved;
		}
	}
}