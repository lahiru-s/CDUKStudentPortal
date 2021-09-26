@isTest
public class GetFacebookLeadsSchedulableTest {
    @isTest static void testFBAPI() {
        
        String CRON_EXP = '0 0 * * * ?';   
        
        Test.startTest();
        String jobId = System.schedule('GetFacebookLeadsSchedulable',
                                       CRON_EXP, 
                                       new GetFacebookLeadsSchedulable ());
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());      
        Test.stopTest();
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        //System.assertEquals('2018-11-20 18:00:00',String.valueOf(ct.NextFireTime));             
    }
}