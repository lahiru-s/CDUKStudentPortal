@isTest
public class DOBFormatTest {
    static testMethod void MyTest()
    {
        List<Lead> lead = new List<Lead>();
        for (Integer i = 0; i < 1000; i++) {
            lead.add(new Lead(Company = 'Test Lead',
                              LastName = 'Lead Last Name',
                              Date_of_Birth__c = '09/05/1991',
                             Email='abctestOnly@gmail.com',
                             Current_City__c='TestCity',
                             Gender__c='Male',
                             Interested_Field_of_Study__c='TestField',
                             Lead_Type__c='New Student',
                             MobilePhone = '0711111111'));
            
            
        }
        INSERT lead;
    }
}