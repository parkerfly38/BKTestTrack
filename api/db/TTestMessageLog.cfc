component table="TTestMessageLog" persistent="true"
{
	property name="id" column="id" fieldtype="id" ormtype="integer" generator="identity";
	property name="username" column="username" ormtype="string" length="255";
	property name="messagedate" column="messagedate" ormtype="timestamp";
	property name="messagebody" column="messagebody" ormtype="string" length="1000";
}