component extends="cfselenium.CFSeleniumTestCase" displayName="testcase" {

    public void function beforeTests() {
        browserUrl = "http://localhost";
        super.beforeTests();
        selenium.setTimeout(30000);
    }

    public void function testLoginBrowser() {
        selenium.open("/COGTestTracker/login.cfm");
        assertTrue(selenium.isTextPresent("Login Form"),"Login form loaded");
        selenium.type("id=username", "bkresge");
        selenium.type("id=password", "COGbk1!!");
        selenium.click("name=submit");
        selenium.waitForPageToLoad("30000");
        selenium.select("id=dashselect", "label=Activity (14 days)");
        selenium.select("id=dashselect", "label=System Activity");
        selenium.click("id=lnkAssignedTests");
        selenium.click("id=lnkHome");
        selenium.click("link=Log out");
        selenium.waitForPageToLoad("30000");
        assertTrue(selenium.isTextPresent("Login Form"));
    }
}
