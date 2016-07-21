component table="TTestTester" persistent="true"
{
	property name="id" column="id" fieldtype="id" generator="identity";
	property name="ADID";
	property name="UserName";
	property name="password";
	property name="salt";
	property name="email";
	property name="samaccountname";
	property name="isApproved" getter="false";
	property name="isAdmin" getter="false";
	property name="AxoSoftToken";
	
	public TTestTester function init() 
	{
		if (IsNull(variables.isApproved)) 
		{
			variables.isApproved = 0;
		}
		if (IsNull(variables.isAdmin))
		{
			variables.isAdmin = 0;
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
	
	public any function getIsAdmin()
	{
		if (isNull(variables.isAdmin))
		{
			return 0;
		} else {
			return variables.isAdmin;
		}
	}
}