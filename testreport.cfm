<!---<cfhttp url="https://cornerops.axosoft.com/api/oauth2/token?grant_type=password&username=bkresge&password=nugget38&client_id=84a344d7-9034-4ed7-8a01-ba35f9642648&client_secret=yUNiYAek30KibBtietQVo9UktJz8gv8GLdniTvzyv7rzWW4n2Xq0cSmedoJKMB_PUX5aWUyb2y5LXimFX-1wIJeCQocZSF6HTE7Q&scope=read" method="get" result="tokenResult" />
<cfset accessToken = DeSerializeJSON(tokenResult.filecontent).access_token>

<!---<cfhttp url="https://cornerops.axosoft.com/api/v2/defects/?access_token=#accessToken#" method="get" result="bugResult" />

<cfdump var="#DeserializeJSON(bugResult.fileContent)#">--->
<cfscript>
	objAxoSoft = new CfTestTrack.cfc.AxoSoft();
	writeDump(objAxoSoft.getItems(3,accessToken));
</cfscript>--->

<!---<cfscript>
	objSlack = new CFTestTrack.cfc.Slack();
	writeDump(objSlack.slackPostMessage(text="TestTrack now integrated with SlackBot.", as_user=true));
</cfscript>--->
<cfscript>
	cfdbinfo(name="qrydbinfo",type="version");
	writeDump(qrydbinfo);
</cfscript>