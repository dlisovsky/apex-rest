@RestResource(urlMapping='/RestAPI/*')
global class RestApi {
    
    private static Set<System.Type> restHandlerTypes = new Set<System.Type>{
        ContactDetailsRestHandler.class
    };
    
    @httpPost
    global static void doPost(){
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        if (request.requestBody == null || String.isEmpty(request.requestBody.toString())){
            response.statusCode = 400;
            response.responseBody = Blob.valueOf('Empty request');
            response.addHeader('Content-Type', 'application/json'); 
            return;
        }
        
        AbstactRestHandler.handleRequest(request, response, restHandlerTypes);
    }
    
    @HttpGet
    global static void doGet() {    
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        AbstactRestHandler.handleRequest(request, response, restHandlerTypes);
    }
}
