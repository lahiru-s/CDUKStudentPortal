/*

Created By :- Arulmozhi.R
Description:- This Class for Facebook API Test Class Mock

*/
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint and method.
        System.assertEquals('callout:Facebook_Named', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"data":[{"created_time":"2018-09-27T06:31:54+0000","id":"551098998657376","field_data":[{"name":"passport_number","values":["K4H90909"]},{"name":"last_name","values":["Johnston"]},{"name":"email","values":["Johnston\u0040gmail.com"]},{"name":"date_of_birth","values":["13/13/1993"]},{"name":"country_interested_in","values":["Australia"]},{"name":"preferred_university","values":["University of Texas"]},{"name":"phone_number","values":["+919003036399"]}]}]}');
        res.setStatusCode(200);
        return res;
    }
}