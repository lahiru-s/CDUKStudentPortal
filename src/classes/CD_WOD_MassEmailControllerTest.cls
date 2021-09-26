@isTest
public class CD_WOD_MassEmailControllerTest 
{
    @testSetup
    public static void setup(){
        University__c   univ = new University__c(Name ='University 1',DoPaymentAfterVisa__c = True,IsReady__c = True,Currency_Type__c	= 'AFN'
                                                 ,Commision_Rate_Type__c = 'Percentage',Commision_Rate_Year_01__c = 100,Bonus_Amount__c = 1000,Bonus_Amount_2__c = 2000
                                                 ,Number_of_Students_Per_the_Bonus_Amount__c = 1,Bonus_Description_1__c = 'Per Head Bonus (PHB)'
                                                 ,Number_of_Students_Per_Bonus_Amount_2__c = 1,Bonus_Description_2__c = 'Per Head Bonus (PHB)');       
        Insert univ;        
        
        Account acc = new Account(Name ='Student ', Last_Name__c = 'Last',Email__c = 'Example@gmail.com',
                                  Mobile__c = '9003036399',Gender__c = 'Female',Marital_Status__c = 'Single',Date_of_Birth__c = date.parse('09/07/1985'),
                                  City__c = 'Los Angeles',Country_Interested_In__c = 'Australia',Interested_Field_of_Study__c = 'Aeronautics',
                                  Address_Line_1__c = '7885 Mockingbird Hill',PersonalCity__c = 'Oakland',PermanentCountry__c = 'United States',PermanentPostalZipCode__c = 'E4T H6T',
                                  Sic = '2019',Preferred_University__c = univ.Id);        
        Insert acc;
        
        Campaign cmp = new Campaign();
        cmp.Name = 'Test Campaign';
        cmp.StartDate = Date.valueOf('2020-08-20');
        insert cmp;
        
        Lead__c L = new Lead__c();
        l.name = 'Test';
        l.Last_Name__c = 'Last test';
        l.Email__c  = 's23@gmail.com';
        l.Mobile__c = '9087967543';
        l.Web_Lead_Subject__c = 'Test Subject';
        l.Web_Lead_Message__c = 'Test Message';
        l.Preferred_University__c = null;
        l.Lead_Source__c = 'Friend';
        l.Campaign_Email_Triggered__c = true;
        l.Campaign__c = cmp.Id;
        INSERT l;       
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Sample PDF';
        cv.ContentUrl = 'google.com/item';
        insert cv; 
        
        Mass_Email_Addresses__c me = new Mass_Email_Addresses__c();
        me.Name = CD_WOD_MassEmail_Util.CD_FROM_EMAIL_HELLO;
        me.Email_Value__c = 'suresh@cduk.lk';
        insert me;
        
        System.runAs (new User(Id = UserInfo.getUserId()) ){
            EmailTemplate validEmailTemplate = new EmailTemplate();
            validEmailTemplate.isActive = true;
            validEmailTemplate.Name = 'Test Template';
            validEmailTemplate.DeveloperName = 'sample_template_for_testing';
            validEmailTemplate.TemplateType = 'custom';
            validEmailTemplate.FolderId = UserInfo.getUserId();     
            validEmailTemplate.HtmlValue = '{!Lead__c.Name} - {!Account.Name} - {!Campaign.Name}';
            validEmailTemplate.Subject = 'Test Subject';
            insert validEmailTemplate;
        }
        
    }
    
    @isTest
    public static void TestMethod_Success(){
        test.startTest();
        List<CD_WOD_MassEmailController.CampaignWrapper> cwrap = CD_WOD_MassEmailController.getCampaignList();
        List<EmailTemplate> templates = CD_WOD_MassEmailController.getEmailTemplates();
        
        List<Campaign> camps = [SELECT id FROM Campaign];
        CD_WOD_MassEmailController.JobFeedback feedback = CD_WOD_MassEmailController.sendCampaignReminders(camps.get(0).Id, '2020-09-12T18:13:41Z');
        
        //negative
        CD_WOD_MassEmailController.JobFeedback feedback_exp = CD_WOD_MassEmailController.sendCampaignReminders(camps.get(0).Id, null);
        
        List<ContentVersion> files =  CD_WOD_MassEmailController.getExistingFiles();
        test.stopTest();
    }
    
    @isTest
    public static void TestMethod_Schedule(){
        test.startTest();        
        List<Campaign> camps = [SELECT id FROM Campaign];
        String cron_trigger =  CD_WOD_MassEmail_Util.getCronTrigger('2020-09-12T18:13:41Z');           
        CD_WOD_SendCampaignReminder massEmail = new CD_WOD_SendCampaignReminder();   
        massEmail.campaignId = camps.get(0).Id;
        String returnString = system.schedule('Mass Email Reminder - ' + camps.get(0).Id, cron_trigger, massEmail);        
        test.stopTest();
    } 
    
    @isTest
    public static void TestMethod_SendNewsLetter(){
        test.startTest();
        List<Campaign> camps = [SELECT id FROM Campaign];
        List<Account> accs = [SELECT id FROM Account];
        List<Lead__c> leads = [SELECT id FROM Lead__c];
        List<EmailTemplate> template = [SELECT Id,DeveloperName,FolderId FROM EmailTemplate WHERE Name = 'Test Template'];
        system.debug('template info ::: '+template.get(0).DeveloperName+' : '+template.get(0).FolderId);
        CD_WOD_MassEmailController.JobFeedback feedback_account = CD_WOD_MassEmailController.sendNewsLetters(template.get(0).Id, '2020-09-12T18:13:41Z',accs.get(0).Id,'0');
        CD_WOD_MassEmailController.JobFeedback feedback_leads = CD_WOD_MassEmailController.sendNewsLetters(template.get(0).Id, '2020-09-12T18:13:41Z',leads.get(0).Id,'0');
        
        //Negative
        CD_WOD_MassEmailController.JobFeedback feedback_exp = CD_WOD_MassEmailController.sendNewsLetters(template.get(0).Id, '2020-09-12T18:13:41Z',null,'0');
        test.stopTest();
    }
    
    @isTest
    public static void TestMethod_SendEventReminder(){
        test.startTest();
        List<Campaign> camps = [SELECT id FROM Campaign];
        List<Account> accs = [SELECT id FROM Account];
        List<Lead__c> leads = [SELECT id FROM Lead__c];
        List<EmailTemplate> template = [SELECT Id FROM EmailTemplate WHERE Name = 'Test Template'];
        CD_WOD_MassEmailController.JobFeedback feedback_account = CD_WOD_MassEmailController.sendEventReminders(template.get(0).Id, '2020-09-12T18:13:41Z',accs.get(0).Id,camps.get(0).id);
        CD_WOD_MassEmailController.JobFeedback feedback_leads = CD_WOD_MassEmailController.sendEventReminders(template.get(0).Id, '2020-09-12T18:13:41Z',leads.get(0).Id,camps.get(0).id);
        
        //Negative
        CD_WOD_MassEmailController.JobFeedback feedback_exp = CD_WOD_MassEmailController.sendEventReminders(template.get(0).Id, '2020-09-12T18:13:41Z',null,camps.get(0).id);
        test.stopTest();
    }
    
    @istest
    public static void TestMethod_VCF_ProcessLeadRecords(){
        test.startTest();
        List<Lead__c> leads = [SELECT id FROM Lead__c];
        ApexPages.StandardSetController std = new ApexPages.StandardSetController(leads);
        VCF_ProcessLeadRecords vcf = new VCF_ProcessLeadRecords(std);
        
        PageReference pg = vcf.redirectToLC();
        test.stopTest();
    }
    
    @istest
    public static void TestMethod_VCF_ProcessAccRecords(){
        test.startTest();
        List<Account> accs = [SELECT id FROM Account];
        ApexPages.StandardSetController std_acc = new ApexPages.StandardSetController(accs);
        VFC_ProcessAccRecords vcf = new VFC_ProcessAccRecords(std_acc);
        
        PageReference pg = vcf.redirectToLC();
        test.stopTest();
    }
}