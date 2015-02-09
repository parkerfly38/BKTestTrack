component extends="cfselenium.CFSeleniumTestCase"
{
	remote any function RunTest(required string sUrl, required string browser, required numeric testid) {
		selenium = new cfselenium.selenium();
		selenium.start(arguments.sUrl,arguments.browser);
		
		//load our test case steps
		arrTestSteps = EntityLoadByPK("TASSteps",arguments.testid);
		mds = GetMetaData(selenium);
		for (step in arrTestSteps) {
			paramLength = 0;
			if ( step.getAction() CONTAINS "assert" )
			{
				
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
						evaluate("selenium.#step.getAction()#(#step.getValueOne()#)");
						break;
					case 2:
						evaluate("selenium.#step.getAction()#(#step.getValueOne()#,#step.getValueTwo()#)");
						break;
				}
			}
			
			
		}
	}
	remote string function GetListObj() output="true" {
		selenium = new cfselenium.selenium();
		mds = GetMetaData(selenium);
		//writeOutput(arrayLen(mds.FUNCTIONS));
		writeDump(MDS);
		listOfNames = "";
		writeOutput("<div class='list-group'>");
		for (func in mds.FUNCTIONS) {
			if (func.ACCESS == "public" && StructKeyExists(func,"HINT") && Len(func.HINT) > 0) {
				listOfNames = listAppend(listofNames,func.NAME);
			}
		}
		AlphaListOfNames = ListSort(listofNames,"text","asc");
		writeOutput(AlphaListOfNames);
		
		for ( i=1; i <= ListLen(AlphaListOfNames); i++) {
			for ( func in mds.FUNCTIONS) {
				if (func.NAME == ListGetAt(AlphaListOfNames,i) ) {
					writeOutput("<a href='##' class='list-group-item'>");
					writeOutput("<h4 class='list-group-item-heading'>" & func.NAME & "</h4>");
					writeOutput("<p class='list-group-item-text'>" & htmlEditFormat(LEFT(func.HINT,255)) & "...</p>");
					writeOutput("</a>");
				}
			}
		}
		
		writeOutput("</div>");
	}
}