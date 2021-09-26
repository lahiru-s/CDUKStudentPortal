/*

Created By :- Arulmozhi.R
Description:- This Class for Facebook API Class

*/
@isTest
private class FacebookAPITest {
    @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        FacebookAPI.getLeads();
        //System.assertEquals(200, res.getStatusCode());
    }
}