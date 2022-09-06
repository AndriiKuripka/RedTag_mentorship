//json to apex, create a wrapper class ++
//create seperate apex class to work with api, custom metadata + string format
//request - try catch
//wrapper should have the method to convert data to weather record ++
//salesforce limits APEX transactions ++ 100 HTTP requests
public class BatchGetWeather implements Database.Stateful, Database.Batchable<sObject>, Database.AllowsCallouts  {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT City_Name__c, Language__c FROM Weather_Setting__c');
    }

    public void execute(Database.BatchableContext bc, List<Weather_Setting__c> records){
        System.debug('execute');
        List<Weather__c> weathersToInsert = new List<Weather__c>();
        for(Weather_Setting__c setting : records){
            WeatherWrapper wr = WeatherAPIService.getWeather((Weather_Setting__c)setting);
            weathersToInsert.add(wr.parseToWeather());
        }
        insert weathersToInsert;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Records are updated');
    }
}