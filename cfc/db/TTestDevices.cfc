component table="TTestDevices" persistent="true"
{
	property name="TTesterDeviceID" column="TTesterDeviceID" fieldtype="id" generator="identity";
	property name="DeviceUUID" ormtype="string" length="1500";
	property name="DeviceOS" ormtype="string";
	property name="TesterID" ormtype="integer";
}