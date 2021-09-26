/**************************************************************
* Description       : Test class for CD_WOD_MainRegistration
* @author           : Lahiru Subasinghe
* @since            : March 4, 2019
***************************************************************/

@isTest
public class CD_WOD_MainRegistrationTestClass {
    
    @testSetup static void setupTestData() {
        
        Campaign camRec = new Campaign();
        camRec.Name = 'World Education Fair 2019';
        camRec.StartDate = System.today();
        camRec.Duration__c = '10AM-5PM';
        camRec.Location__c = 'Taj';
        
        insert camRec;
        
        
    }
    
    
    @isTest
    static void mainRegistrationTestMethod_withExceptions_saveRecord(){
        
        Test.startTest();
        
        CD_WOD_MainRegistration ctrl = new CD_WOD_MainRegistration();
        PageReference pageRef = Page.CD_MailRegistrationPage;
        test.setCurrentPageReference(pageRef);
        
        ctrl.showError = false;
        ctrl.showSuccess = false;
        ctrl.errorMsg = '';
        ctrl.emailAddress = 'test.com';
        ctrl.mobile = '0772653856';
        
        ctrl.saveLead();
        
        Test.stopTest();
        
    }
    
    

    @isTest
    static void processLeadTestMethod() {
        

        Test.startTest();
        
        
        CD_WOD_MainRegistration ctrl = new CD_WOD_MainRegistration();
        PageReference pageRef = Page.CD_MailRegistrationPage;
        test.setCurrentPageReference(pageRef);
       
        
        ctrl.showError = false;
        ctrl.showSuccess = false;
        ctrl.errorMsg = '';
        ctrl.firstName = 'TUserFname';
        ctrl.lastName = 'TUserLname';
        ctrl.emailAddress = 'a@d.com';
        ctrl.mobile = '0772653855';
        ctrl.infoTextArea = 'Random Text Area';
        ctrl.homePhoneNumber = '0112123456';
        ctrl.studyArea = 'Random';
        ctrl.hearUs = 'Call';
        ctrl.vfPageNumber = 'V1';
        ctrl.preferredCountry = 'USA';
        
        ctrl.saveLead();
        ctrl.clearForm();
        ctrl.closeNotification();
        ctrl.getPrefOptions();
        ctrl.getHearAbtUs();
        
        Test.stopTest();
        
        Lead__c ldRec = [Select Id, Name, Participated__c From Lead__c LIMIT 1];
        System.assertEquals(ldRec.Participated__c, true);
        
    }
    
   

}