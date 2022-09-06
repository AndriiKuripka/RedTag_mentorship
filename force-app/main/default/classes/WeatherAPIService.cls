public with sharing class WeatherAPIService {
    public static WeatherWrapper getWeather(Weather_Setting__c setting){
        Http httpClient = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        String url = urlReturn('Weather_API', setting);
        req.setEndpoint(url);
        HTTPResponse res = httpClient.send(req);
        WeatherWrapper wr = WeatherWrapper.parseJSON(res.getBody());
        System.debug(wr);
        return wr;
    }

    public static String urlReturn(String requestName, Weather_Setting__c setting){
        Weather_API__mdt weatherApi = [
            SELECT Id, Api_Id__c, DeveloperName, Endpoint__c, 
            (SELECT Id, Param_Name__c, Entity_Definition__r.QualifiedApiName,  Field_Definition__r.QualifiedApiName, Param_Value__c 
            FROM Weather_API_Request_Params__r) 
            FROM Weather_API__mdt
            WHERE DeveloperName =: requestName
        ];
        String returnUrlEndpoint = weatherApi.Endpoint__c;
        List<String> params = new List<String>();
        System.debug(setting);
        for (Weather_API_Request_Param__mdt param : weatherApi.Weather_API_Request_Params__r) {
            String urlParamValue = '';
            if (String.isNotBlank(param.Param_Value__c)) {
                urlParamValue = param.Param_Value__c;
            }else if (param.Entity_Definition__r.QualifiedApiName == String.valueOf(Weather_Setting__c.SObjectType)) {
                urlParamValue = (String)setting.get(param.Field_Definition__r.QualifiedApiName); 
            }
            params.add(param.Param_Name__c + '=' + urlParamValue);
        }
        returnUrlEndpoint += '?' + String.join(params,'&');
        return returnUrlEndpoint;
    }
}
/*
List<String> csvRows = new List<String>();
        SObjectType objType = Schema.getGlobalDescribe().get('Weather_Setting__c');
        Schema.DescribeSObjectResult r = objType.getDescribe();
        Map<String,Schema.SObjectField> fields = r.fields.getMap();
        for(String fieldName : r.fields.getMap().keySet()){
            Schema.DescribeFieldResult F = fields.get(fieldName).getDescribe();
            if(F.isCustom())
                csvRows.add(fieldName);
        }
        
        */