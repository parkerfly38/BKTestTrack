component  implements="CFTestTrack.cfc.IReports"
{
	variables.reportid = "";
	
	public struct function getReportOptions()
	{
		return StructNew();
	}
	public void function setAccessAndScheduling(required struct accessandscheduling)
	{

	}
	public string function getReportDescription()
	{
		return "";
	}
	public string function getJSONFormDataForPost()
	{
		return "";

	}
	public any function runReport()
	{
		return;
	}
	public any function showReport()
	{
		return;
	}
	public void function saveReport()
	{

	}
	public struct function getAccessAndScheduling()
	{
		return StructNew();
	}
	public string function getReportTypeName()
	{
		return "Ready for Production";
	}
	public string function getVersion()
	{
		return "1";
	}
	public string function getFormFields()
	{
		savecontent variable="formfields" 
		{
			include "../../report/ReadyForProduction.cfm";
		}
		return formfields;
	}
	public string function getAuthor()
	{
		return "Brian Kresge, MBA";
	}
	public numeric function getReportId()
	{
		return variables.reportid;
	}
	public string function getReportName()
	{
		return "";
	}
	public string function getGroup()
	{
		return "AxoSoft";
	}
	public void function setReportOptions(required struct reportoptions)
	{

	}
}