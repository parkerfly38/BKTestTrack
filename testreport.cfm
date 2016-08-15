<!---
<cfscript>
	objCodeCoverage = createObject("component", "cfc.CodeCoverage");
	
	writeDump(objCodeCoverage.GetCoverage("/CFTestTrack/cfc","/CFTestTrack/tests"));
</cfscript>
--->
<!---private key 8FFFCA8F-CD07-BCB5-7370BFE1E53AC006 --->
<!---public key  8fffca8d-d514-763f-35b01e936ce099cf --->

<cfscript>
	//objData = createObject("component","cfc.Data");
	//writeDump(objData.generatePublicPrivateKeys(7));
	objAuthentication = new CFTestTrack.api.authentication();
	datenow = now();
	writeOutput(datenow & "<br />");
    writeOutput(objAuthentication.EncryptSignature(datenow & "8fffca8d-d514-763f-35b01e936ce099cf","8fffca8d-d514-763f-35b01e936ce099cf"));
</cfscript>