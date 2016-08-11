component 
{
	public any function testStruct(struct jsonStruct, array propertyMetaData)
	{
		//listOfKeys = StructKeyList(originStruct);
		for ( var i = 1; i lte ArrayLen(propertyMetaData); i++)
		{
			nameOfKey = propertyMetaData[i].name;
			if(!StructKeyExists(jsonStruct, nameOfKey))
			{
				return "Missing field " & nameOfKey;
			}
		}
		return true;
	}
	
}