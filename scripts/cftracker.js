var jsonMilestones = [];
var jsonDashMenu = [];
var jsonProjectCounts = [];
var jsonProjects = [];
var jsonTodos = [];
var recentresultscontent = "";
var timervar;
var linkstimervar;
var initialLoadTimer;
var todotimervar;
var tcfileuploadtimer;
var chartheight = 300;
var chartwidth = 840;
var currentview = "allprojects";
var allTests = [];
var removeTests = [];

$(document).ready(function() {
	
  	$('[data-toggle="tooltip"]').tooltip()
	
	$.getJSON("cfc/Dashboard.cfc?method=chartList", function(data) {
		jsonDashMenu = data;
	});
	$.getJSON("cfc/Dashboard.cfc?method=allProjectsCount", function(data){
		jsonProjectCounts = data;
	});
	$.getJSON("cfc/Dashboard.cfc?method=TodosBySection", function(data) {
		jsonTodos = data.DATA;
		if (jsonTodos.length == 0) {
			jsonTodos = [
				["0","0"]
			];
		}
	});
	$.getJSON("cfc/Dashboard.cfc?method=MilestonesJSON", function(data) {
		jsonMilestones = data;
	});
	$.getJSON("cfc/Dashboard.cfc?method=allProjectsJSON",function(data){
		jsonProjects = data;
	});
		
	projectIDCheck();
	
	initialLoadTimer = setInterval(function() {homeLoad()},10);
	linkstimervar = setInterval(function() {insertLinks()},10);
	todotimervar = setInterval(function() {insertTodos()},10);
	timervar = setInterval(function() {insertAdditional()},10);
	logincheck = setInterval(function() {checkLoggedIn()},100000);
		
	$("a#lnkAssignedTests").click(function(event) {
		event.preventDefault();
		var userid = $("a#lnkAssignedTests").attr("userid");
		$("#featurecontent").load("cfc/dashboard.cfc?method=assignedTestsGrid&userid="+userid+"&page=1&pageSize=10");
	});
	$("a#lnkHome").click(function(event) {
		event.preventDefault();
		$.ajax({ url:"cfc/Dashboard.cfc?method=removeSessionProject",type:"POST"}).done(function()
		{
			projectid = null;
			$("#panelprojects").remove();
			$("#panel-actions").remove();
			homeLoad();
		});
	});
	
	$("a#lnkReturnAllProjects").click(function(event) {
		event.preventDefault();
		$.ajax({ url:"cfc/Dashboard.cfc?method=removeSessionProject",type:"POST"}).done(function()
		{
			projectid = null;
			$("#panelprojects").remove();
			$("#panel-actions").remove();
			$("#createreportpanel").remove();
			$("#lnkReturnToProject").hide();
			$(".ddmScenarios").hide();
			$(".ddmTestCases").hide();
			$(".ddmAutomationStudio").hide();
			$(".ddmAutomationStudio").hide();
			$(".lnkViewReports").hide();
			$(".ddmMilestones").hide();
			homeLoad();
		});
	});
	$(document).on("click",".testcaseeditlink",function(event){
		event.preventDefault();
		var editid = $(this).attr("editid");
		$("#largeModal .modal-title").text("Edit Test Case");
		$("#largeModal .modal-body").load("cfc/forms.cfc?method=TestCaseForm&testcaseid="+editid);
		$("#largeModal").modal("show");
	});
	$(document).on("click","a.lnkBuildAutomatedTest",function(event){
		event.preventDefault();
		$("#largeModal .modal-title").text("<i class='fa fa-list-alt'> </i>Build Automated Test(s)");
		$("#largeModal .modal-body").load("cfc/AutomationStudio.cfc?method=getListObj");
		$("#largeModal").modal("show");
	})
	$(document).on("click","a.lnkAddSections",function(event) {
		$("#smallModal .modal-title").text("Add Section");
		$("#smallModal .modal-body").load("cfc/forms.cfc?method=TestSectionForm");
		$("#smallModal").modal("show");
	});
	$(document).on("click","a.lnkAddTestCaseToScenario",function(event) {
		$("#smallModal .modal-title").text("Add Test Cases to Scenario");
		$.ajax({
			url: "cfc/forms.cfc?method=AddTestCasesForm",
			type: "POST",
			data: { scenarioid : $(this).attr("scenarioid")	}
		}).done(function(data){
			$("#smallModal .modal-body").html(data);
			$("#smallModal").modal("show");
		});
	});
	$(document).on("click","a#lnkAddProject",function(event) {
		event.preventDefault();
		$("#largeModal .modal-title").text("Add Project");
		$("#largeModal .modal-body").load("cfc/forms.cfc?method=ProjectForm");
		$("#largeModal").modal("show");
		$(document).trigger("eventLoadForm");
	});
	$(document).on("click","a.lnkEditProject",function(event) {
		event.preventDefault();
		var pjid = $(this).attr("projectid");
		$("#largeModal .modal-title").text("Edit Project");
		$("#largeModal .modal-body").load("cfc/forms.cfc?method=ProjectForm&projectid="+pjid);
		$("#largeModal").modal({show:"true"});
		$(document).trigger("eventLoadForm");
	});
	$(document).on("click","a.pjlink", function(event) {
		$("featurecontent").empty();
		event.preventDefault();
		projectid = $(this).attr("pjid");
		currentview = "project";
		$.ajax({ url:"cfc/Dashboard.cfc?method=setSessionProject",type:"POST",data: {projectid : projectid}}).done(function() {
			$("#uldashboard").show();
			$("#activitypanel").remove();
			projectIDCheck();
			projectLoad();
			$("#panelprojects").remove();
			$("#createreportpanel").remove();
		});
		$("#lnkReturnToProject").show();
		//$(".lnkViewMilestones").show();
		$(".ddmMilestones").show();
		$(".ddmScenarios").show();
		$(".ddmAutomationStudio").show();
		$(".ddmTestCases").show();
		$(".lnkViewReports").show();
		//$("#lnkReturnToProject").hide();
		todotimervar = setInterval(function() {insertTodos()},10);
		insertActions();
	});
	$(document).on("click","a.lnkAddScenario", function(event) {
		event.preventDefault();
		$("#largeModal .modal-title").text("Add Test Scenario");
		$("#largeModal .modal-body").load("cfc/forms.cfc?method=TestScenarioForm");
		$("#largeModal").modal("show");
	});
	$(document).on("click","a.lnkEditScenario",function(event) {
		event.preventDefault();
		var pjid = $(this).attr("scenarioid");
		$("#largeModal .modal-title").text("Edit Test Scenario");
		$("#largeModal .modal-body").load("cfc/forms.cfc?method=TestScenarioForm&testscenarioid="+pjid);
		$("#largeModal").modal({show:"true"});
	});
	$(document).on("click","a.lnkEditScenarioBig",function(event){
		event.preventDefault();
		var scenarioid = $(this).attr("scenarioid");
		$("#topcontent").empty();
		$("#topcontent").removeClass("panel").removeClass("panel-default");
		$("#topcontent").prepend("<div id='panelTestScenario' class='panel panel-default'><div class='panel-heading'>Edit Test Scenario</div><div id='panelTestScenarioBody' class='panel-body'>");
		$("#topcontent").append("</div></div>");
		$("#panelTestScenarioBody").load("cfc/forms.cfc?method=TestScenarioForm&testscenarioid="+scenarioid);
		$("#midrow").empty();
		$("#activitypanel").remove();	
		$("#lnkReturnToProject").attr("pjid",projectid);
		$("#lnkReturnToProject").show();
	});
	$(document).on("click","a.lnkAddMilestone",function(event){
		event.preventDefault();
		$("#largeModal .modal-title").text("Add Milestone");
		$("#largeModal .modal-body").load("cfc/forms.cfc?method=MilestoneForm");
		$("#largeModal").modal("show");
	});
	$(document).on("click","a.lnkEditMilestone",function(event) {
		event.preventDefault();
		var pjid = $(this).attr("milestoneid");
		$("#largeModal .modal-title").text("Edit Milestone");
		$("#largeModal .modal-body").load("cfc/forms.cfc?method=MilestoneForm&milestoneid="+pjid);
		$("#largeModal").modal({show:"true"});
	});
	$(document).on("click","a.lnkAddTest",function(event) {
		event.preventDefault();
		$("#largeModal .modal-title").text("Add Test Case");
		$("#largeModal .modal-body").load("cfc/forms.cfc?method=TestCaseForm");
		$("#largeModal").modal("show");		
		
	});
	$(document).on("click","a.lnkCreateReport",function(event) {
		event.preventDefault();
		$("#largeModal .modal-title").text("Add New Report");
		var reporttype = $(this).attr("reporttype");
		$("#largeModal .modal-body").load("cfc/forms.cfc?method=ReportForm&reporttype="+reporttype);
		$("#largeModal").modal("show");
		
	});
	$(document).on("click","a.lnkAddResults",function(event) {
		event.preventDefault();
		$("#largeModal .modal-title").text("Add Test Results");
		allTests = [];
		$("input:checkbox[name=cbxId]:checked").each(function(){
			allTests.push($(this).attr("caseid"));
		});
		var scenarioid = $(this).attr("scenarioid");
		$("#largeModal .modal-body").load("cfc/forms.cfc?method=TestResultForm&testcaseids="+allTests.join()+"&scenarioid="+scenarioid);
		$("#largeModal").modal("show");
	});
	$(document).on("click","a.lnkRemoveTestCases",function(event){
		event.preventDefault();
		removeTests = [];
		$("input:checkbox[name=cbxId]:checked").each(function(){
			removeTests.push($(this).attr("caseid"));
		});
		var scenarioid = $(this).attr("scenarioid");
		$.ajax({
			url: "cfc/forms.cfc?method=removeTestCases&testcases="+removeTests.join()+"&scenarioid="+scenarioid
		}).done(function(){
			$("#topcontent").removeClass("panel").removeClass("panel-default");
			$("#topcontent").load("cfc/Dashboard.cfc?method=TestScenarioHub&scenarioid="+scenarioid);
			$("#midrow").empty();
			$("#activitypanel").remove();
			$("#lnkReturnToProject").attr("pjid",projectid);
			$("#lnkReturnToProject").show();
			$("#createreportpanel").remove();
		});
	});
	$(document).on("click","a.lnkViewTests",function(event){
		event.preventDefault();
		$("#topcontent").removeClass("panel").removeClass("panel-default");
		$("#topcontent").load("cfc/Dashboard.cfc?method=AllTests");
		$("#midrow").empty();
		$("#activitypanel").remove();
		$("#lnkReturnToProject").attr("pjid",projectid);
		$("#lnkReturnToProject").show();		
		$("#createreportpanel").remove();
	});
	$(document).on("click","a.lnkViewMilestones",function(event) {
		event.preventDefault();
		$("#topcontent").removeClass("panel").removeClass("panel-default");
		$("#topcontent").load("cfc/Dashboard.cfc?method=AllMilestones");
		$("#midrow").empty();
		$("#activitypanel").remove();	
		$("#lnkReturnToProject").attr("pjid",projectid);
		$("#lnkReturnToProject").show();
		currentview = "milestones";
		$("#createreportpanel").remove();
	});
	$(document).on("click","a.lnkViewScenarios",function(event) {
		event.preventDefault();
		$("#topcontent").removeClass("panel").removeClass("panel-default");
		$("#topcontent").load("cfc/Dashboard.cfc?method=AllScenarios");
		$("#midrow").empty();
		$("#activitypanel").remove();
		$("#lnkReturnToProject").attr("pjid",projectid);
		$("#lnkReturnToProject").show();
		$("#createreportpanel").remove();
	});
	$(document).on("click","a.lnkOpenScenarioHub",function(event) {
		event.preventDefault();
		$("#topcontent").removeClass("panel").removeClass("panel-default");
		$("#topcontent").load("cfc/Dashboard.cfc?method=TestScenarioHub&scenarioid="+$(this).attr("scenarioid"));
		$("#midrow").empty();
		$("#activitypanel").remove();
		$("#lnkReturnToProject").attr("pjid",projectid);
		$("#lnkReturnToProject").show();
		$("#createreportpanel").remove();
	});
	$(document).on("click","a.lnkViewScheduledTests",function(event){
		event.preventDefault();
		$("#largeModal .modal-title").text("Scheduled Tests");
		$("#largeModal .modal-body").load("cfc/AutomationStudio.cfc?method=viewAutomatedTasks");
		$("#largeModal").modal("show");
	});
	$(document).on("click","a.lnkViewReports",function(event){
		event.preventDefault();
		$("#topcontent").removeClass("panel").removeClass("panel-default");
		reportScreen();
	});
	$(document).on("click","a.lnkReportDelete",function(event) {
		event.preventDefault();
		$.ajax({
			url: "CFC/forms.cfc?method=deleteReport",
			type: "POST",
			data: {reportid : $(this).attr("reportid") }
		}).done(function(data){
			$("#topcontent").removeClass("panel").removeClass("panel-default");
			reportScreen();
		});
	});
	$(document).on("click","a.lnkDownloadTestCaseTemplate", function(event) {
		event.preventDefault();
		$.ajax({
			url: "CFC/Maintenance.cfc?method=createSpreadsheetTestCaseTemplate"
		}).done(function()
		{
			window.open("excel/fordownload.xls");
		});
	});
	$(document).on("click","a.lnkUploadTestCases",function(event){
		$("#smallModal .modal-title").text("Upload Excel File with Test Cases");
		$("#smallModal .modal-body").load("cfc/Maintenance.cfc?method=TestCaseFileUpload");
		$("#smallModal").modal("show");
	});
	$(document).on("click","a.lnkScheduleTests",function(event) {
		event.preventDefault();
		$("#largeModal .modal-title").text("Schedule Automated Tests");
		$("#largeModal .modal-body").load("cfc/AutomationStudio.cfc?method=skedAdd");
		$("#largeModal").modal("show");
	});
	$(document).on("click","a.lnkQuickTSReport",function(event) {
		if ($(this).attr("reportvalue") != "") {
			$.ajax({
				url: "cfc/Dashboard.cfc?method="+$(this).attr("reportvalue"),
				type: "POST",
				data: {
					scenarioid : $(this).attr("scenarioid")
				}
			}).done(function(data){
				$("#scenarioreport").replaceWith(data);
			});
		}
	});
	$(document).on("eventLoadForm", function(event){
		$("#txtProjectStartDate").datepicker({
			format:"mm/dd/yyyy",
			todayHighlight: true
		});
	});
	$(document).on("click","#btnClose",function(event) {
		event.preventDefault();
		$("#largeModal").modal('hide');
		$("#smallModal").modal('hide');
	});
	$(window).resize(function() {
		
	});
});

function projectIDCheck(){
	if ( isNumber(projectid) && $("#activitypanel").length <= 0)
	{
		$.ajax({
			url: "cfc/Dashboard.cfc?method=mostRecentTests",
			type: "GET"
		}).done(function(data) {
				recentresultscontent = data;
		});
		
		$("#lnkReturnToProject").show();
		$(".ddmMilestones").show();
		$(".ddmScenarios").show();
		$(".ddmTestCases").show();
		$(".ddmAutomationStudio").show();
		$(".lnkViewReports").show();
	}
}

function insertTodos() {
	if ($("#todopanel").length == 0) {
		$.ajax({
			url: "cfc/Dashboard.cfc?method=getTodos"
		}).done(function(data){
			$("#actioncontent").append(data);
		});
	}
	window.clearInterval(todotimervar);
}

function reportScreen() {
	$("#topcontent").load("cfc/Dashboard.cfc?method=AllReports");
	//$("#actioncontent").load("cfc/Dashboard.cfc?method=getCreateReports");
	if ($("#createreportpanel").length == 0) {
		$.ajax({
			url: "cfc/Dashboard.cfc?method=getCreateReports"
		}).done(function(data){
			$("#actioncontent").prepend(data);
		});
	}
	$("#midrow").empty();
	$("#activitypanel").remove();
}

function insertLinks() {
	if ($("#linkspanel").length == 0)
	{
		$.ajax({
			url: "cfc/Dashboard.cfc?method=getLinks"
		}).done(function(data){
			$("#actioncontent").append(data);
		});
	}
	window.clearInterval(linkstimervar);
}

function checkLoggedIn() {
	$.ajax({
		url: "cfc/Dashboard.cfc?method=checkLoggedIn",
		type: "POST",
		dataType: "json"
	}).done(function(data) {
		if (!data.LOGGEDIN) {
			location.href = "login.cfm";
		}
	});
}

function insertAdditional() {
	if (recentresultscontent.length > 0 && $("#activitypanel").length == 0 ) {
		$("#featurecontent").append(recentresultscontent);
		window.clearInterval(timervar);
	}
}

function insertActions() {
	$("#panel-actions").remove();
	$.ajax({url:"cfc/dashboard.cfc?method=Actions"}).done( function(data){
		$("#actioncontent").prepend(data);
	})
}

function insertDashMenu() {
	$("#activitytitle").append('<div class="btn-group" style="float:right;margin-top:-5px;"><a class="btn btn-sm btn-info" href="#"><i class="fa fa-bar-chart fa-fw"></i> Quick Reports</a><a class="btn btn-info btn-sm dropdown-toggle" data-toggle="dropdown" href="#"><span class="fa fa-caret-down"></span></a><ul id="pjreportmenu" class="dropdown-menu"></ul></div>');
	$.each(jsonDashMenu, function(index) {
		$("#pjreportmenu").append("<li><a href='#' class='lnkQuickReport' reportvalue='"+jsonDashMenu[index].optvalue+"'><i class='fa "+jsonDashMenu[index].opticon+" fa-fw'></i> "+jsonDashMenu[index].optlabel+"</a></li>");
	});
	$(".lnkQuickReport").click(function(event) {
		event.preventDefault();
		if ($(this).attr("reportvalue") != "") {
			$.ajax({
				url: "cfc/Dashboard.cfc?method="+$(this).attr("reportvalue"),
				type: "POST",
				data: { projectid : projectid }
			}).done(function(data) {
				$("#topcontent").replaceWith(data);
				insertDashMenu();
			});
		}
	});
}

function insertProjectInfo() {
	if (!($.isEmptyObject(jsonProjects))) {
		$("#featurecontent").append("<div id='panelprojects' class='panel panel-default'><div class='panel-heading'><i class='fa fa-wrench'></i> Projects</span><a href='##' id='lnkAddProject' class='btn btn-info btn-sm' style='float:right;margin-top:-5px;'><i class='fa fa-plus-square'></i> Add Project</a></div><div id='pjpanelbody' class='panel-body' style='padding:10px;'></div></div>");
		$.each(jsonProjects, function(index){
			var pjcontent = "";
			pjcontent += "<div class='col-xs-2 col-sm-2 col-md-2 col-lg-2 text-right' style='padding-left:0px;padding-right:0px;'>";
			pjcontent += "<h1 style='margin:0px;'><span class='label label-primary' style='padding:5px;background-color: #"+jsonProjects[index].Color+";'>";
			pjcontent += "<i class='projects fa fa-wrench fa-fw'></i></span></h1></div>";
			pjcontent += "<div class='col-xs-10 col-sm-10 col-md-10 col-lg-10'><h5><span class='label label-info'>P"+jsonProjects[index].id+"</span> <a href='#' class='pjlink' pjid='" + jsonProjects[index].id + "'>"+jsonProjects[index].ProjectTitle+"</a>&nbsp;&nbsp;<a href='#' class='lnkEditProject btn btn-default btn-xs' projectid='"+jsonProjects[index].id+"'><i class='fa fa-pencil'></i> Edit</a></h5>";
			pjcontent += "<a href='#'>Todos</a>&nbsp;&nbsp;|&nbsp;&nbsp;";
			pjcontent += "<a href='#'>Milestones</a>&nbsp;&nbsp;|&nbsp;&nbsp;";
			pjcontent += "<a href='#'>Tests</a>&nbsp;&nbsp;|&nbsp;&nbsp;";
			if (jsonProjects[index].RepositoryType == 2)
				pjcontent += "<a href='#'>Test Scenarios</a>&nbsp;&nbsp;|&nbsp;&nbsp;";
			pjcontent += "<a href='#'>Reporting</a></div><div class='clearfix' style='margin-bottom:20px;'></div>";
			$("#pjpanelbody").prepend(pjcontent);
			
		});
	}
}

function casesLoad(projectid) {
	
}

function projectLoad() {
	$.ajax({
		url: "cfc/Dashboard.cfc?method=HubChart",
		type: "POST",
		data: {
			projectid : projectid
		}
	}).done(function(data){
		$("#topcontent").remove();
		$("#featurecontent").prepend(data);
		insertDashMenu();
		insertAdditional();
		insertMilestones();
		insertScenarios();
		insertActions();
	});
}

function insertMilestones() {
	$.ajax({
		url: "cfc/dashboard.cfc?method=getMilestones",
		type: "post",
		data: { projectid : projectid }
	}).done(function(data){
		$("#midrow").prepend(data);
	});
}

function insertScenarios() {
	$.ajax({
		url: "cfc/dashboard.cfc?method=getTestScenarios",
		type: "post",
		data: { projectid : projectid }
	}).done(function(data) {
		$("#midrow").append(data);
	});
}

function homeLoad() {
	if ( isNumber(projectid)  )
	{
		$.ajax({
				url: "cfc/Dashboard.cfc?method=HubChart",
				type: "POST",
				data: { projectid : projectid }
			}).done(function(data) {
				$("#topcontent").remove();
				$("#featurecontent").prepend(data).fadeIn();
				insertDashMenu();
				insertAdditional();
				insertMilestones();
				insertScenarios();
				insertActions();
				$("#panelprojects").remove();
			});
		window.clearInterval(initialLoadTimer);
		return; 
	}
	if ( !($.isEmptyObject(jsonProjectCounts))) {
		if (jsonProjectCounts.TotalProjects > 0) {
			$("#featurecontent").load("cfc/Dashboard.cfc?method=AllProjectsChart",function() {
				insertProjectInfo();
				$("#uldashboard").hide();
				$("#featurecontent").append('<div id="midrow" class="row"></div>');
			});
		} else {
			$("#featurecontent").prepend("<div class='alert alert-danger' role='alert'><strong>Add your first project to CFTestTrack</strong><br />Welcome!  This dashboard displays an overview of available projects and recent activity, but there aren't any projects yet.<p><br /><a id='lnkAddProject' class='btn btn-info'><i class='fa fa-plus-square'></i> Add Project</a></p></div>");
		}
		window.clearInterval(initialLoadTimer);
	}
}