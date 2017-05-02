<cfcomponent displayname="Push Notifications" hint="Push Notification service for this app">
	
	<cfset APNSService = createObject( "java", "com.notnoop.apns.APNS" ).newService() .withCert("../apns/apn_sandbox.p12", "NUgget38!@") .withProductionDestination() .build() />

	

</cfcomponent>