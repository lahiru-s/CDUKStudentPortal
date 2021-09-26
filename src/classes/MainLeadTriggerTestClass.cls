@isTest
public class MainLeadTriggerTestClass {
    
    /*
    @testSetup static void setupTestData() {
		
        Profile prof = [select id from profile where name = 'System Administrator'];
        User user = new User();
        user.firstName = 'tFname';
        user.lastName = 'tLName';
        user.profileId = prof.id;
        user.username = 'test@cduk.com.prod';
        user.email = 'test@cduk.com';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.Alias = 'laSubas'; 
        user.TimeZoneSidKey = 'America/Los_Angeles'; 
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey = 'en_US'; 
        insert user;
        
        system.runAs(user){
            Campaign cm = new Campaign();
            cm.name = 'Test Campaign';
            cm.StartDate = Date.parse( '12/17/2019' );
            cm.OwnerId = user.id;
            insert cm;
            
            List<Lead__c> ldList = new List<Lead__c>();
            Lead__c ld;
            ld = new Lead__c();
            ld.Email__c = 'test@test.com';
            ld.Mobile__c = '0772653855';
            ld.First_Name__c = 'fName';
            ld.Last_Name__c = 'lName';
            ld.Lead_Source__c = 'facebook';
            ld.OwnerId = user.id;
            ldList.add(ld);
            
            ld = new Lead__c();
            ld.Email__c = 'test@test.com';
            ld.Mobile__c = '0772653855';
            ld.First_Name__c = 'fName';
            ld.Last_Name__c = 'lName';
            ld.Campaign__c = cm.Id;
            ld.Lead_Source__c = 'Call';
            ld.OwnerId = user.id;
            ldList.add(ld);
            
            
            insert ldList;
        }
        
    }
	*/
    
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
        String uniqueUserName = 'cduser' + DateTime.now().getTime() + '@cd.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='counsellor@cd.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName=uniqueUserName);
        insert u;
        //System.runAs(u) {
            
            Campaign cm = new Campaign();
            cm.name = 'Test Campaign';
            cm.StartDate = Date.parse( '12/17/2019' );
            cm.OwnerId = u.id;
            insert cm;
            
            List<Lead__c> ldList = new List<Lead__c>();
            Lead__c ld;
            ld = new Lead__c();
            ld.Email__c = 'test@test.com';
            ld.Mobile__c = '0772653855';
            ld.First_Name__c = 'fName';
            ld.Last_Name__c = 'lName';
            ld.Lead_Source__c = 'facebook';
            ld.OwnerId = u.id;
            ld.Country_Interested_In__c= 'Australia';
            ld.Nearest_Branch__c = 'Colombo';
            ldList.add(ld);
            
            ld = new Lead__c();
            ld.Email__c = 'test@test.com';
            ld.Mobile__c = '0772653855';
            ld.First_Name__c = 'fName';
            ld.Last_Name__c = 'lName';
            ld.Campaign__c = cm.Id;
            ld.Lead_Source__c = 'Call';
            ld.OwnerId = u.id;
            ld.Country_Interested_In__c= 'Australia';
            ld.Nearest_Branch__c = 'Colombo';
            ldList.add(ld);
            
            
            insert ldList;
            
            
            //List<Lead__c> ld = [Select Id, Name, Mobile__c, Email__c, Participated__c from Lead__c LIMIT 2];
        //}
        
        
        
        /*
        CD_ProcessLeadController ctrl = new CD_ProcessLeadController();
        PageReference pageRef = Page.processLead;
        test.setCurrentPageReference(pageRef);
        
        ctrl.showError = false;
        ctrl.showSuccess = false;
        ctrl.errorMsg = '';
        ctrl.email = 'dummy@test.com';
        ctrl.phoneNumber = '0772653856';
        
        ctrl.saveLead();
		*/
        
        Test.stopTest();
    }
    
    

    
   

}