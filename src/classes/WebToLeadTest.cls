/*

Created By :- Arulmozhi.R
Description:- Test Class for Web to Lead Form

Lahiru : Updating the test classes due to lack of coverage by Dazework

*/

@isTest
public class WebToLeadTest {
    
    
    static testMethod void MyTest()
    {
        
        
        Lead__c L = new Lead__c();
        l.name = 'Test';
        l.Last_Name__c = 'Last test';
        l.Email__c  = 's23@gmail.com';
        l.Mobile__c = '9087967543';
        l.Web_Lead_Subject__c = 'Test Subject';
        l.Web_Lead_Message__c = 'Test Message';
        l.Preferred_University__c = null;
        l.Lead_Source__c = 'Friend';
        l.Country_Interested_In__c = 'USA';
        INSERT l;
        
        University__c uRec = new University__c(name='test', University_Address__c='test');
        
        
        //String firstName, String lastName, String email,String mobile,String message,String university,String leadSource
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        WebToLead testWeb = new WebToLead(sc);
        WebToLead.saveFormLd(l.Last_Name__c,l.Name,l.Email__c,l.Mobile__c,l.Web_Lead_Message__c,l.Preferred_University__c,l.Lead_Source__c,l.Lead_Type__c,l.Country_Interested_In__c);
        //WebToLead.getPrefOptions();
        //WebToLead.getExistingUniversities();
        WebToLead.University un = new WebToLead.University('test', 'test', 'test');
        WebToLead.University un2 = new WebToLead.University(uRec);
        

        
        Test.StopTest();
        
    }
}