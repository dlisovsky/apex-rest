/*
    HTTP Method: GET
    URL: [sf instance url]/services/apexrest/RestAPI/getContactDetails?id=003f000000mi2cq
    
    Response: 
    {
      "Account": {
        "Name": "Test",
        "Id": "001f000000lmoZbAAI",
        "attributes": {
          "url": "/services/data/v34.0/sobjects/Account/001f000000lmoZbAAI",
          "type": "Account"
        }
      },
      "AccountId": "001f000000lmoZbAAI",
      "LastName": "test",
      "FirstName": "test",
      "Name": "test test",
      "Id": "003f000000mi2cqAAA"
    }
*/

public with sharing class ContactDetailsRestHandler extends AbstactRestHandler {
    
    public static final String ACTION = 'getContactDetails';
    
    public override String getActionName(){
        return ACTION;    
    }
    
    public override String getHttpMethod(){
        return HTTP_GET;
    }
    
    public override void execute(RestRequest request, RestResponse response){
        String contactId = request.params.get('id');
        Contact contactVar = getContactDetails(contactId);        
        AbstactRestHandler.JSONResponse(response, contactVar);
    }
    
    private Contact getContactDetails(String contactId){
        List<Contact> contacts = [SELECT Id, Name, FirstName, LastName, Account.Id, Account.Name FROM Contact WHERE Id = :contactId LIMIT 1];
        if (contacts.isEmpty()){
            throw new RestHandlerException('Not found contact with id = ' + contactId);   
        }
        
        return contacts.get(0);
    }
}