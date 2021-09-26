/**************************************************************
* Description       : Test class for CD_ProcessLeadController
* @author           : Lahiru Subasinghe
* @since            : February 25, 2019
***************************************************************/

@isTest
public class CD_ProcessLeadControllerTestClass {
    
    @testSetup static void setupTestData() {
        
        Lead__c ld = new Lead__c();
        ld.Email__c = 'test@test.com';
        ld.Mobile__c = '0772653855';
        ld.First_Name__c = 'fName';
        ld.Last_Name__c = 'lName';
        
        insert ld;
        
    }
    
    /*
    @isTest
    static void processLeadTestMethod_withCounselor(){
        
        String uniqueUserName = 'cduser' + DateTime.now().getTime() + '@cd.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Counsellor'];
        User u = new User(Alias = 'standt', Email='counsellor@cd.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName=uniqueUserName);
            
            
            
            
            System.runAs(u) {
                
                Test.startTest();
                
                Lead__c ld = [Select Id, Name, Mobile__c, Email__c, Participated__c from Lead__c LIMIT 1];
                
                CD_ProcessLeadController ctrl = new CD_ProcessLeadController();
                PageReference pageRef = Page.processLead;
                test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('lid',ld.Id);
                System.debug('ld:::'+ld);
                ctrl.updateLeadRecord();
                
                ctrl.showError = false;
                ctrl.showSuccess = false;
                ctrl.errorMsg = '';
                ctrl.email = 'test@test1.com';
                ctrl.phoneNumber = '0772653856';
                
                ctrl.saveLead();
                ctrl.clearForm();
                ctrl.closeNotification();
                Test.stopTest();
            }
            
            
            Lead__c ldRec = [Select Id, Name, Participated__c From Lead__c LIMIT 1];
            System.debug('ldRec ::'+ldRec.Participated__c);
            System.assertEquals(ldRec.Participated__c, true);
    }
    */
    
    @isTest
    static void processLeadTestMethod_withExceptions_saveRecord(){
        
        Test.startTest();
        
        Lead__c ld = [Select Id, Name, Mobile__c, Email__c, Participated__c from Lead__c LIMIT 1];
        
        CD_ProcessLeadController ctrl = new CD_ProcessLeadController();
        PageReference pageRef = Page.processLead;
        test.setCurrentPageReference(pageRef);
        
        ctrl.showError = false;
        ctrl.showSuccess = false;
        ctrl.errorMsg = '';
        ctrl.email = 'dummy@test.com';
        ctrl.phoneNumber = '0772653856';
        
        ctrl.saveLead();
        
        Test.stopTest();
    }
    
    
    @isTest
    static void processLeadTestMethod_withExceptions_loadRecord(){
        
        Test.startTest();
        
        Lead__c ld = [Select Id, Name, Mobile__c, Email__c, Participated__c from Lead__c LIMIT 1];
        
        CD_ProcessLeadController ctrl = new CD_ProcessLeadController();
        PageReference pageRef = Page.processLead;
        test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('lid','1234');
        ctrl.updateLeadRecord();
        
        Test.stopTest();
    }
    
    @isTest
    static void processLeadTestMethod() {
        

        Test.startTest();
        
        Lead__c ld = [Select Id, Name, Mobile__c, Email__c, Participated__c from Lead__c LIMIT 1];
        
        CD_ProcessLeadController ctrl = new CD_ProcessLeadController();
        PageReference pageRef = Page.processLead;
        test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('lid',ld.Id);
        ctrl.updateLeadRecord();
        
        ctrl.showError = false;
        ctrl.showSuccess = false;
        ctrl.errorMsg = '';
        ctrl.email = 'test@test.com';
        ctrl.phoneNumber = '0772653855';
        
        ctrl.saveLead();
        ctrl.clearForm();
        ctrl.closeNotification();
        
        Test.stopTest();
        
        Lead__c ldRec = [Select Id, Name, Participated__c From Lead__c LIMIT 1];
        System.debug('ldRec ::'+ldRec.Participated__c);
        System.assertEquals(ldRec.Participated__c, true);
        
    }
    
   

}