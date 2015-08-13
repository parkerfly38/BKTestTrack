<cfcomponent name="GanttChartRow" displayname="Gantt Chart Row">

	<cffunction name="constructor" output="false" returntype="struct">
		<cfargument name="label" type="String" required="false" default="Row label" />
		<cfargument name="style" type="String" required="false" default="solid" hint="Accepts the values [solid | striped]" />
		
		<cfscript>
		variables.label 	= arguments.label;
		variables.style		= arguments.style;
		variables.ranges 	= ArrayNew(1);
		this.instanceID = "GanttChartRow_" & DateFormat(now(),'mmddyy') & "_" & TimeFormat(now(),'hhmmssll');
		return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="addRange" output="false" returntype="void">
		<cfargument name="startDate" displayName="Start date" type="Date" required="false" default="#now()#" />
		<cfargument name="endDate" displayName="End date" type="Date" required="true" default="#now()#" />
		<cfargument name="barColor" type="String" required="false" default="black" />
		
		<cfscript>
		variables.ranges[ArrayLen(variables.ranges) + 1] 			= structNew();
		variables.ranges[ArrayLen(variables.ranges)].startDate 	= arguments.startDate;
		variables.ranges[ArrayLen(variables.ranges)].endDate 	= arguments.endDate;
		variables.ranges[ArrayLen(variables.ranges)].barColor 	= arguments.barColor;
		</cfscript>
	</cffunction>
	
	<cffunction name="getRange" output="false" returntype="struct">
		<cfargument name="rangeNumber" type="numeric" required="true">
		
		<cfreturn variables.ranges[arguments.rangeNumber] />
	</cffunction>
	
	<cffunction name="getRangeCount" output="false" returntype="numeric">
		<cfreturn ArrayLen(variables.ranges) />
	</cffunction>
	
	<cffunction name="getLabel" output="false" returntype="string">
		<cfreturn variables.label />
	</cffunction>
	
	<cffunction name="getStyle" output="false" returntype="string">
		<cfreturn variables.style />
	</cffunction>

</cfcomponent>