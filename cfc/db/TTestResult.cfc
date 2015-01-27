component table="TTestResult" persistent="true"
{
	property name="id" column="id" fieldtype="id" generator="identity";
	//property name="TesterID";
	property name="Version";
	property name="ElapsedTime";
	property name="Comment";
	property name="DateTested";
	property name="AttachmentList";
	property name="TestCaseID";
	property name="TTestStatus" fieldtype="one-to-one" cfc="TTestStatus" fkcolumn="StatusID";
	property name="TTestTester" fieldtype="one-to-one" cfc="TTestTester" fkcolumn="TesterID";
	
	public void function postInsert() {
		//update any old case history for caseid
		updatequery = new Query();
		updatequery.setSql("UPDATE TTestCaseHistory SET DateActionClosed = :dateactionclosed WHERE caseid = :caseid AND DateActionClosed is NULL");
		updatequery.addParam(name="dateactionclosed",value=now(),cfsqltype="cf_sql_date");
		updatequery.addParam(name="caseid",value=this.getTestCaseID(),cfsqltype="cf_sql_integer");
		updatequery.execute();
		newcasehistory = EntityNew("TTestCaseHistory");
		newcasehistory.setAction(this.getTTestStatus().getStatus());
		newcasehistory.setTesterID(this.getTTestTester().getId());
		newcasehistory.setDateOfAction(Now());
		if ( this.getTTestStatus().getStatus() == "Passed" ) {
			newcasehistory.setDateActionClosed(now());
		}
		newcasehistory.setCaseId(this.getTestCaseID());
		EntitySave(newcasehistory);
	}
}