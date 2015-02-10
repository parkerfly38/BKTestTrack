component extends="cfselenium.CFSeleniumTestCase"
{
	remote any function RunTest(required string sUrl, required string browser, required numeric testid, required numeric testerid) {
		selenium = new cfselenium.selenium();
		selenium.start(arguments.sUrl,arguments.browser);
		
		//load our test case steps
		arrTestSteps = EntityLoad("TASSteps",{TestID=arguments.testid});
		mds = GetMetaData(selenium);
		SESSION.MDS = mds;
		listOfNames = "";
		for (func in mds.FUNCTIONS) {
			if (func.ACCESS == "public" && StructKeyExists(func,"HINT") && Len(func.HINT) > 0) {
				listOfNames = listAppend(listofNames,func.NAME);
			}
		}
		AlphaListOfNames = ListSort(listofNames,"text","asc");
		
		var testresult = EntityNew("TTestResult");
		
		try {
			for (step in arrTestSteps) {
				paramLength = 0;
				if ( step.getAction() CONTAINS "assert" )
				{
					evaluate("#step.getAction()#(#step.getValueOne()#,#step.getValueTwo()#)");
				} else {
					for ( i=1; i <= ListLen(AlphaListOfNames); i++) {
						for ( func in mds.FUNCTIONS) {
							if ( func.NAME == step.getAction() )
							{
								paramLength = ArrayLen(func.PARAMETERS);
							}		
						}
					}
					switch(paramLength) {
						case 0:
							evaluate("selenium.#step.getAction()#()");
							break;
						case 1:
							evaluate("selenium.#step.getAction()#('#step.getValueOne()#')");
							break;
						case 2:
							evaluate("selenium.#step.getAction()#('#step.getValueOne()#','#step.getValueTwo()#')");
							break;
					}
				}
				
				
			} 
		} 
		catch (any e)
		{
			StatusObj = EntityLoadByPk("TTestStatus",3);
			testresult.setTTestStatus(StatusObj);
			TesterObj = EntityLoadByPk("TTestTester",arguments.testerid);
			testresult.setTTestTester(TesterObj);
			testresult.setVersion("1");
			testresult.setElapsedTime("1");
			testresult.setComment(e.Message);
			testresult.setAttachmentList("");
			testresult.setDefects("");
			testresult.setDateTested(Now());
			testresult.setTestCaseID(arguments.testid);
			EntitySave(testresult);
			rethrow;
		}
		finally {
			selenium.stop();
		}
		StatusObj = EntityLoadByPk("TTestStatus",2);
		testresult.setTTestStatus(StatusObj);
		TesterObj = EntityLoadByPk("TTestTester",arguments.testerid);
		testresult.setTTestTester(TesterObj);
		testresult.setVersion("1");
		testresult.setElapsedTime("1");
		testresult.setComment("Passed");
		testresult.setAttachmentList("");
		testresult.setDefects("");
		testresult.setDateTested(Now());
		testresult.setTestCaseID(arguments.testid);
		EntitySave(testresult);
	}
	
	remote any function getSpecificMeta(required string funcName) returnformat="JSON" output="false" {
		structMetaData = StructNew();
		if ( StructKeyExists(SESSION,"MDS") ) {
			for ( func in SESSION.MDS.FUNCTIONS) {
				if ( func.NAME == arguments.funcName ) {
					if ( len(func.HINT) > 0 ) { 
						structMetaData.Hint = func.HINT;
					} else {
						structMetaData.Hint = "";
					}
					structMetaData.params = func.PARAMETERS;
				}
			}
			return serializeJSON(structMetaData);
		} else {
			return serializeJSON(structMetaData);
		}
	}
	
	remote string function GetListObj() output="true" {
		selenium = new cfselenium.selenium();
		mds = GetMetaData(selenium);
		SESSION.MDS = mds;
		listOfNames = "";
		writeOutput("<script type='text/javascript'>");
		writeOutput("$(document).ready(function() { ");
		writeOutput("	$('##ddlTAction').on('click', function() {");
   		writeOutput("		var funcname = $(this).val();");
   		writeOutput("		$.getJSON('cfc/AutomationStudio.cfc?method=getSpecificMeta&funcName='+funcname,function(data) {");
   		writeOutput("			$('##pnlDesc .panel-heading').text(funcname);");
   		writeOutput("			$('##pnlDesc .panel-body').html(data.HINT);");
   		writeOutput("			if ( data.PARAMS.length == 1 ) {");
   		writeOutput("				$('##txtValueOne').removeAttr('disabled');");
   		writeOutput("				$('##txtValueOne').attr('placeholder','NAME: '+data.PARAMS[0].NAME+', TYPE: '+data.PARAMS[0].TYPE+', REQUIRED: '+data.PARAMS[0].REQUIRED);");
   		writeOutput("				$('##txtValueTwo').attr('disabled','disabled');");
   		writeOutput("				$('##txtValueTwo').removeAttr('placeholder');");
   		writeOutput("				$('##txtValueThree').attr('disabled','disabled');");
   		writeOutput("				$('##txtValueThree').removeAttr('placeholder');");
   		writeOutput("				$('##txtValueFour').attr('disabled','disabled');");
   		writeOutput("				$('##txtValueFour').removeAttr('placeholder');");
   		writeOutput("			}");
   		writeOutput("			if ( data.PARAMS.length == 2 ) {");
   		writeOutput("				$('##txtValueOne').removeAttr('disabled');");
   		writeOutput("				$('##txtValueTwo').removeAttr('disabled');");
   		writeOutput("				$('##txtValueOne').attr('placeholder','NAME: '+data.PARAMS[0].NAME+', TYPE: '+data.PARAMS[0].TYPE+', REQUIRED: '+data.PARAMS[0].REQUIRED);");
   		writeOutput("				$('##txtValueTwo').attr('placeholder','NAME: '+data.PARAMS[1].NAME+', TYPE: '+data.PARAMS[1].TYPE+', REQUIRED: '+data.PARAMS[1].REQUIRED);");
   		writeOutput("				$('##txtValueThree').attr('disabled','disabled');");
   		writeOutput("				$('##txtValueThree').removeAttr('placeholder');");
   		writeOutput("				$('##txtValueFour').attr('disabled','disabled');");
   		writeOutput("				$('##txtValueFour').removeAttr('placeholder');");
   		writeOutput("			}");
   		writeOutput("			if ( data.PARAMS.length == 3 ) {");
   		writeOutput("				$('##txtValueOne').removeAttr('disabled');");
   		writeOutput("				$('##txtValueTwo').removeAttr('disabled');");
   		writeOutput("				$('##txtValueThree').removeAttr('disabled');");
   		writeOutput("				$('##txtValueOne').attr('placeholder','NAME: '+data.PARAMS[0].NAME+', TYPE: '+data.PARAMS[0].TYPE+', REQUIRED: '+data.PARAMS[0].REQUIRED);");
   		writeOutput("				$('##txtValueTwo').attr('placeholder','NAME: '+data.PARAMS[1].NAME+', TYPE: '+data.PARAMS[1].TYPE+', REQUIRED: '+data.PARAMS[1].REQUIRED);");
   		writeOutput("				$('##txtValueThree').attr('placeholder','NAME: '+data.PARAMS[2].NAME+', TYPE: '+data.PARAMS[2].TYPE+', REQUIRED: '+data.PARAMS[2].REQUIRED);");
   		writeOutput("				$('##txtValueFour').attr('disabled','disabled');");
   		writeOutput("				$('##txtValueFour').removeAttr('placeholder');");
   		writeOutput("			}");
   		writeOutput("			if ( data.PARAMS.length >= 4 ) {");
   		writeOutput("				$('##txtValueOne').removeAttr('disabled');");
   		writeOutput("				$('##txtValueTwo').removeAttr('disabled');");
   		writeOutput("				$('##txtValueThree').removeAttr('disabled');");
   		writeOutput("				$('##txtValueFour').removeAttr('disabled');");
   		writeOutput("				$('##txtValueOne').attr('placeholder','NAME: '+data.PARAMS[0].NAME+', TYPE: '+data.PARAMS[0].TYPE+', REQUIRED: '+data.PARAMS[0].REQUIRED);");
   		writeOutput("				$('##txtValueTwo').attr('placeholder','NAME: '+data.PARAMS[1].NAME+', TYPE: '+data.PARAMS[1].TYPE+', REQUIRED: '+data.PARAMS[1].REQUIRED);");
   		writeOutput("				$('##txtValueThree').attr('placeholder','NAME: '+data.PARAMS[2].NAME+', TYPE: '+data.PARAMS[2].TYPE+', REQUIRED: '+data.PARAMS[2].REQUIRED);");
   		writeOutput("				$('##txtValueFour').attr('placeholder','NAME: '+data.PARAMS[3].NAME+', TYPE: '+data.PARAMS[3].TYPE+', REQUIRED: '+data.PARAMS[3].REQUIRED);");
   		writeOutput("			}");
   		writeOutput("			if ( data.PARAMS.length == 0 ) {");
   		writeOutput("				$('##txtValueOne').attr('disabled','disabled');");
   		writeOutput("				$('##txtValueTwo').attr('disabled','disabled');");
   		writeOutput("				$('##txtValueThree').attr('disabled','disabled');");
   		writeOutput("				$('##txtValueFour').attr('disabled','disabled');");
   		writeOutput("				$('##txtValueOne').removeAttr('placeholder');");
   		writeOutput("				$('##txtValueTwo').removeAttr('placeholder');");
   		writeOutput("				$('##txtValueThree').removeAttr('placeholder');");
   		writeOutput("				$('##txtValueFour').removeAttr('placeholder');");
   		writeOutput("			}");
   		writeOutput("		});");
        writeOutput("	});");
        writeOutput('});');
		writeOutput("</script>");
		writeOutput("<p>Build an automated test case by selecting actions and setting their parameters below.  For <em>locator</em> parameters, remember you can use css classes (css=reference), ids (id=reference), names (name=), and complex XPath logic to get at the web piece you want.  See the wiki for more thorough documentation.</p>");
		writeOutput("<div class='col-xs-4 col-sm-4 col-md-4 col-lg-4'>");
		
		writeOutput("<select id='ddlTAction' class='form-control' size='8' style='height:150px;'>");
		for (func in mds.FUNCTIONS) {
			if (func.ACCESS == "public" && StructKeyExists(func,"HINT") && Len(func.HINT) > 0) {
				listOfNames = listAppend(listofNames,func.NAME);
			}
		}
		AlphaListOfNames = ListSort(listofNames,"text","asc");
		for ( i=1; i <= ListLen(AlphaListOfNames); i++) {
			for ( func in mds.FUNCTIONS) {
				if (func.NAME == ListGetAt(AlphaListOfNames,i) ) {
					writeOutput("<option data-toggle='popover' data-placement='bottom' data-trigger='hover' data-content='");
					if (ArrayLen(func.PARAMETERS) > 0) {
						writeOutput("Parameters: ");
						for (param in func.PARAMETERS ) {
							writeOutput("  " & param.NAME & ", required=" & param.REQUIRED & ", type=" & param.TYPE & ";");
						}
					}
					writeOutput("'>"&func.NAME&"</option>");
				}
			}
		}
		
		writeOutput("</select><br /><div id='pnlDesc' class='panel panel-primary'><div class='panel-heading'>Selenium and MXUnit Test Options</div><div class='panel-body' style='height:200px;overflow:auto;'>Select an action to the left for a description and parameter requirements.</div></div></div>");
		writeOutput("<div class='col-xs-8 col-sm-8 col-md-8 col-lg-8'><label for='txtValueOne'>First Parameter Value</label><br /><input type='text' id='txtValueOne' class='form-control' disabled /><label for='txtValueTwo'>Second Parameter Value</label><br /><input type='text' id='txtValueTwo' class='form-control' disabled  /><label for='txtValueThree'>Third Parameter Value</label><br /><input type='text' id='txtValueThree' class='form-control' disabled /><label for='txtValueFour'>Fourth Parameter Value</label><br /><input type='text' id='txtValueFour' class='form-control' disabled /></div>");
	}
}