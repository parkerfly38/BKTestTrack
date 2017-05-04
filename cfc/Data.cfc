component
{
	public boolean function isAPIKeyActivated(string publicKey)
	{
		return EntityLoad("TTestAPIUserKeys", {clientid=publicKey},true).getActivated();
	}
	
	public string function getPrivateKeyByPublicKey(string publicKey)
	{
		privateKey = EntityLoad("TTestAPIUserKeys",{clientid=publicKey},true).getPrivatekey();
		return privateKey;
	}
	
	public any function generatePublicPrivateKeys(integer testerid)
	{
		newkeys = {publickey = CreateUUID(), privatekey = CreateUUID() };
		newAPIKey = EntityNew("TTestAPIUserKeys");
		newAPIKey.setClientid(newkeys.publickey);
		newAPIKey.setPrivatekey(newkeys.privatekey);
		newAPIKey.setTesterid(arguments.testerid);
		newAPIKey.setActivated("false");
		EntitySave(newAPIKey);
		return newAPIKey;
	}
	
	public array function getAllProjects()
	{
		arrProjects = EntityLoad("TTestProject");
		return arrProjects;
	}
	
	public db.TTestProject function getProject(id) {
		project = entityLoad("TTestProject",id,true);
		return project;
	}
	
	public void function deleteProject(id) {
		project = getProject(id);
		EntityDelete(project);
	}
	
	public void function deleteMilestone(id) {
		milestone = getMilestone(id);
		EntityDelete(milestone);
	}
	
	public db.TTestScenario function getScenario(id) {
		scenario = EntityLoad("TTestScenario",id, true);
		return scenario;
	}

	public array function getScenarioByProjectID(numeric projectid) {
		scenarios = EntityLoad("TTestScenario",{projectid = arguments.projectid}, false);
		return scenarios;
	}

	public void function deleteScenario(id) {
		scenario = getScenario(id);
		EntityDelete(scenario);
	}
	
	public void function saveProject(db.TTestProject tp)
	{
		entitySave(arguments.tp);
	}
	
	public db.TTestMilestones function getMilestone(id) {
		milestone = entityLoad("TTestMilestones",id,true);
		return milestone;
	}
	
	public array function getAllTestCases()
	{
		arrTestCases = EntityLoad("TTestCase");
		return arrTestCases;
	}
	
	public query function getAllOpenCases()
	{
		qryNew = new query();
		qryNew.setName("getOPENTestCases");
		qryResult = qryNew.execute(sql="SELECT id, TestTitle, TestDetails, PriorityId, TypeId, Preconditions, Steps, ExpectedResult, MilestoneId, Estimate, ProjectID FROM TTestCase WHERE id not in (SELECT TestCaseID FROM TTestResult WHERE StatusID = 2)
");
		return qryResult.getResult();
	}
	
	public array function getTestResults(id)
	{
		arrTestResults = EntityLoad("TTestResult",{TestCaseId = arguments.id});
		return arrTestResults;
	}
	
	public array function getAllTestResults()
	{
		arrTestResults = EntityLoad("TTestResult");
		return arrTestResults;
	}
	
	public array function getTestCasesByProject(projectid)
	{
		arrTestCases = EntityLoad("TTestCase",{ProjectID=arguments.projectid});
		return arrTestCases;
	}
	
	public array function getAllScenarios()
	{
		arrScenarios = EntityLoad("TTestScenario");
		return arrScenarios;
	}
	
	public array function getTestTypes()
	{
		arrTestTypes = EntityLoad("TTestType");
		return arrTestTypes;
	}
	
	public void function deleteTestCase(id) {
		testcase = getTestCase(id);
		EntityDelete(testcase);
	}
	
	public db.TTestCase function getTestCase(id) {
		testcase = entityLoad("TTestCase",id,true);
		return testcase;
	}
	
	public array function getAssignedTestCasesByTesterId(id) {
		arrTestCases = ormExecuteQuery("FROM TTestCaseHistory WHERE TesterID = :testerid AND Action = 'Assigned' AND DateActionClosed IS NULL",{testerid=arguments.id});
		return arrTestCases;
	}
	
	public db.TTestCase function saveTestCase(db.TTestCase tc)
	{
		entitySave(arguments.tc);
		return arguments.tc;
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
	
	public db.TTestTester function getTester(string id)
	{
		tester = entityLoad("TTestTester", {id = arguments.id}, true);
		return tester;
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
	
	public void function deleteTestCaseHistory(id)
	{
		testcasehistory = EntityLoadByPk("TTestCaseHistory", id);
		EntityDelete(testcasehistory);
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
	
	public array function getMilestonesByProjectId(id)
	{
		milestones = entityLoad("TTestMilestones",{projectid = arguments.id},"DueOn Desc");
		return milestones;
	}
	public array function getAllLinks()
	{
		links = entityLoad("TTestLinks");
		return links;
	}
	
	public array function getAllPriorityTypes()
	{
		prioritytypes = entityLoad("TTestPriorityType");
		return prioritytypes;
	}
	
	public query function qryTestCaseForScenarios(numeric scenarioid)
	{
		qryResult = queryExecute(
			"SELECT a.id as TestCaseId, a.TestTitle, b.DateOfAction, c.UserName, b.DateActionClosed" &
			" FROM TTestCaseHistory b INNER JOIN TTestCase a ON a.id = b.CaseId INNER JOIN TTestTester c on b.TesterID = c.id INNER JOIN TTestScenarioCases d ON a.id = d.CaseId" &
			" WHERE d.ScenarioId = " & arguments.scenarioid & " and b.DateActionClosed IS NULL ORDER BY a.id ASC");
		return qryResult;	
	}
	public query function qryTestCasesForProject(projectid)
	{
		qryNew = new query();
		qryNew.setName("getTestCases");
		qryNew.addParam(name="projectid",value=arguments.projectid,cfsqltype="cf_sql_int");
		qryResult = qryNew.execute(sql="SELECT a.id as id, a.TestTitle, b.DateOfAction, c.UserName, b.DateActionClosed" &
				" FROM TTestCaseHistory b INNER JOIN TTestCase a ON a.id = b.CaseId INNER JOIN TTestTester c on b.TesterID = c.id " &
				" WHERE a.ProjectId = :projectid and b.DateActionClosed IS NULL");
		return qryResult.getResult();
	}
	public query function qryTestCaseHistoryForScenarios(numeric scenarioid) {
		qryResult = queryExecute(
			"SELECT id,Status,Sum(StatusCount) as StatusCount FROM ( Select TTestStatus.id, Status, COALESCE(Count(a.id),0) as StatusCount FROM TTestStatus 
			LEFT JOIN ( SELECT b.id, b.Action FROM TTestCaseHistory b INNER JOIN TTestScenarioCases c on b.CaseId = c.CaseId WHERE c.ScenarioId = " & arguments.scenarioid & " and b.DateActionClosed is null ) a 
			ON a.Action = TTestStatus.Status GROUP BY TTestStatus.id, Status  UNION ALL SELECT 1 as id,(CASE WHEN Action IN ('Created','Assigned') THEN 'Untested' END) as Status, 
			COALESCE(Count(TTestCaseHistory.id),0) as StatusCount FROM TTestCaseHistory INNER JOIN TTestScenarioCases on TTestScenarioCases.CaseID = TTestCaseHistory.CaseID 
			WHERE ScenarioId = " & arguments.scenarioid & " AND Action IN ('Created','Assigned') AND DateActionClosed IS NULL GROUP BY Action ) DERIVED GROUP BY id, Status");
		return qryResult;
	}
	public query function qryTestCaseHistoryDataByProject(projectid) {
		qryNew = new query();
		qryNew.setName("getTestCaseHistory");
		qryNew.addParam(name="projectid",value=arguments.projectid,cfsqltype="cf_sql_int");
		qryResult = qryNew.execute(sql="SELECT DISTINCT a.TestTitle, b.TestCaseId, b.DateTested, d.Status, c.UserName FROM TTestResult b " &
										"INNER JOIN TTestCase a on b.TestCaseId = a.id " &
										"INNER JOIN TTestTester c on c.id = b.TesterID " &
										"INNER JOIN TTestStatus d on d.id = b.StatusID " &
										"WHERE a.ProjectId = :projectid");
		return qryResult.getResult();
	}
	
	public query function qryTestDefects(string scenarioVariables)
	{
		qryNew = new query();
		qryNew.SetName("getTestDefects");
		sqlString = "SELECT TTestCase.TestTitle, " &
					"TTestCaseHistory.Action, " &
					"TTestResult.DateTested, " &
					"TTestResult.Comment, " &
					"TTestResult.Defects, " &
					"TTestResult.ElapsedTime, " &
					"TTestResult.Version, " &
					"TTestTester.UserName, " &
					"TTestScenario.TestScenario " &
					"FROM " &
					"	TTestCaseHistory " &
					"INNER JOIN " &
					"	TTestCase on TTestCase.id = TTestCaseHistory.CaseId " &
					"INNER JOIN " &
					"	TTestScenarioCases on TTestScenarioCases.CaseId = TTestCaseHistory.CaseId " &
					"INNER JOIN " &
					"	TTestScenario on TTestScenario.id = TTestScenarioCases.ScenarioId " &
					"INNER JOIN " &
					"	TTestResult on TTestResult.TestCaseID = TTestCaseHistory.CaseId " & 
					"	AND  " &
					"		DATEADD(ms, -DATEPART(ms, TTestResult.DateTested), TTestResult.DateTested) = DATEADD(ms, -DATEPART(ms, TTestCaseHistory.DateOfAction), TTestCaseHistory.DateOfAction) " &
					"INNER JOIN " &
					"	TTestTester on TTestTester.id = TTestResult.TesterID " &
					"WHERE  " &
					"	TTestCaseHistory.DateActionClosed is null " &
					"	AND TTestResult.StatusID IN (3,4,5) " &
					"	AND TTestScenarioCases.ScenarioId IN (" & arguments.scenarioVariables & ")";
		qryResult = qryNew.execute(sql = sqlString);
		return qryResult.getResult();
	}

	public query function qryTestCaseDefectsSummary(string projectid)
	{
		qryNew = new query();
		qryNew.SetName("getTestCaseDefectSummary");
		sqlString =	"SELECT TTestCase.TestTitle, " &
					"TTestCaseHistory.ACtion, " &
					"TTestResult.DateTested, " &
					"TTestResult.Defects," &
					"TTestResult.ElapsedTime, " &
					"TTestResult.Version, " &
					"TTestTester.UserName " &
					"FROM " &
					"	TTestCaseHistory " &
					"INNER JOIN " &
					"	TTestCase on TTestCase.id = TTestCaseHistory.CaseId " &
					"INNER JOIN " &
					"	TTestResult on TTestResult.TestCaseID = TTestCaseHistory.CaseId " & 
					"	AND  " &
					"		DATEADD(ms, -DATEPART(ms, TTestResult.DateTested), TTestResult.DateTested) = DATEADD(ms, -DATEPART(ms, TTestCaseHistory.DateOfAction), TTestCaseHistory.DateOfAction) " &
					"INNER JOIN " &
					"	TTestTester on TTestTester.id = TTestResult.TesterID " &
					"WHERE " &
					"	TTestCase.ProjectID = " & arguments.projectid;
		qryResult = qryNew.execute(sql = sqlString);
		return qryResult.getResult();
	}

	public query function qryTestCaseHistoryDataForScenario(numeric scenarioid) {
		qryResult = queryExecute("SELECT DISTINCT d.TestTitle, a.TestCaseId, a.DateTested, e.Status, c.UserName FROM TTestResult a " &
										"INNER JOIN TTestScenarioCases b on a.TestCaseId = b.CaseId " &
										"INNER JOIN TTestTester c on a.TesterID = c.id " &
										"INNER JOIN TTestCase d on a.TestCaseId = d.id " &
										"INNER JOIN TTestStatus e on a.StatusID = e.id " &
										"WHERE b.ScenarioId = " & arguments.scenarioid);
		return qryResult;
	}
	public query function qryTestCaseHistoryAllForScenario(scenarioid) {
		qrynew = new query();
		qrynew.setName("getTestCaseHistory");
		qrynew.addParam(name="scenarioid",value=arguments.scenarioid,cfsqltype="cf_sql_int");
		qryResult = qrynew.execute(sql="SELECT d.TestTitle, e.Status, b.UserName, a.DateTested " &
									   "FROM TTestResult a " &
									   "INNER JOIN TTestTester b ON a.TesterID = b.id " &
									   "INNER JOIN TTestScenarioCases c ON a.TestCaseId = c.CaseId " &
									   "INNER JOIN TTestCase d on a.TestCaseId = d.id " &
									   "INNER JOIN TTestStatus e on a.StatusID = e.id " &
									   "WHERE c.ScenarioId = :scenarioid " &
									   "AND DateTested BETWEEN DATEADD(DAY,1,GETDATE()) AND DATEADD(DAY,-14,GETDATE()) " &
									   "ORDER BY TestTitle, DateTested");
		return qryResult.getResult();
	}
	public query function qryTestCasesAssignedScenario(numeric scenarioid) {
		qryResult = queryExecute("SELECT b.TestTitle, c.DateOfAction, d.UserName FROM TTestScenarioCases a " &
										"INNER JOIN TTestCase b ON b.id = a.CaseId " &
										"INNER JOIN TTestCaseHistory c on c.CaseID = a.CaseId " &
										"INNER JOIN TTestTester d on d.id = c.TesterID " &
										"WHERE a.ScenarioId = " & arguments.scenarioid & " AND c.Action = 'Assigned'");
		return qryResult;
	}

	public query function qryGetCurrentTestStatus(numeric caseid) {
		cfdbinfo(name="dbInfo",type="version");
		
		if (dbinfo.DATABASE_PRODUCTNAME[1] eq "PostgreSQL")
		{
			qryResult = queryExecute(
				"SELECT COALESCE(d.Status,'Assigned') as Status FROM TTestCase a
				LEFT JOIN (SELECT c.TestCaseId, b.Status FROM TTestResult c INNER JOIN TTestStatus b on b.id = c.StatusID WHERE c.TestCaseId = " & arguments.caseid & "
				ORDER BY c.id DESC LIMIT 1) d on d.TestCaseId = a.id
				WHERE a.id = " & arguments.caseid
			);
		} else {	
			qryResult = queryExecute(
				"SELECT COALESCE(d.Status,'Assigned') as Status FROM TTestCase a 
				LEFT JOIN (SELECT TOP 1 c.TestCaseId, b.Status FROM TTestResult c INNER JOIN TTestStatus b on b.id = c.StatusID WHERE c.TestCaseId = " & arguments.caseid & "
				ORDER BY c.id DESC) d ON d.TestCaseId = a.id 
				WHERE a.id = " & arguments.caseid);
		}
		return qryResult;
	}
	
	public query function qryGetChatLog()
	{
		cfdbinfo(name="dbInfo",type="version");
		
		if (dbinfo.DATABASE_PRODUCTNAME[1] eq "PostgreSQL")
		{
			qryChatLog = queryExecute(
				"SELECT a.* FROM (SELECT username, messageDate, messageBody FROM TTestMessageLog ORDER BY messageDate DESC LIMIT 100) a order by a.MessageDate"
			);
		} else {
			qryChatLog = queryExecute(
				"SELECT a.* FROM (SELECT TOP 100 username, messageDate, messageBody FROM TTestMessageLog ORDER BY messageDate desc) a order by a.MessageDate"
			);
		}
		return qryChatLog;
	}
	
	public query function qryGetChatLogMini()
	{
		cfdbinfo(name="dbInfo",type="version");
		
		if (dbinfo.DATABASE_PRODUCTNAME[1] eq "PostgreSQL")
		{
			qryChatLog = queryExecute(
				"SELECT a.* FROM (SELECT username, messageDate, messageBody FROM TTestMessageLog ORDER BY messageDate DESC LIMIT 100) a order by a.MessageDate"
			);
		} else {
			qryChatLog = queryExecute(
				"SELECT a.* FROM (SELECT TOP 100 username, messageDate, messageBody FROM TTestMessageLog WHERE username <> 'System' ORDER BY messageDate desc) a order by a.MessageDate desc"
			);
		}
		return qryChatLog;
	}
	
	public void function SaveMessage(string username, date messagedate, string messagebody)
	{
		queryexecute("
			INSERT INTO TTestMessageLog (username, messageDate, messageBody)
			VALUES ( :username, :messagedate, :messagebody )",
			{ username : { value: arguments.username, cfSqlType: "cf_sql_varchar" },
			  messagedate : { value: arguments.messagedate, cfSqlType: "cf_sql_timestamp" },
			  messagebody : { value: arguments.messagebody, cfsqltype: "cf_sql_varchar" }
			 });
	}
	
	public query function qryGeneralActivity()
	{
		cfdbinfo(name="dbInfo", type="version");
		if (dbinfo.DATABASE_PRODUCTNAME[1] eq "PostgreSQL")
		{
			qryGeneralActivity = queryExecute(
				"SELECT *
					FROM crosstab('SELECT ProjectTitle, DateTested, Color
					FROM TTestProject
					INNER JOIN TTestCase ON TTestCase.ProjectID = TTestProject.id
					INNER JOIN TTestResult ON TTestResult.TestCaseID = TTestCase.id
					WHERE DateTested <= CURRENT_DATE and DateTested >= (CURRENT_DATE - INTERVAL ''14 days'')
					AND Closed = false')
					as ttestproject(projecttitle text, date_1 text, date_2 text, date_3 text, date_4 text, date_5 text, date_6 text, date_7 text, date_8 text, date_9 text, date_10 text, date_11 text, date_12 text, date_13 text, date_14 text);
				");
		} else {
			cfstoredproc(procedure="PGeneralActivityByProject")
			{
				cfprocresult(name="qryGeneralActivity");
				
			}
		}
		if (!isQuery(qryGeneralActivity))
		{
			qryGeneralActivity = QueryNew("ProjectTitle, Colors","VarChar, VarChar");
		}
		return qryGeneralActivity;
	}
	
	public query function qryCounts(numeric projectid)
	{
		cfdbinfo(name="dbInfo", type="version");
		if (dbInfo.DATABASE_PRODUCTNAME[1] eq "PostgreSQL")
		{
			qryCounts = queryExecute(
				"SELECT		to_char(DateTested, 'MM/DD/YYYY') as DateTested,
							sum(case when StatusID = 2 then 1 else 0 end) as PassedCount,
							sum(case when StatusID = 3 then 1 else 0 end) as FailedCount,
							sum(case when StatusID = 1 then 1 else 0 end) as UntestedCount,
							sum(case when StatusID = 4 then 1 else 0 end) as BlockedCount,
							sum(case when StatusID = 5 then 1 else 0 end) as RetestCount
				FROM		TTestResult
				INNER JOIN	TTestCase ON TTestResult.TestCaseID = TTestCase.id
				WHERE		DateTested <= CURRENT_DATE and DateTested >= (CURRENT_DATE - INTERVAL '14 days')
				AND			TTestCase.ProjectID = " & arguments.projectid & "
				GROUP BY	DateTested"
			);
		} else {
			cfstoredproc(procedure="PReturnTestResultCounts")
			{
				cfprocparam(cfsqltype="cf_sql_int", value="#arguments.projectId#");
				cfprocresult(name="qryCounts");
			}
		}
		return qryCounts;
	}
		
	public query function qryTestResultCountsTotal(numeric projectid)
	{
		cfdbinfo(name="dbInfo", type="version");
		if (dbInfo.DATABASE_PRODUCTNAME[1] eq "PostgreSQL")
		{
			qryCounts = queryExecute(
				"SELECT		a.StatusID,b.[Status], count(a.id) as ItemCount
				FROM		TTestResult a
				INNER JOIN	TTestStatus b on a.StatusID = b.id
				INNER JOIN  TTestCase c on a.TestCaseID = c.id
				WHERE		c.ProjectID = " & arguments.projectid & "
				GROUP BY	a.StatusID,b.[Status]"
			);
		} else {
			cfstoredproc(procedure="PReturnTestResultCountsTotal")
			{
				cfprocparam(cfsqltype="cf_sql_int", value="#arguments.projectid#");
				qfprocresult(name="qryCounts");
			}
		}
	}
	
	public query function getLastTestResultStatus(numeric testcaseid)
	{
		cfdbinfo(name="dbInfo", type="version");
		if (dbInfo.DATABASE_PRODUCTNAME[1] eq "PostgreSQL")
		{
			qryResult = queryExecute(
				"SELECT COALESCE(StatusID,5) as StatusID FROM TTestResult
				WHERE TestCaseID = " & arguments.testcaseid & "
				ORDER BY id DESC
				LIMIT 1"
			);
		} else {
			qryResult = queryExecute(
				"SELECT ISNULL(StatusID,5) as StatusID FROM TTestResult WHERE
				id in (SELECT MAX(id) FROM TTestResult WHERE TestCaseID = " & arguments.testcaseid & ")");
		}
		return qryResult;
	}
	
	public query function getTestCasesByScenarioId(numeric projectid, numeric scenarioid)
	{
		qryResult = queryExecute(
			"	SELECT id, TestTitle
			FROM TTestCase
			WHERE ProjectID = " & arguments.projectid & "
			AND id not in (SELECT CaseID from TTestScenarioCases where ScenarioId = " & arguments.scenarioid & ") "
		);
		return qryResult;
	}
		
	public query function qryGetProblemTestCases(numeric projectid, date datestart, date dateend)
	{
		qryResult = queryExecute(
			"SELECT 
					TTestCase.id,
					TTestCase.TestTitle,
					results.ResultCount
			FROM
				TTestCase
			INNER JOIN (			
			SELECT testcaseid, Count(id) AS ResultCount
			FROM TTestResult
			WHERE statusid in (3,4,5)
			AND datetested >= '" & DateFormat(arguments.datestart,'yyyy-mm-dd') & "'
			AND datetested <= '" & DateFormat(arguments.dateend,'yyyy-mm-dd') & "'
			GROUP BY testcaseid ) results ON results.testcaseid = TTestCase.id
			WHERE results.ResultCount > 2
			AND TTestCase.ProjectId = " & arguments.projectid);
		return qryResult;
	}
}
