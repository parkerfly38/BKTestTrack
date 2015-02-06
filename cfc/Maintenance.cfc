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
				        xhr: function () {  
				            return $.ajaxSettings.xhr();
	        		},
			        type: "POST",
			        data: data,
			        cache: false,
			        contentType: false,
			        processData: false,
			        url: "cfc/Maintenance.cfc?method=saveTestCaseExcelFile",
			        success: function () { },
			        error: function () { },
	    		});
    		});
    	</script>
		<form enctype="multipart/form-data" id="uploadFile">
			
 			<input type="file" name="fileUpload"/>
    		
		</form>			
	</cffunction>
	
	<cffunction name="saveTestCaseExcelFile" access="remote" output="true">
		<cffile action="upload" fileField="fileUpload" destination="#expandPath('/excel/')#"  nameConflict="overwrite" />
	</cffunction>
	
	<cffunction name="importTCfromSheet" access="remote" output="true">
		<cfargument name="filename" required="true">
		
	</cffunction>
</cfcomponent>