@RestResource(urlMapping='/RestAPI/*')
global class RestApi {
    
    private static Set<System.Type> restHandlerTypes = new Set<System.Type>{
        ContactDetailsRestHandler.class
    };
    
    private static void handleRequest(RestRequest request, RestResponse response){
        String requestHttpMethod = request.httpMethod;
        String requestUrl = request.requestURI;

        List<String> possibleHandlers = new List<String>();
        
        for(System.Type restHandlerType : restHandlerTypes){
            AbstactRestHandler restHandler = (AbstactRestHandler)restHandlerType.newInstance();
            if (restHandler != null){
                if (AbstactRestHandler.isMatch(restHandler, requestHttpMethod, requestUrl)){
                    try{
                        restHandler.execute(request, response);
                        return;
                    } catch(Exception ex){
                        AbstactRestHandler.JSONResponse(response, ex.getMessage(), 400);                        
                        return;
                    }
                }  
                String handlerEndpoint = String.format('{0} - {1}', new List<String>{
                    restHandler.getHttpMethod(),
                    restHandler.getActionName()
                });
                possibleHandlers.add(handlerEndpoint);
            }
        }
        
        String errorMessage = String.format('Method is not supported!\n\n Supported methods:\n {0}', new List<String>{
            String.join(possibleHandlers, '\n')
        });
        
        AbstactRestHandler.JSONResponse(response, errorMessage, 400);        
    }
    
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
        
        handleRequest(request, response);
    }
    
    @HttpGet
    global static void doGet() {    
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        handleRequest(request, response);
    }
}