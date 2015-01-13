component
{
	public array function getAllProjects()
	{
		arrProjects = EntityLoad("TTestProject");
		return arrProjects;
	}
	
	public db.TTestProject function getProject(id) {
		project = entityLoad("TTestProject",id,true);
		return project;
	}
	
	public void function saveProject(db.TTestProject tp)
	{
		entitySave(arguments.tp);
	}
	
	public array function getAllTestCases()
	{
		arrTestCases = EntityLoad("TTestCase");
		return arrTestCases;
	}
	
	public db.TTestCase function getTestCase(id) {
		testcase = entityLoad("TTestCase",id,true);
		return testcase;
	}
	
	public array function getAssignedTestCasesByTesterId(id) {
		arrTestCases = ormExecuteQuery("FROM TTestCaseHistory WHERE TesterID = :testerid AND Action = 'Assigned' AND DateActionClosed IS NULL",{testerid=arguments.id});
		return arrTestCases;
	}
	
	public void function saveTestCase(db.TTestCase tc)
	{
		entitySave(arguments.tc);
	}
	
	public array function getAllStatuses()
	{
		statuses = entityLoad("TTestStatus");
		return statuses;
	}
	
	public array function getAllTesters()
	{
		testers = entityLoad("TTestTester");
		return testers;
	}
	
	public array function getAllTestCaseHistory()
	{
		history = entityLoad("TTestCaseHistory");
		return history;
	}
	
	public array function getTestCaseHistoryByTestCase(id) {
		history = entityLoad("TTestCaseHistory",{CaseId = arguments.id},false);
		return history;
	}
	
	public query function qryTestCaseHistoryByTestCase(id) {
		arrHistory = getTestCaseHistoryByTestCase(arguments.id);
		return EntityToQuery(arrHistory);
	}
	
	public array function getAllMilestones() 
	{
		milestones = entityLoad("TTestMilestones");
		return milestones;
	}
	public array function getAllLinks()
	{
		links = entityLoad("TTestLinks");
		return links;
	}
	public query function qryTestCaseForScenarios(scenarioid)
	{
		QueryHistory = new query();
		QueryHistory.setName("getTestCaseHistory");
		QueryHistory.addParam(name="scenarioid",value=arguments.scenarioid,cfsqltype="cf_sql_int");
		qryResult = QueryHistory.execute(sql="SELECT a.TestTitle, b.DateOfAction, c.UserName, b.DateActionClosed" &
				" FROM TTestCaseHistory b INNER JOIN TTestCase a ON a.id = b.CaseId INNER JOIN TTestTester c on b.TesterID = c.id INNER JOIN TTestScenarioCases d ON a.id = d.CaseId" &
				" WHERE d.ScenarioId = :scenarioid");
		return qryResult.getResult();
	}
	public query function qryTestCaseHistoryForScenarios(scenarioid) {
		QueryHistory = new query();
		QueryHistory.setName("getTestCaseHistory");
		QueryHistory.addParam(name="scenarioid",value=arguments.scenarioid,cfsqltype="cf_sql_int");
		qryResult = QueryHistory.execute(sql="Select TTestStatus.id, Status, ISNULL(Count(a.id),0) as StatusCount" &
											 " FROM TTestStatus " &
											 "LEFT JOIN (SELECT b.id, b.Action FROM TTestCaseHistory b INNER JOIN TTestScenarioCases c on b.CaseId = c.CaseId WHERE c.ScenarioID = :scenarioid AND DateActionClosed IS NULL) a " &
											 "ON a.Action = Status " &
											 "GROUP BY TTestStatus.id, Status " &
											 "ORDER BY TTestStatus.id");
		return qryResult.getResult();
	}
	public query function qryTestCaseHistoryDataForScenario(scenarioid) {
		qryNew = new query();
		qryNew.setName("getTestCaseHistory");
		qryNew.addParam(name="scenarioid",value=arguments.scenarioid,cfsqltype="cf_sql_int");
		qryResult = qryNew.execute(sql="SELECT DISTINCT d.TestTitle, a.CaseId, a.DateOfAction, a.Action, c.UserName FROM TTestCaseHistory a " &
										"INNER JOIN TTestScenarioCases b on a.CaseId = b.CaseId " &
										"INNER JOIN TTestTester c on a.TesterID = c.id " &
										"INNER JOIN TTestCase d on a.CaseId = d.id " &
										"WHERE b.ScenarioId = :scenarioid AND DateActionClosed IS NULL");
		return qryResult.getResult();
	}
}