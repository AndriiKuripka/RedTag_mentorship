@isTest
private with sharing class BatchDeleteAllLeadsTest {
    @TestSetup
    private static void setup(){
        List<Lead> leads = new List<Lead>();
        for(Integer i=0;i<10;i++) {
            Lead l = new Lead();
            l.FirstName = Label.test + i;
            l.LastName = Label.test + i;
            l.Company = Label.test + i;
            l.Rating = Label.Cold;
            l.LeadSource = Label.WebSource;
            l.Status = Label.OpenStatus;
            l.Email = i + Label.Domain;
            leads.add(l);
        }
        insert leads;    
    }
    @isTest private static void test() {
        Test.startTest();
        BatchDeleteAllLeadsController.BatchDeleteAllLeadsCall();
        Integer count10 = [SELECT COUNT() FROM Lead where Rating =: Label.Cold];
        System.assertEquals(10, count10);
        Test.stopTest();
        Integer count0 = [SELECT COUNT() FROM Lead where Rating =: Label.Cold];
        System.assertEquals(0, count0);
    }
}