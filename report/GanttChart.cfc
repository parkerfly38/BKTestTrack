<cfcomponent name="GanttChart" displayname="Gantt Chart">

	<cfproperty name="width" type="numeric" default="0" />
	<cfproperty name="startDate" type="date" />
	<cfproperty name="endDate" type="date" />
	<cfproperty name="rows" type="numeric" default="0" />
	<cfproperty name="scale" hint="Daily/Weekly/Monthly" type="string" />
	<cfproperty name="title" type="string" />
	<cfproperty name="rowLabel" type="string" />
	<cfproperty name="scrollToDate" type="date" />

	
	<cffunction name="constructor" output="false" returntype="struct">
		<cfargument name="title" type="string" required="false" default="Gantt Chart">
		<cfargument name="width" type="string" required="false" default="500">
		<cfargument name="startDate" type="string" required="false" default="#now()#">
		<cfargument name="endDate" type="string" required="false" default="#dateAdd('m',1,now())#">
		<cfargument name="scrollToDate" type="string" required="false" default="#now()#">
		
		<cfscript>
		variables.width			= arguments.width;
		variables.startDate		= datePart('m', arguments.startDate) & "/01/" & datePart('yyyy',arguments.startDate);
		variables.endDate		= arguments.endDate;
		variables.title			= arguments.title;
		variables.rows			= ArrayNew(1);
		variables.scale			= 1;
		variables.scrollToDate 	= arguments.scrollToDate;
		
		this.instanceID = "GanttChart_" & DateFormat(now(),'mmddyy') & "_" & TimeFormat(now(),'hhmmssll');
		return this;
		</cfscript>
	</cffunction>


	<cffunction name="getWidth" access="public" output="false" returntype="numeric" hint="Retrieves the width of the Gantt chart">
		<cfreturn width />
	</cffunction>


	<cffunction name="setWidth" access="public" output="false" returntype="void" hint="Sets the width of the Gantt chart">
		<cfargument name="width" type="numeric" required="true" />
		<cfset variables.width = arguments.width />
		<cfreturn />
	</cffunction>
	
	
	<cffunction name="setScrollToDate" access="public" output="false" returntype="void" hint="Sets the date on which to scroll to in the Gantt chart">
		<cfargument name="scrollToDate" type="date" required="true" />
		<cfset variables.scrollToDate = arguments.scrollToDate />
		<cfreturn />
	</cffunction>


	<cffunction name="getStartDate" access="public" output="false" returntype="date" hint="Gets the start date for the Gantt chart">
		<cfreturn variables.startDate />
	</cffunction>


	<cffunction name="setStartDate" access="public" output="false" returntype="void" hint="Sets the start date for the Gantt chart">
		<cfargument name="startDate" type="date" required="true" />
		<cfset variables.startDate = datePart('m', arguments.startDate) & "/01/" & datePart('yyyy',arguments.startDate) />
		<cfreturn />
	</cffunction>


	<cffunction name="getEndDate" access="public" output="false" returntype="date" hint="Gets the end date for the Gantt chart">
		<cfreturn variables.endDate />
	</cffunction>


	<cffunction name="setEndDate" access="public" output="false" returntype="void" hint="Sets the end date for the Gantt chart">
		<cfargument name="endDate" type="date" required="true" />
		<cfset variables.endDate = arguments.endDate />
		<cfreturn />
	</cffunction>


	<cffunction name="getRows" access="public" output="false" returntype="numeric" hint="Gets the number of rows currently in the Gantt chart">
		<cfreturn ArrayLen(variables.rows) />
	</cffunction>


	<cffunction name="getScale" access="public" output="false" returntype="string" hint="Gets the scale (monthly or weekly) at which the dates are drawn">
		<cfscript>
		switch (variables.scale)
		{
			case "1": { return "daily"; break; }
			case "7": { return "monthly"; break; }
			case "30": { return "yearly"; break; }
		}
		</cfscript>
	</cffunction>


	<cffunction name="setScale" access="public" output="false" returntype="void" hint="Sets the scale (monthly or weekly) at which the dates are drawn">
		<cfargument name="scale" type="string" required="true" />
		
		<cfscript>
		switch (arguments.scale)
		{
			case "daily": { variables.scale = 1; break; }
			case "monthly": { variables.scale = 7; break; }
			case "yearly": { variables.scale = 30; break; }
		}
		</cfscript>

		<cfreturn />
	</cffunction>


	<cffunction name="getTitle" access="public" output="false" returntype="string" hint="Gets the title of the Gantt chart">
		<cfreturn variables.title />
	</cffunction>


	<cffunction name="setTitle" access="public" output="false" returntype="void" hint="Sets the title of the Gantt chart">
		<cfargument name="title" type="string" required="true" />
		<cfset variables.title = arguments.title />
		<cfreturn />
	</cffunction>


	<cffunction name="setRowLabel" access="public" output="false" returntype="void" hint="Sets the row label for the Gantt chart">
		<cfargument name="rowLabel" type="string" required="true" />
		<cfset variables.rowLabel = arguments.rowLabel />
		<cfreturn />
	</cffunction>


	<cffunction name="addRow" access="public" output="false" returntype="void" hint="Adds a row of dates to the Gantt chart">
		<cfargument name="ganttChartRow" type="Struct" required="true" />
		<cfset variables.rows[ArrayLen(variables.rows) + 1] = ganttChartRow>
		<cfreturn />
	</cffunction>


	<cffunction name="getHeight" output="false" returntype="numeric" access="public">
		<cfscript>
		var isIE = find('MSIE',cgi.HTTP_USER_AGENT) gt 0;
		if (isIE) scrollBarBuffer = 18; else scrollBarBuffer = 29;
		return 120 + ( 30 * (arraylen(variables.rows) + 1) ) + scrollBarBuffer;
		</cfscript>
	</cffunction>
	
	
	<cffunction name="isWithinRange" output="false" returntype="boolean" access="private">
		<cfargument name="startDate" type="date" required="true">
		<cfargument name="endDate" type="date" required="true">
		<cfargument name="checkDate" type="date" required="true">
		
		<cfscript>
		startDay = dayOfYear(argument.startDate);
		endDay = dayOfYear(argument.endDate);
		checkDay = dayOfYear(argument.checkDate);
		
		startMonth = datePart('m',argument.startDate);
		endMonth = datePart('m',argument.endDate);
		checkMonth = datePart('m',argument.checkDate);

		startYear = datePart('yyyy',argument.startDate);
		endYear = datePart('yyyy',argument.endDate);
		checkYear = datePart('yyyy',argument.checkDate);
		
		if ( checkYear gte startYear and checkYear lte endYear )
			if ( checkMonth gte startMonth and checkMonth lte endMonth )
				if ( checkDay gte startDay and checkDay lte endDay )
					return true;
					
		return false;
		</cfscript>
	</cffunction>
	
	
	<cffunction name="totalChartDays" output="false" returntype="numeric" access="private">
		<cfreturn DateDiff('d', variables.startDate, variables.endDate)>		
	</cffunction>
	
	
	<cffunction name="dayOrdinal" output="false" returntype="numeric" access="private" hint="Returns the number of days between the chart's starting date and the check date">
		<cfargument name="checkDate" type="date" required="true">
		
		<cfreturn DateDiff('d',variables.startDate,arguments.checkDate) />
	</cffunction>
	
	
	<cffunction name="buildTopYearCells" output="false" returntype="struct" hint="Builds the cells for displaying the years in the date range for the Gantt chart">
		<cfscript>
		var years 			= structNew();
		var year 			= 0;
		years.HTML 			= '';
		years.totalCells 	= dateDiff('yyyy', variables.startDate, variables.endDate) + 1;
		
		while ( year lt years.totalCells )
		{
			years.HTML = years.HTML & "<td nowrap style='font:bold; text-align:center; border-bottom:1px solid D5E3E6; border-right:1px solid D5E3E6'>" & datepart('yyyy', variables.startDate) + year & "</td>";
			year = year + 1;
		}
		
		return years;
		</cfscript>
	</cffunction>
	
	
	<cffunction name="buildTopMonthCells" output="false" returntype="struct" access="private" hint="Builds the cells for displaying the months in the date range for the Gantt chart">
		<cfscript>
		var months 			= structNew();
		var startYear 		= datePart('yyyy',variables.startDate);
		var endYear 		= datePart('yyyy',variables.endDate);
		var yearSpanCount 	= endYear - startYear;
		var startMonth 		= 1;
		var endMonth 		= 12;
		months.HTML 		= '';
		months.totalCells 	= 0;
				
		if ( yearSpanCount gt 0 )
		{
			for ( y=1; y lte yearSpanCount + 1; y=y+1 )
			{
				// Determine the start month, end month and month count of each year
				startMonth = 1;
				endMonth = 12;
				if ( y eq 1 ) 
				{
					startMonth = month(variables.startDate);
					monthsToDraw = 13 - startMonth;
				}
				else if ( y eq yearSpanCount + 1 ) 
				{
					endMonth = month(variables.endDate);
					monthsToDraw = endMonth;
				} else
					monthsToDraw = 13 - startMonth;

				// Increment the total months in this chart
				months.totalCells = months.totalCells + monthsToDraw;
								
				// Create the month tables cells for this year
				for ( m=startMonth; m lte endMonth; m=m+1 )
				{
					switch(variables.scale)
					{
						case 1:
						{
							displayMonth = MonthAsString(m);
							displayYear = datePart('yyyy',variables.startDate) + (y - 1);
							break;
						}
						case 7:
						{
							displayMonth = Left(MonthAsString(m),3);
							displayYear = Right(datePart('yyyy',variables.startDate) + (y - 1), 2);
							break;
						}
					}
					months.HTML = months.HTML & ("<td style='font:bold; text-align:center; border-bottom:1px solid ##D5E3E6; border-right:1px solid ##D5E3E6'>" & displayMonth & " " & displayYear & "</td>");				
				}
			}
		} else {
			startMonth 			= month(variables.startDate);
			endMonth 			= month(variables.endDate);
			months.totalCells 	= endMonth - startMonth + 1;
			
			for ( i=startMonth; i lte endMonth; i=i+1 )
				months.HTML = months.HTML & ("<td nowrap style='font:bold; text-align:center; border-bottom:1px solid ##D5E3E6; border-right:1px solid ##D5E3E6'>" & MonthAsString(i) & "</td>");
		}
		return months;
		</cfscript>
	</cffunction>


	<cffunction name="drawBottomMonthCells" output="true" returntype="void" access="private">
		<cfargument name="totalYears" type="numeric" required="true">
		
		<cfscript>
		var i 			= 0;
		var endDay 		= 0;
		var startDay 	= 0;
		</cfscript>
		
		<script>
		<!--- Use Javascript to build the cells since using HTML creates a very large document --->
		function drawMonths()
		{
			var months = new Array(11);
			months[0]  = "J";
			months[1]  = "F";
			months[2]  = "M";
			months[3]  = "A";
			months[4]  = "M";
			months[5]  = "J";
			months[6]  = "J";
			months[7]  = "A";
			months[8]  = "S";
			months[9]  = "O";
			months[10] = "N";
			months[11] = "D";
			
			cell = '';
			cell += '<td style="border-bottom: 1px solid ##D5E3E6;"><table cellpadding="0" cellspacing="0" border="0" align="right"><tr>';			
			for (var month=0; month <= 11; month=month+1)
			{
				cell += '<td style="padding:0 2px 0 4px;">' + months[month] + '</td>';
			}
			cell += '</tr></table></td>';
			document.write(cell);
		}
		</script>
		
		<cfloop from="1" to="#arguments.totalYears#" index="i">  <!--- Loop through each year in the chart range --->
			<script>drawMonths()</script>					
		</cfloop>
	</cffunction>
	
	<cffunction name="drawBottomDayCells" output="true" returntype="void" access="private">
		<cfargument name="totalMonths" type="numeric" required="true">
		
		<cfscript>
		var i 			= 0;
		var endDay 		= 0;
		var startDay 	= 0;
		</cfscript>
		
		<script>
		<!--- Use Javascript to build the cells since using HTML creates a very large document --->
		function drawDays(start, end)
		{
			cell = '';
			cell += '<td style="border-bottom: 1px solid ##D5E3E6;"><table cellpadding="0" cellspacing="0" border="0" align="right"><tr>';			
			for (var day=start; day <= end; day=day+1)
			{
				// Prepend a '0' to days lower than 10. Serious spacing issues without this.
				if ( day.toString().length < 2 ) d = '0'+day.toString(); else d = day.toString();
				cell += '<td style="padding:0 2px 0 4px;">' + d + '</td>';
			}
			cell += '</tr></table></td>';
			document.write(cell);
		}
		</script>

		<cfloop from="1" to="#arguments.totalMonths#" index="i">  <!--- Loop through each month in the chart range --->
			<cfset startDay = 1>
			<cfset endDay = daysInMonth(dateAdd('m', i - 1, variables.startDate))>
			<script>drawDays(#startDay#, #endDay#)</script>					
		</cfloop>
	</cffunction>

	
	<cffunction name="drawLabelColumn" output="true" returntype="void" access="private">
		<cfset var borderedCellStyle = "border-left: 1px solid ##D5E3E6; border-right: 1px solid ##D5E3E6; border-bottom: 1px solid ##D5E3E6;">
		
		<!--- Here we use Javascript to build the HTML that will go into the 'labelSpace' div --->
		<script>
		var labelTable = '<table cellspacing="0" border="0" width="100%">';
		labelTable += '<tr>';
		labelTable += '<td style="#borderedCellStyle#; font:bold 11px; text-align:center; height:50px;">#replace(variables.rowLabel,"'","\'","ALL")#</td>';
		labelTable += '</tr>';
		<cfloop from="1" to="#arrayLen(variables.rows)#" index="row">
			labelTable += '<tr><td style="#borderedCellStyle#; height:30px;">#replace(variables.rows[row].getLabel(),"'","\'","ALL")#</td></tr>';
		</cfloop>
		labelTable += '</table>';
		$('labelSpace').innerHTML = labelTable;
		</script>		
	</cffunction>
	
	
	<cffunction name="drawDataRowCells" output="true" returntype="void" access="private">
		<cfargument name="topCalendarRowColumnCount" type="numeric" required="true">
	
		<!--- Drop the current row's properties into Javascript --->
		<script>
		var chartStartDate = new Date();
		chartStartDate.setYear(#datePart('yyyy',variables.startDate)#);
		chartStartDate.setMonth(#datePart('m',variables.startDate)#);
		chartStartDate.setDate(1);

		<cfloop from="1" to="#arrayLen(variables.rows)#" index="row">
			<cfset currentRow = variables.rows[row]>
			startDay#row# 	= new Object();
			endDay#row# 	= new Object();
			cellColor#row# 	= new Object();
			style#row#		= '#currentRow.getStyle()#';
			<cfloop from="1" to="#currentRow.getRangeCount()#" index="range">
				<cfset currentRange = currentRow.getRange(range)>
				startDay#row#[#range-1#] 	= #dayOrdinal(currentRange.startDate)#;
				endDay#row#[#range-1#] 		= #dayOrdinal(currentRange.endDate)#;
				cellColor#row#[#range-1#]	= '#currentRange.barColor#';
			</cfloop>
		</cfloop>
		
		<!--- Set the values for the element that was designated as the scroll-to target --->
		focusDay  = #dayOrdinal(variables.scrollToDate)#;
		noFocus = true;
		
		<!--- Javascript function to draw the colored bars for each item --->
		function drawBars(daysInMonth, currentRangeCount, startObject, endObject, colorObject, style, year)
		{
			dayScale = #variables.scale#;
			document.write('<td style="border-bottom: 1px solid ##D5E3E6; height:30px;"><table cellpadding="0" cellspacing="0" border="0"><tr>');
			
			if ( dayScale == 30 )
			{
				cell = '';
				for (month=1; month <= 12; month++)
				{
					cell += '<td style="width:30px;';
						
					var thisMonthStart = new Date();
					thisMonthStart.setYear(year);
					thisMonthStart.setMonth(month);
					thisMonthStart.setDate(1);
						
					var thisMonthEnd = new Date();
					thisMonthEnd.setYear(year);
					thisMonthEnd.setMonth(month);
					thisMonthEnd.setDate(30);
					
					var daysBetweenStart = Math.round( (thisMonthStart - chartStartDate) / ( 1000 * 60 * 60 * 24 ) );
					var daysBetweenEnd = Math.round( (thisMonthEnd - chartStartDate) / ( 1000 * 60 * 60 * 24 ) );
						
					// Loop through each range in this data row to see if the day matches is in the current year
					for (r=0; r < currentRangeCount; r++)
					{
						isInMonth = ( (daysBetweenStart >= startObject[r]) && (daysBetweenStart <= endObject[r]) ) || ( (daysBetweenEnd >= startObject[r]) && (daysBetweenEnd <= endObject[r]) );
						if ( isInMonth )
						{
							cell += 'background-color:' + colorObject[r] + ';';
							if ( style == 'striped' ) cell += ' border-right:1px solid ##D5E3E6;';
						}
					}
					cell += '">&nbsp;</td>';
				}
				document.write(cell);
				document.write('</tr></table></td>');
				
			} else {
				for (day=1; day <= daysInMonth; day=day+1)
				{
					cell = '<td style="width:30px;';
					
					// Loop through each range in this data row to see if the current day matches to any of them
					for (r=0; r < currentRangeCount; r++)
					{
						if ( (dayCount >= startObject[r]) && (dayCount <= endObject[r]) )
						{
							cell += 'background-color:' + colorObject[r] + ';';
							if ( style == 'striped' ) cell += ' border-right:1px solid ##D5E3E6;';
						}
					}
	
					// Set an anchor to the specified focus date (if exists)
					if ( (dayCount == focusDay) && (noFocus) ) 
					{
						noFocus = false;
						cell += '"><a id="focusSpot">&nbsp;</a>';
						
					} else cell += '">&nbsp;';
					cell += '</td>';
					
					// Depending on the scale of this chart, show only specific number of cells
					switch(dayScale)
					{
						case 1:
							document.write(cell);
							break;
						case 7:
							if ( (dayCount % 7) == 0 ) { document.write(cell); }
							break;
					}
					dayCount += 1;
				}
				document.write('</tr></table></td>');
			}
		}
		</script>

		<!--- Loop through each row added to the chart --->
		<cfloop from="1" to="#arrayLen(variables.rows)#" index="row">
			<cfset currentRow = variables.rows[row]>
			<tr>
				<!--- Drop the day count back to 0 for each data row --->
				<script>dayCount = 0;</script>
				
				<!--- Loop through each top level cell [year or month] --->
				<cfloop from="1" to="#topCalendarRowColumnCount#" index="col">
					<cfset year = datePart('yyyy',dateAdd('yyyy', col - 1, variables.startDate))>
					<script>drawBars(#daysInMonth(dateAdd('m', col - 1, variables.startDate))#, #currentRow.getRangeCount()#, startDay#row#, endDay#row#, cellColor#row#, style#row#, #year#);</script>
				</cfloop>
			</tr>
		</cfloop>
	</cffunction>
	

	<cffunction name="draw" output="true" returntype="string" hint="Draws the Gantt chart">
		<cfset var isIE = Find('MSIE',cgi.HTTP_USER_AGENT) gt 0>
		<cfset var months = "">
		<script>
		function $() { var elements = new Array(); for (var i = 0; i < arguments.length; i++) { var element = arguments[i]; if (typeof element == 'string') element = document.getElementById(element); if (arguments.length == 1) return element; elements.push(element); } return elements; }
		</script>
				
		<div style="width:<cfif isIE>102%<cfelse>99%</cfif>; background-color: F3F7F7;" id="ganttChart">
		
			<div id="loading" style="border:1px solid black; width:300px; padding:20px; position:absolute; background-color:red; color:white; left:260px; top:150px; font:bold 13px;">Loading chart data. Please wait...</div>

			<!--- The chart title --->
			<div style="height:50px;">
				<div style="float:left;"><h2 style="font-family: 'Lucida Grande',Verdana,Arial,Sans-Serif; font-size:20px; font-weight:bold; margin:0 0 0 0; padding:10px 0 10px 10px;">#variables.title#</h2></div>
				<div style="float:right; padding:10px 10px 10px 0;">[ <a href="#SCRIPT_NAME#?scale=daily">Daily</a> ] [ <a href="#SCRIPT_NAME#?scale=monthly">Monthly</a> ] [ <a href="#SCRIPT_NAME#?scale=yearly">Yearly</a> ]</div>
			</div>

			<!--- Only draw data rows if rows have been added to the chart --->
			<cfif arrayLen(variables.rows)>
			
				<!--- This is the left DIV tag that contains the row labels (i.e. the name of each row) --->
				<div id="labelSpace" style="left:0; top:0; border:1px solid black; width:19%; float:left;margin-right:0;"></div>
				<cfset drawLabelColumn()>
				
				<!--- Seperated the month drawing section because it could span a year and didn't want to clutter this method --->
				<cfscript>
				switch(variables.scale)
				{
					case 1:
					{
						monthTableWidthMultiplier = 300;
						topCalendarRow = buildTopMonthCells();
						break;
					}
					case 7:
					{
						monthTableWidthMultiplier = 60;
						topCalendarRow = buildTopMonthCells();
						break;
					}
					case 30:
					{
						monthTableWidthMultiplier = 60;
						topCalendarRow = buildTopYearCells();
						break;
					}
				}
				</cfscript>
				
				<!--- This is the right DIV that contains the month labels, each day label and each of the bars for the Gantt chart --->
				<div id="dataSpace" style="<cfif isIE>float:right;</cfif>width:80%; border-bottom:1px solid black; border-top:1px solid black; border-right:1px solid black; float:right;padding:0; overflow:scroll;margin-left:0;">
				<table cellpadding="0" cellspacing="0" border="0" width="#topCalendarRow.totalCells * monthTableWidthMultiplier#" height="37">
				
					<!--- Display the months HTML code--->
					<tr style="height:<cfif variables.scale neq 7>25px<cfelse>50px</cfif>;">#topCalendarRow.HTML#</tr>
		
					<cfswitch expression="#variables.scale#">
						<cfcase value="1">
							<!--- Draw a cell for each day in each month --->
							<tr style="height:25px;"><cfset drawBottomDayCells(topCalendarRow.totalCells)></tr>
						</cfcase>
						<cfcase value="7">
						
						</cfcase>
						<cfcase value="30">
							<!--- Draw a cell for each month in the year --->
							<tr style="height:25px;"><cfset drawBottomMonthCells(topCalendarRow.totalCells)></tr>
						</cfcase>					
					</cfswitch>
					
					<!--- Draw the Gannt rows for each item in the chart --->
					<cfset drawDataRowCells(topCalendarRow.totalCells)>
				</table>
				</div>
			</cfif>
		</div>
		
		<script>
		// Scroll to the specified 'focus on' date
		//var thepoint = $('focusSpot').offsetLeft;
		//$('dataSpace').scrollLeft = thepoint;

		$('loading').style.visibility = 'hidden';
		</script>
	</cffunction>
</cfcomponent>