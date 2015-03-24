<!---<cfset application.userchatcount.1 = 1>
<cfdump var="#application#">--->

<cfset objAxoSoft = new CFTestTrack.cfc.AxoSoft()>
<cfdump var="#objAxoSoft.getDefect("a51c400e-30eb-4dd7-8c7e-998efb16aa66",249)#">
<cfoutput>#objAxoSoft.addDefect("a51c400e-30eb-4dd7-8c7e-998efb16aa66","testdisregard","testdisregard","testdisregard","testdisregard",1103,8)#</cfoutput>
