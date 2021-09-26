/**************************************************************
* Description       : Test class for CD_WOD_WebToLeadController
* @author           : Lahiru Subasinghe
* @since            : February 17, 2019
***************************************************************/

@isTest
public class CD_WOD_WebToLeadControllerTestClass {

    //Setup Test Data
    @testSetup static void setupTestData() {
        
        Campaign camRec = new Campaign();
        camRec.Name = 'World Education Virtual Fair 2021';
        camRec.StartDate = System.today();
        camRec.Duration__c = '10AM-5PM';
        camRec.Location__c = 'Taj';
		camRec.Campaign_Version__c = 'V5';        
        insert camRec; 
            
    }
    
    @isTest
    static void webToLeadTestMethod() {
        
        Test.startTest();
        
        Campaign cam = [Select Id, Name, Location__c, StartDate, Duration__c From Campaign LIMIT 1];
        
        CD_WOD_WebToLeadController ctrl = new CD_WOD_WebToLeadController();
        PageReference pageRef = Page.CD_WOD_WebtoLeadv1;
        pageRef.getParameters().put('one','V5');
        test.setCurrentPageReference(pageRef);
        
        //Setup global variables
        ctrl.firstName = 'TUserFname';
        ctrl.lastName = 'TUserLname';
        ctrl.emailAddress = 'a@d.com';
        ctrl.mobile = '0772653855';
        ctrl.infoTextArea = 'Random Text Area';
        ctrl.homePhoneNumber = '0112123456';
        ctrl.studyArea = 'Random';
        ctrl.hearUs = 'Call';
        ctrl.vfPageNumber = 'V5';
        ctrl.preferredCountry = 'USA';
        ctrl.showError = false;        
        ctrl.showSuccess = false;
        
        //Run all controller methods
        ctrl.getPrefOptions();
        ctrl.getHearAbtUs();
        ctrl.saveLead();
        
        ctrl.clearForm();
        ctrl.closeNotification();
        
        Test.stopTest();
        
        Lead__c leadRec = [Select Id, Name, First_Name__c From Lead__c LIMIT 1];
        System.assertEquals(leadRec.First_Name__c, 'TUserFname');
        System.assertEquals(cam.Name, 'World Education Virtual Fair 2021');
        
        

        
        
        
    }



}