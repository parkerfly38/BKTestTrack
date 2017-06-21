The Crucible
============

Testing Suite for ColdFusion

### What is The Crucible? ###

The Crucible is test case management software for QA and development teams, specifically for ColdFusion development
environments, but can be used to run Selenium tests on most other web applications as well.

### Requirements ###

1.  CF10, CF11, CF2016 supported
2.  [CFSelenium] (https://github.com/teamcfadvance/CFSelenium) - FireFox plugins
3.  Selenium IDE with above mentioned FireFox plugin
4.  MXUnit
5.  MS SQL Server/PostgreSQL (though PostgreSQL may be buggy)
6.  Taffy for REST service API

### Credits and Thanks ###

This project would not be possible without the great work by Bob Silverberg on CFSelenium, and the folks that bring us MXUnit.
This project also uses Bootstrap and JQuery, without which development would have truly been a pain.

### Setup ###

Over time, I'll work on rolling more of the setup into a process.  Right now, you have to run some SQL creation scripts, conveniently
located in the SQL folder.  Some tables will be created automatically.  You will also have to adjust the annotated places in the
Application.CFC folder.

This application will not be able to work if you are hosted in an environment where you cannot launch Java jars from ColdFusion.  If
you don't have execution permissions, you will be limited to using the MXUnit testing capabilities only against code script.

This application has not been tested against Lucee.  I welcome any attempt to get it working, please feel free to fork this repo into
a Lucee version.

Depending on whether you host in Windows or Linux/OS X, you will need to adjust .htaccess or web.config appropriately to configure URL
rewriting or routing.  Example files are included in this repo.