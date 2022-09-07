    @isTest
private with sharing class BatchGetWeatherTest {
    @TestSetup
    static void makeData(){
        Weather_Setting__c ws = new Weather_Setting__c(
                City_Name__c = 'Osaka',
                Language__c = 'EN'
            );
        insert ws;
    }

    @isTest
    private static void executeBatchTest(){
        Test.setMock(HttpCalloutMock.class, new WeatherAPIServiceCalloutMock());

        Integer num = [SELECT count() FROM Weather__c];
        System.assertEquals(0, num, 'data has not been updated');        
        Test.startTest();
        ScheduledWeatherUpdate scw = new ScheduledWeatherUpdate();
        scw.execute(null);
        Test.stopTest();

        num = [SELECT count() FROM Weather__c];
        System.assertNotEquals(0, num, 'Data was successfully updated');
    }

   @isTest
    public static void weatherBatchTestByStaticResource() {
        Integer num = [SELECT count() FROM Weather__c];
        System.assertEquals(0, num, 'data has not been updated'); 
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetWeatherResourse');
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
