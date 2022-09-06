    @isTest
private with sharing class BatchGetWeatherTest {
    @TestSetup
    static void makeData(){
        Weather_Setting__c ws = new Weather_Setting__c(
                City_Name__c = 'Mountain View',
                Language__c = 'US'
            );
        insert ws;

        Weather__c Weather = new Weather__c(City_Name__c = 'Lviv', Name = 'Lviv Weather');
        insert Weather;
    }

    @isTest
    private static void executeBatchTest(){
        Test.setMock(HttpCalloutMock.class, new WeatherAPIServiceCalloutMock());
        System.assertEquals(null, [SELECT Temperature__c FROM Weather__c].Temperature__c, 'data has not been updated');

        Test.startTest();
        ScheduledWeatherUpdate m = new ScheduledWeatherUpdate();
        String sch = '0 0 0 ? * * 2045';
        String jobID = system.schedule('Merge Job', sch, m);
        m.execute(null);
        Test.stopTest();
        System.assertNotEquals(null, [SELECT Temperature__c FROM Weather__c].Temperature__c, 'data is updated');
    }

    @isTest
    public static void WeatherBatchTestByStaticResource() {
        System.assertEquals(null, [SELECT Temperature__c FROM Weather__c].Temperature__c, 'data has not been updated');
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetWeatherResourse');
        mock.setStatusCode(200);
        mock.setStatus('OK');
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        ScheduledWeatherUpdate m = new ScheduledWeatherUpdate();
        String sch = '0 0 0 ? * * 2045';
        String jobID = system.schedule('Merge Job', sch, m);
        m.execute(null);
        Test.stopTest();
        
        System.assertNotEquals(null, [SELECT Temperature__c FROM Weather__c].Temperature__c, 'Data was successfully updated');
    }
}
