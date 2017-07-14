@isTest
private class RestApiTest {

        private static testMethod void restShouldReturnNotFoundAction() {
        
                RestRequest req = new RestRequest();
                RestResponse res = new RestResponse();
                
                req.requestURI = 'unknown';
                req.httpMethod = 'GET';
                
                RestContext.request = req;
                RestContext.response= res;
                
                RestApi.doGet();
                
                System.assertEquals(RestContext.response.statusCode, 400);
        }
        
        private static testMethod void restShouldReturnEmptyPostResponce() {
        
                RestRequest req = new RestRequest();
                RestResponse res = new RestResponse();
                
                req.requestURI = 'unknown';
                req.httpMethod = 'POST';
                
                RestContext.request = req;
                RestContext.response= res;
                
                RestApi.doPost();
                
                System.assertEquals(RestContext.response.statusCode, 400);
        }

}