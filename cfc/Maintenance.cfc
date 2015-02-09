<cfcomponent>
	
	<cffunction access="remote" name="returnTasks" returntype="query">
    	<cfswitch expression="#getVersion()#">
	    	<cfcase value="8,9">
		    	<cfset local = structnew()>
		    	<cfset objCF9 = createObject("component","cf9below")>
		    	<cfset qryScheduledTasks = objCF9.getScheduleQuery()>
		    </cfcase>
		    <cfcase value="10,11">
		   		<cfset objCF10 = createObject("component","cf10plus")>
		   		<cfset qryScheduledTasks = objCF10.getScheduleQuery()>
		    </cfcase>
		</cfswitch>
	    <cfquery dbtype="query" name="qrytasks">
	    	SELECT * FROM qryScheduledTasks
	    	WHERE task like 'TestTrack%'
	    </cfquery>
	    <cfreturn qrytasks />
	</cffunction>
	
	<cffunction access="remote" name="getVersion" returntype="string">
		<cfreturn ListGetAt(SERVER.ColdFusion.ProductVersion,1) />
	</cffunction>
	
	<cffunction access="remote" name="createTask" returntype="query">
		<cfargument name="reportid" required="true">
		<cfargument name="interval" required="true">
		<cfargument name="startDate" required="true">
		<cfargument name="startTime" required="true">
		
		<cfschedule action="update" task="TestTrack#arguments.reportid#" operation="HTTPRequest" url="reporthandler.cfm?id=#arguments.reportid#" startDate="#arguments.startDate#" startTime="#arguments.startTime#" interval="#arguments.interval#" resolveURL="no" publish="false" path="#GetDirectoryFromPath(ExpandPath("*.*"))#" requesttimeout="3500" />
					
		<cfreturn returnTasks() />
	</cffunction>

	<cffunction access="remote" name="deleteTask" returntype="void">
		<cfargument name="testid" type="numeric" required="true">
		<cfschedule action="delete" task="TestTrack#arguments.testid#">
	</cffunction>

	<cffunction name="createSpreadsheetTestCaseTemplate" returntype="void" output="true" access="remote">
		<cfscript>
			objSpreadsheet = SpreadsheetNew("TestCases");
			SpreadSheetAddRow(objSpreadsheet,"TestTitle,TestDetails,Priority,Type,Project,Preconditions,Steps,ExpectedResult,Estimate");
			
			workbook = objSpreadSheet.getWorkBook();
			sheet = workbook.getSheet("TestCases");
			
			dvConstraint = createObject("java","org.apache.poi.hssf.usermodel.DVConstraint");
			cellRangeList = createObject("java","org.apache.poi.ss.util.CellRangeAddressList");
			dataValidation = createObject("java","org.apache.poi.hssf.usermodel.HSSFDataValidation");
			dataValidationA = createObject("java","org.apache.poi.hssf.usermodel.HSSFDataValidation");
			dataValidationB = createObject("java","org.apache.poi.hssf.usermodel.HSSFDataValidation");
			//get repeatable for dresslist
			arrTestPriorities = EntityLoad("TTestPriorityType");
			arrayPriorities = [];
			for (priority in arrTestPriorities)
			{
				ArrayAppend(arrayPriorities,priority.getPriorityName());
			}
			addressList = cellRangeList.init(1,100,2,2);
			dvConstraint = dvConstraint.createExplicitListConstraint(arrayPriorities);
			dataValidation = dataValidation.init(addressList,dvConstraint);
			dataValidation.setSuppressDropDownArrow(false);
			sheet.addValidationData(dataValidation);
			
			//get repeatable for type	
			arrTestTypes = EntityLoad("TTestType");
			arrayTypes = [];
			for (ttype in arrTestTypes) {
				ArrayAppend(arrayTypes,ttype.getType());
			}
			addressList = cellRangeList.init(1,100,3,3);
			dvConstraint = dvConstraint.createExplicitListConstraint(arrayTypes);
			dataValidationA = dataValidationA.init(addressList,dvConstraint);
			dataValidationA.setSuppressDropDownArrow(false);
			sheet.addValidationData(dataValidationA);
			
			//get repeatable for project
			arrProjects = EntityLoad("TTestProject");
			arrayProjects = [];
			for (project in arrProjects) {
				ArrayAppend(arrayProjects,project.getProjectTitle());
			}
			
			addressList = cellRangeList.init(1,100,4,4);
			dvConstraint = dvConstraint.createExplicitListConstraint(arrayProjects);
			dataValidationB = dataValidationB.init(addressList,dvConstraint);
			dataValidationB.setSuppressDropDownArrow(false);
			sheet.AddValidationData(dataValidationB);
			
			SpreadSheetWrite(objSpreadsheet,ExpandPath("/excel/")&"fordownload.xls","yes");
			
		</cfscript>
	</cffunction>

	<cffunction name="createSpreadsheetTestResultTemplate" returntype="void" access="remote">
		<cfscript>
			
		</cfscript>
	</cffunction>
	
	<cffunction name="createUUID" access="remote" returntype="string">
		<cfreturn createUUID()>
	</cffunction>
	
	<cffunction name="TestCaseFileUpload" access="remote" output="true">
		<script type="text/javascript">
			$(document).ready(function() {
				$(document).off("click","##btnSave");
				$(document).on("click","##btnSave",function(event) {
					var data = new window.FormData($('##uploadFile')[0]);
					$.ajax({
				        type: "POST",
				        data: data,
				        cache: false,
				        contentType: false,
				        processData: false,
				        <cfif SERVER.OS.Name eq "Mac OS X">
				        url: "upload.php",
				        <cfelse>
				        url: "cfc/Maintenance.cfc?method=saveTestCaseExcelFile",
				        </cfif>
				        success: function (datap) {
				        	$("##smallModal").modal("hide");
				        	$("##topcontent").load("cfc/Dashboard.cfc?method=AllTests");
				        	<cfif SERVER.OS.Name eq "Mac OS X">
				        	$.ajax({ url: "cfc/Maintenance.cfc?method=fileProcess",
				        			 type: "POST",
				        			 data: { filename : data }
				       		});
				       		</cfif>
				         },
				        error: function () { alert("Because, screw you, apparently"); }
				   });
	    		});
    		});
    	</script>
		<form enctype="multipart/form-data" id="uploadFile" method="post" action="http://localhost/COGTestTrack/uploadHandler.cfm">
			
 			<input type="file" name="fileUpload" id="fileUpload" />
    		
		</form>			
	</cffunction>
	
	<cffunction name="getServerVersion" access="remote" returnformat="plain" returntype="string">
		<cfreturn SERVER.OS.name>
	</cffunction>
	
	<cffunction name="saveTestCaseExcelFile" access="remote" output="true">
		
		<cffile action="upload" fileField="form.fileUpload" destination="#expandPath('/excel/')#"  nameConflict="overwrite" />
		<cfscript>
			fileProcess(cffile.serverFile);
		</cfscript>
	</cffunction>
	
	<cffunction name="fileProcess" access="remote" returntype="void">
		<cfargument name="filename" type="string" required="true">
		<cfspreadsheet action="read" src="#ExpandPath('/excel/')##arguments.filename#" query="newtcs">
		<cfloop query="newtcs" startrow="2">
			<cfscript>
				importTCfromSheet(col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9);
			</cfscript>
		</cfloop>
	</cffunction>
	
	<cffunction name="importTCfromSheet" access="private" returntype="void">
		<cfargument name="testtitle">
		<cfargument name="testdetails">
		<cfargument name="priority">
		<cfargument name="type">
		<cfargument name="project">
		<cfargument name="preconditions">
		<cfargument name="steps">
		<cfargument name="expectedresult">
		<cfargument name="estimate">
		<cfset PriorityId = EntityLoad("TTestPriorityType",{PriorityName = arguments.priority})[1].getId()>
		<cfset TypeId = EntityLoad("TTestType",{Type = arguments.type})[1].getID()>
		<cfset ProjectID = EntityLoad("TTestProject",{ProjectTitle = arguments.project})[1].getId()>
		<cfscript>
			testcase = EntityNew("TTestCase");
			testcase.setTestTitle(arguments.testtitle);
			testcase.setPriorityId(PriorityId);
			testcase.setTypeId(TypeId);
			testcase.setProjectId(ProjectID);
			testcase.setPreconditions(arguments.preconditions);
			testcase.setSteps(arguments.steps);
			testcase.setExpectedResult(arguments.expectedresult);
			testcase.setEstimatE(arguments.estimate);
			testcase.setMilestoneId(0);
			EntitySave(testcase);
		</cfscript>
	</cffunction>
</cfcomponent>