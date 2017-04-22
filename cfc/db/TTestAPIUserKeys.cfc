component table="TTestAPIUserKeys" persistent="true" 
{	
	property name="id" column="id" fieldtype="id" generator="identity";
	property name="clientid" notnull="true";
	property name="privatekey" notnull="true";
	property name="testerid" ormtype="integer" notnull="true";
	property name="activated" ormtype="boolean";
	property name="DeviceUUID";
}