component displayname="CodeCoverage" hint="Code Coverage Functions"
{
		
	public struct function GetCoverage(required string templatePath, required string testPath)
	{
		expandedTemplatePath = ExpandPath(templatePath);
		expandedTestPath = ExpandPath(testPath);
		
		structCoverageData = StructNew();
		
		cfdirectory( action="list" ,directory="#expandedTemplatePath#" ,name="cfcQuery", filter="*.cfc"  );
		cfdirectory( action="list", directory="#expandedTestPath#", name="testQuery", filter="*.cfc" );
		
		structCoverageData.Components = [];
		
		for( queryRow in cfcQuery )
		{
			if (queryRow["type"] == "file"  && queryRow["name"] != "IReports.cfc")
			{
				fileName = ReplaceNoCase(queryRow["name"],".cfc","","all");
				
				tempObj = createObject("component",#fileName#);
				objMeta = GetMetaData(tempObj);
				
				structComponentData = StructNew();
				structComponentData.Name = objMeta.Fullname;
				structComponentData.TestReferences = 0;
				structComponentData.Functions = [];
				
				for (testRow in testQuery)
				{
					fileData = fileRead(expandedTestPath &"/"& testRow["name"]);
					numberOfTimesReferenced = REMatchNoCase("(?i)"&objMeta.FullName,fileData);
					
					if (arrayLen(numberOfTimesReferenced) > 0) {
						structComponentData.TestReferences = structComponentData.TestReferences + arrayLen(numberOfTimesReferenced);
					}
				}
				ArrayEach(objMeta.functions,function(func) {
					functionData = StructNew();
					functionData.Name = func.name;
					functionData.TestReferences = 0;
					
					for (testRow in testQuery)
					{
						fileData = fileRead(expandedTestPath & "/" & testRow["name"]);
						numberofTimesReferenced = REMatchNoCase("(?i)" & func.name & "[(]", fileData);
						
						if (arrayLen(numberOfTimesReferenced) > 0 )
						{
							functionData.TestReferences = functionData.TestReferences + arrayLen(numberofTimesReferenced);
						}
					}
					ArrayAppend(structComponentData.Functions, functionData);
				});
				
			}	
			ArrayAppend(structCoverageData.Components, structComponentData);
		}
		
		return structCoverageData;
	}
}