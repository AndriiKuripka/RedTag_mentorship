    @isTest
    private with sharing class WeatherMapControllerTest {
        @TestSetup
        private static void makeData(){
            Weather__c w = new Weather__c(
                City_Name__c = 'TestCity'
            );
            insert w;

            Weather_Setting__c ws = new Weather_Setting__c(
                City_Name__c = 'TestCity'
            );
            insert ws;
        }
    
        @isTest
        private static void getCityWeatherRecordsTest(){
            Test.startTest();
            List<Weather__c> weathers = WeatherMapController.getCityWeatherRecords('TestCity');
            Test.stopTest();
    
            System.assertEquals(1, weathers.size());
            System.assertEquals('TestCity', weathers[0].City_Name__c);
        }
    
        @isTest
        private static void getSettingsTest(){
            Test.startTest();
    
            List<Weather_Setting__c> weatherSettings = WeatherMapController.getSettings();
    
            System.assertEquals(1, weatherSettings.size());
            System.assertEquals('TestCity', weatherSettings[0].City_Name__c);
    
            Test.stopTest();
        }
    }