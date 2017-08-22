public abstract class AbstactRestHandler {
    public static final String HTTP_GET = 'GET';
    public static final String HTTP_POST = 'POST';
    
    public abstract String getActionName();
    public abstract String getHttpMethod();
    public abstract void execute(RestRequest request, RestResponse response);
    
    public static boolean isMatch(AbstactRestHandler restHandler, String httpMethod, String restUrl){
        return httpMethod != null && 
            httpMethod.equalsIgnoreCase(restHandler.getHttpMethod()) &&
            restUrl.containsIgnoreCase(restHandler.getActionName());    
     }
   

    public static void statusCodeResponse(RestResponse response, Integer statusCode){
        response.statusCode = statusCode;
    }
    
    public static void successfullyResponse(RestResponse response){        
        statusCodeResponse(response, 200);
    }

    public static void errorResponse(RestResponse response){        
        statusCodeResponse(response, 400);
    }
    
    public static void JSONResponse(RestResponse response, Object result, Integer statusCode){
        response.responseBody = blob.valueOf(JSON.serialize(result));    
        response.addHeader('Content-Type', 'application/json');
        statusCodeResponse(response, statusCode);
    }

    public static void JSONResponse(RestResponse response, Integer statusCode){        
        JSONResponse(response, null, statusCode);
    }

    public static void JSONResponse(RestResponse response, Object result){
        JSONResponse(response, result, 200);        
    }
    
    public static void handleRequest(RestRequest request, RestResponse response, Set<System.Type> restHandlerTypes){
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
    
    public class RestHandlerException extends Exception {}
}
