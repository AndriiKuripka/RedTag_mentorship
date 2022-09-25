public class BatchGetWeather implements Database.Stateful, Database.Batchable<sObject>, Database.AllowsCallouts  {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Map<String, Schema.SObjectField> fieldMap = Weather_Setting__c.sObjectType.getDescribe().fields.getMap();
        List<String>apiNames =  new List<String>(fieldMap.keySet());
        String allString = String.join(apiNames,',');
        String query = 'SELECT ' + allstring + ' FROM Weather_Setting__c';
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
        if (weathersToInsert.size()>0){
            insert weathersToInsert;
        }
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Records are updated');
    }
}