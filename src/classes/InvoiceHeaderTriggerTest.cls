/*

Created By :- Arulmozhi.R
Description:- Test Class for Invoice Trigger which Creates Invoice Items as many Applications

*/

@isTest
public class InvoiceHeaderTriggerTest {  
    
    /* To get University Invoice Record Type */
    public Static Id universityRecordTypeId = Schema.SObjectType.Invoice_Header__c.getRecordTypeInfosByName().get('University Invoice').getRecordTypeId();
    
    @isTest static void insertRecords() {
        
        University__c   univ = new University__c(Name ='University',DoPaymentAfterVisa__c = True,IsReady__c = True,Currency_Type__c	= 'AFN'
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
        
        Application__c app = new Application__c(Student__c = acc.Id,Preferred_University__c = univ.Id,Status__c = 'Visa Granted',Offer_Type__C = 'Unconditional'
                                                ,Course_Name__c = 'MCA',Full_Course_fees_Annual__c = 280000,Scholarship__c = 10000
                                                ,Total_Amount_paid__c = 10000,Total_Tuition_Fee__c	= 50000,Initial_Pre_Paid_Tuition_Fee__c	 = 5000,Other_Pre_Paid_Non_Tuition_Fee__c = 20000
                                                ,Accepted_date__c = date.parse('09/07/2018'),Orientation_date__c	= date.parse('09/07/2019'),Student_ID__c = '001'
                                                ,Program_Start_date__c = date.parse('09/07/2018'),Program_end_date__c = date.parse('09/07/2018'));
        Insert app;        
        
        List<Invoice_Header__c> invHead = new List<Invoice_Header__c>();
        for (Integer i = 1; i <= 1000; i++) {
            invHead.add(new Invoice_Header__c(University__c = univ.Id,Name_of_Company__c = 'Campus Direct UK(Pvt)Ltd',Currency_Type__c	= 'AED'
                                              ,Start_Date__c = date.parse('09/07/2018'),End_Date__c = date.parse('09/07/2018'),RecordTypeId = universityRecordTypeId));
        }
        Test.startTest();
        Insert invHead;
        Test.stopTest();
    } 
    
    @isTest static void insertRecords_Two() {
        University__c   univ = new University__c(Name ='University',DoPaymentAfterVisa__c = True,IsReady__c = True,Currency_Type__c	= 'AFN'
                                                 ,Commision_Rate_Type__c = 'Per Student',Commision_Rate_Year_01__c = 100,Bonus_Amount__c = 1000,Bonus_Amount_2__c = 2000
                                                 ,Number_of_Students_Per_the_Bonus_Amount__c = 1,Bonus_Description_1__c = 'Per Head Bonus (PHB)'
                                                 ,Number_of_Students_Per_Bonus_Amount_2__c = 1,Bonus_Description_2__c = 'Per Head Bonus (PHB)');       
        Insert univ;        
        
        Account acc = new Account(Name ='Student ', Last_Name__c = 'Last',Email__c = 'Example@gmail.com',
                                  Mobile__c = '9003036399',Gender__c = 'Female',Marital_Status__c = 'Single',Date_of_Birth__c = date.parse('09/07/1985'),
                                  City__c = 'Los Angeles',Country_Interested_In__c = 'Australia',Interested_Field_of_Study__c = 'Aeronautics',
                                  Address_Line_1__c = '7885 Mockingbird Hill',PersonalCity__c = 'Oakland',PermanentCountry__c = 'United States',PermanentPostalZipCode__c = 'E4T H6T',
                                  Sic = '2019',Preferred_University__c = univ.Id);        
        Insert acc;               
        
        Application__c app = new Application__c(Student__c = acc.Id,Preferred_University__c = univ.Id,Status__c = 'Visa Granted',Offer_Type__C = 'Unconditional'
                                                ,Course_Name__c = 'MCA',Full_Course_fees_Annual__c = 280000,Scholarship__c = 10000
                                                ,Total_Amount_paid__c = 10000,Total_Tuition_Fee__c	= 50000,Initial_Pre_Paid_Tuition_Fee__c	 = 5000,Other_Pre_Paid_Non_Tuition_Fee__c = 20000
                                                ,Accepted_date__c = date.parse('09/07/2018'),Orientation_date__c	= date.parse('09/07/2019'),Student_ID__c = '001'
                                                ,Program_Start_date__c = date.parse('09/07/2018'),Program_end_date__c = date.parse('09/07/2018'));
        Insert app;        
        
        List<Invoice_Header__c> invHead = new List<Invoice_Header__c>();
        for (Integer i = 1; i <= 1000; i++) {
            invHead.add(new Invoice_Header__c(University__c = univ.Id,Name_of_Company__c = 'Campus Direct UK(Pvt)Ltd',Currency_Type__c	= 'AED'                                             
                                              ,Start_Date__c = date.parse('09/07/2018'),End_Date__c = date.parse('09/07/2018'),RecordTypeId = universityRecordTypeId));
        }
        Test.startTest();
        Insert invHead;
        Test.stopTest();      
        
    }    
    
    
}