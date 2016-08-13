component  extends="taffy.core.resource" hint="Read only, returns tester IDs and User names." taffy_uri="/testers"
{
	objData = createObject("component","/CFTestTrack/cfc/Data");
	
	public function get() hint="Returns tester data."
	{
		testers = objData.GetAllTesters();
		i = 1;
		structTesters = [];
		for (tester in testers) 
		{
			structTesters[i] = { UserName = tester.getUserName(), email = tester.getEmail(), id = tester.getId() };
			i++;
		}
		return representationOf(structTesters);		
	}
}