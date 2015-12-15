component table="TTestLinks" persistent="true"
{
	property name="id" ormtype="integer" column="id" fieldtype="id" generator="identity";
	property name="LinkDesc" ormtype="string" length="1000" notnull="false";
	property name="LinkHref" ormtype="string" length="255" ;
}