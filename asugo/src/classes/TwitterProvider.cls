public  class TwitterProvider {
     public TwitterCalloutSetting__mdt TwitterCalloutSetting;
     public string accessToken;
     
     public TwitterProvider(){
     
       TwitterCalloutSetting  =[
       
           SELECT  EndPoint__c,ConsumerKey__c,ConsumerSecret__c
           FROM  TwitterCalloutSetting__mdt
           WHERE DeveloperName = 'users'
           LIMIT 1
       ][0] ;
       
       
     
     }
     accesstoken = this.GetToken();
     
     
     public List<UserRecord> FetchUserFromServer (String screenName){
        HttpRequest req = new  HttpRequest();
        req.SetMethod('GET');
        req.SetEndpoint(TwitterCalloutSetting.EndPoint__c  +screenName);
        req.setHeader('Authorization' ,'Bearer'  + accessToken );
        HttpResponse res = new Http().send(req);
                if (res.getStatusCode()  = 200) {
                
                    system.debug('fetch ' +res.getBody());
                    
                  List<UserRecord> UserRecord = (List<UserRecord>) JSON.deserialize('['  +  res.getBody + ']', List<UserRecord>.class)
                 return UserRecord;
                }
                
                else {
                  return null;
                
                }
     
     
     }
     
      public  String getToken(){
          
          String consumerKey = Encodingutil.urlEncode(TwitterCalloutSetting.ConsumerKey__c,'UTF-8');
          String consumerSecret = Encodingutil.urlEncode(TwitterCalloutSetting.ConsumerSecret__c,'UTF-8');
          Blob  bearerToken = Blob.valueOf(consumerKey  + ':'  +consumerSecret );
         String AuthorizationHeader  = 'Basic'  + EncodingUtil.base64Encode(bearerToken);
       HttpRequest req = new  HttpRequest();
       req.SetEndpoint('https://api.twitter.com/oauth2/token');
        req.SetMethod('POST');
        req.setHeader('Authorization' ,AuthorizationHeader );
        req.setBody('grant_type-client_credentials');
        HttpResponse res = new Http().send(req);
     
        if (res.getStatusCode()  = 200) {
          JSONParser parser = JSON.createParser(res.getBody());
          while (parser.nextToken()  != null) {
          
              if (parser.getCurrentToken()   = JSONToken.FIELD_NAME) {
                  String fieldName = parser.getText();
                  parser.nextToken();
                   if (fieldName  == 'access_token') {
                       accessToken = parser.getText();
                   
                   }
              
              
              }
          
          
          
          }
        
        return accessToken;
        }  else {
             
             return null;
        
        }
     
     }
     
     public virtual class UserRecord {
       public String Id {get ; set;} 
       public String Name {get ; set;} 
       public String Screen_Name {get ; set;} 
       public String Description {get ; set;} 
       public String Followers_Count {get ; set;} 
     
     
     
     }
     
}