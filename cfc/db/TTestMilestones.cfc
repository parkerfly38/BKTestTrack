component table="TTestMilestones" persistent="true"
{
	property name="id" column="id" fieldtype="id" generator="identity";
	property name="Milestone";
	property name="DueOn" ormtype="date" type="date";
	property name="MilestoneDescription";
	property name="Closed" getter="false";
	property name="ProjectID";
	
	public TTestMilestones function init() 
	{
		if (IsNull(variables.Closed)) 
		{
			variables.Closed = 0;
		}
		return this;
	}
	public any function getClosed() {
		if (IsNull(variables.Closed)) {
			return 0;
		} else {
			return variables.Closed;
		}
	}
	
}