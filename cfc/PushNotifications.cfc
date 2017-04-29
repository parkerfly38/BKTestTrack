<cfcomponent displayname="Push Notifications" hint="Push Notification service for this app">
	
	<cfset APNSService = createObject( "java", "com.notnoop.apns.APNS" ).newService() .withCert("THE-PATH-TO-YOUR-P12-CERT", "YOUR-P12-PASSWORD") .withProductionDestination() .build() />

</cfcomponent>