<!---<cfdump var="#form#">--->
<cffile action="upload" filefield="FILEADDVAL" destination="#expandPath('tests')#" nameconflict="MakeUnique">
<!---<cfdump var="#cffile#">--->
<cfscript>
	newTestScript = EntityNew("TTestScript");
	newTestScript.setScriptName(form.NEWSCRIPTNAME);
	newTestScript.setScriptDescription(form.NEWSCRIPTDESCRIPTION);
	newTestScript.setTypeID(form.NEWTYPEID);
	newTestScript.setScriptFile(cffile.serverfile);
	EntitySave(newTestScript);
//	writeDump(newTestScript);
</cfscript>
<!---	<cffile action="upload" fileField="fileUpload" destination="#expandPath('/excel/')#" mode="777"   nameConflict="overwrite" />--->