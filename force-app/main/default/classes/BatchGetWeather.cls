public class BatchGetWeather implements Database.Stateful, Database.Batchable<sObject>, Database.AllowsCallouts  {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String SobjectApiName = 'Weather_Setting__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List<String>apiNames =  new List<String>();

        for(String apiName : fieldMap.keyset()) {
           if(fieldMap.get(apiName).getDescribe().isCustom()) {
              apiNames.add(apiName);
           }
        }
        String allString = String.join(apiNames,',');
        String query = 'SELECT ' + allstring + ' FROM ' + SobjectApiName;
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Weather_Setting__c> records){
        System.debug('execute');
        List<Weather__c> weathersToInsert = new List<Weather__c>();
        for(Weather_Setting__c setting : records){
            HttpResponse res = WeatherAPIService.getWeather((Weather_Setting__c)setting);
            if (res.getStatusCode() == 200) {
                WeatherWrapper wr = WeatherWrapper.parseJSON(res.getBody());
                weathersToInsert.add(wr.parseToWeather());
            }
        }
        insert weathersToInsert;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Records are updated');
    }
}