<cfcomponent>

	<cffunction name="getScheduleQuery" returntype="Query">
		<cfsavecontent variable="local.tasks">
	    	<cfschedule action="run" task="__list">
	    	</cfsavecontent>
	    	<cfscript>
	    		local.tasks = trim(local.tasks);
	    		local.tasks = replace(local.tasks,chr(10),'','all');
	    		if (len(local.tasks) > 0)
		    		local.tasks = mid(local.tasks,2,len(local.tasks)-3);
	    		local.tasks = replace(local.tasks,'}}},','}}#chr(10)#','all');
	    		local.tasks = replace(local.tasks,'={{',chr(9),'all');
	    		local.tasks = replace(local.tasks,'},','}#chr(9)#','all');
	    		local.tasks = replace(local.tasks&chr(10), '}}#chr(10)#', '}#chr(10)#', 'all');
	    		local.tasks = replace(local.tasks,'}#chr(9)#',chr(9),'all');
	    		local.columns = 'task,start_date,start_time,last_run,end_time,interval,operation,url,resolveurl,request_time_out,username,password,http_port,path,proxy_server,http_proxy_port,file,disabled,paused,publish';
	    		qryScheduledTasks = QueryNew(local.columns);
	    	</cfscript>
	    	<cfloop list="#local.tasks#" delimiters="#chr(10)#" index="row">
	    		<cfset QueryAddRow(qryScheduledTasks)>
	    		<cfloop list="#local.columns#" index="column">
	    			<cfloop list="#row#" delimiters="#chr(9)#" index="data">
	    				<cfif spanExcluding(data,'=') eq column>
	    					<cfset QuerySetCell(qryScheduledTasks,column, replace(data,column&'={',''))>
	    				</cfif>
	    			</cfloop>
	    		</cfloop>
	    	</cfloop>
	    <cfreturn qryScheduledTasks>
	 </cffunction>
</cfcomponent>