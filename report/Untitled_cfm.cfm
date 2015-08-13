<cfhttp url="https://cornerops.axosoft.com/api/oauth2/token?grant_type=password&username=bkresge&password=nugget38&client_id=84a344d7-9034-4ed7-8a01-ba35f9642648&client_secret=yUNiYAek30KibBtietQVo9UktJz8gv8GLdniTvzyv7rzWW4n2Xq0cSmedoJKMB_PUX5aWUyb2y5LXimFX-1wIJeCQocZSF6HTE7Q&scope=read" method="get" result="tokenResult" />
<cfset accessToken = DeSerializeJSON(tokenResult.filecontent).access_token>
<cfhttp url="https://cornerops.axosoft.com/api/v2/incidents/?access_token=#accessToken#" method="get" result="httpResult" />
<!---<cfhttp url="https://cornerops.axosoft.com/api/v2/defects/?access_token=#accessToken#" method="get" result="bugResult" />--->
<cfset qryClientAcceptance = QueryNew("ID,Title,ReportedDate,CustomerContact,CustomerContactEmail,Client,Status,WorkflowStep,OriginalEstimate,HoursToDate,HoursLeft,DueDate","varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,decimal,decimal,decimal,varchar") >
<cfset objData = DeserializeJSON(httpResult.fileContent) />
<cfdump var="#objData#">