<!--- first a little maintenance --->
<cfsetting requesttimeout="216000">
<!---<cfhttp url="https://cornerops.axosoft.com/api/oauth2/token?grant_type=password&username=bkresge&password=nugget38&client_id=84a344d7-9034-4ed7-8a01-ba35f9642648&client_secret=yUNiYAek30KibBtietQVo9UktJz8gv8GLdniTvzyv7rzWW4n2Xq0cSmedoJKMB_PUX5aWUyb2y5LXimFX-1wIJeCQocZSF6HTE7Q&scope=read" method="get" result="tokenResult" />
<cfset accessToken = DeSerializeJSON(tokenResult.filecontent).access_token>

<cfhttp url="https://cornerops.axosoft.com/api/v2/incidents/?access_token=#accessToken#" method="get" result="itemResult" />
<cfset objItemData = DeserializeJSON(itemResult.fileContent) />
<cfhttp url="https://cornerops.axosoft.com/api/v2/defects/?access_token=#accessToken#" method="get" result="defectResult" />
<cfset objDefectData = DeserializeJSON(defectResult.filecontent) />



<cfset qryItemData = queryNew("SRX,Number,  Name","varchar,varchar,varchar")>

<cfloop array="#objItemData['data']#" index="i">
	<cfif !isNull(i.custom_fields.custom_1169) AND i.custom_fields.custom_1169 neq "">
	<cfset temp = QueryAddRow(qryItemData)>
	<cfset temp = QuerySetCell(qryItemData,"SRX",i.custom_fields.custom_1169)>
	<cfset temp = QuerySetCell(qryItemData,"Number",i.number)>
	<cfset temp = QuerySetCell(qryItemData,"Name",i.name)>
	</cfif>
</cfloop>
<cfloop array="#objDefectData['data']#" index="i">
	<cfif !isNull(i.custom_fields.custom_1207) AND i.custom_fields.custom_1207 neq "">
	<cfset temp = QueryAddRow(qryItemData)>
	<cfset temp = QuerySetCell(qryItemData,"SRX",i.custom_fields.custom_1207)>
	<cfset temp = QuerySetCell(qryItemData,"Number",i.number)>
	<cfset temp = QuerySetCell(qryItemData,"Name",i.name)>
	</cfif>
</cfloop>
<cfquery name="allInvoiceData">
	SELECT id, Client, ModotechProjectNo
	FROM TModotechInvoicing
	WHERE COGProject IS NULL
</cfquery>

<cfloop query="allInvoiceData">
	<cfquery name="qrydt" maxrows="1" dbtype="query">
		SELECT SRX, Number, Name
		FROM qryItemData
		WHERE SRX = '#modotechprojectno#'
	</cfquery>
	<cfset COGClientVar = "">
	<cfswitch expression="#allInvoiceData.Client#">
		<cfcase value="Cornerstone">
			<cfset COGClientVar = "COG">
		</cfcase>
		<cfcase value="SBOA">
			<cfset COGClientVar = "SBOA">
		</cfcase>
		<cfcase value="Access Home">
			<cfset COGClientVar = "AHIC">
		</cfcase>
	</cfswitch>
	<cfquery>
		UPDATE 	TModotechInvoicing
		SET		COGProjectDesc = '#qrydt.Name[1]#',
				COGClient = '#COGClientVar#',
				COGProject = '#qrydt.Number[1]#'
		WHERE	ID = #allInvoiceData.id#
	</cfquery>
</cfloop>--->
<cfquery name="qryOutput">
	SELECT * FROM TModotechInvoicing
</cfquery>
<table border="1">
	<tr>
		<th>Developer</th>
		<th>Type</th>
		<th>Client</th>
		<th>Date</th>
		<th>Description</th>
		<th>Hours</th>
		<th>Modotech Project #</th>
		<th>Cog Project Description</th>
		<th>COG Client</th>
		<th>COG Project</th>
		<th>Exended Price</th>
	</tr>
	<cfoutput query="qryOutput">
	<tr>
		<td>#Developer#</td>
		<td>#Type#</td>
		<td>#Client#</td>
		<td>#ItemDate#</td>
		<td>#Description#</td>
		<td>#Hours#</td>
		<td>#ModotechProjectNo#</td>
		<td>#COGProjectDesc#</td>
		<Td>#COGClient#</td>
		<td>#COGProject#</td>
		<td>#hours * 135#</td>
	</tr>
	</cfoutput>
</table>
