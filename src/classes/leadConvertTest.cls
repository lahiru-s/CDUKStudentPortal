/*

Created By :- Arulmozhi.R
Description:- Test Class for LeadConvert Trigger

*/
@isTest
private class leadConvertTest  {
    @isTest static void TestLeadConvertToAccount() {
        
        University__c univ = new University__c();
        univ.name = 'cambridge';
        univ.IsReady__c = true;
        univ.Currency_Type__c	= 'AFN';
        INSERT univ;
        
        Lead__c lead = new Lead__c();
        lead.name = 'Test';
        lead.Last_Name__c = 'last test';
        lead.Middle_Names__c = 's';
        lead.Gender__c = 'male';
        lead.Mobile__c = '9087967543';
        lead.Email__c = 's23@gmail.com';
        lead.Marital_Status__c = 'Single';
        lead.DOB__c = date.today();
        lead.City__c  = 'banglore';
        lead.Passport_Number__c = '234567';
        lead.Interested_Field_of_Study__c = 'saleads';
        lead.Preferred_University__c = univ.id;
        lead.Country_Interested_In__c = 'UK';
        lead.Expected_Year_to_Begin__c = '2018';
        lead.Address_Line_1__c = 'Banglore';
        lead.City_p__c = 'Chennai';
        lead.Country_p__c = 'india';
        lead.Postal_Zip_Code_p__c = '560087';
        lead.lead_Status__c = 'New';
        lead.Address_Line_2__c = 'Japan';
        lead.Current_Qualification__c = 'Undergraduate';
        INSERT lead;
        
        lead.lead_Status__c = 'Qualified';
        UPDATE lead;
    }
}