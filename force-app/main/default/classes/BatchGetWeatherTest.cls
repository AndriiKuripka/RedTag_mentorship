@isTest
private with sharing class BatchGetWeatherTest {
    @TestSetup
    static void makeData(){
        Weather_Setting__c ws = new Weather_Setting__c(
                City_Name__c = 'Osaka',
                Language__c = 'EN'
            );
        insert ws;

        Weather_Setting__c errorCity = new Weather_Setting__c(
                City_Name__c = 'eror404',
                Language__c = 'UA'
            );
        insert errorCity;
    }

   @isTest
    private static void executeBatchTestNegative(){
        WeatherAPIServiceCalloutMock mock = new WeatherAPIServiceCalloutMock(true);
        mock.setBody('{"cod":"404","message":"city not found"}');
        mock.setStatusCode(404);
        mock.setStatus('city not found');
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
       
        Integer num = [SELECT count() FROM Weather__c];
        System.assertEquals(0, num, 'data has not been updated');        
        Test.startTest();
        ScheduledWeatherUpdate scw = new ScheduledWeatherUpdate();
        scw.execute(null);
        Test.stopTest();
        num = [SELECT count() FROM Weather__c];
        System.assertEquals(0, num, 'data has not been updated');
        
    }

  @isTest
    public static void executeBatchTest() {
        Integer num = [SELECT count() FROM Weather__c];
        System.assertEquals(0, num, 'data has not been updated'); 
        
        WeatherAPIServiceCalloutMock mock = new WeatherAPIServiceCalloutMock(false);
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'GetWeatherResourse' LIMIT 1];
        mock.setBody(sr.Body.ToString());
        mock.setStatusCode(200);
        mock.setStatus('OK');
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        ScheduledWeatherUpdate m = new ScheduledWeatherUpdate();
        m.execute(null);
        Test.stopTest();
        
        num = [SELECT count() FROM Weather__c];
        System.assertNotEquals(0, num, 'Data was successfully updated');
    }
}