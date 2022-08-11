@isTest
public with sharing class DeleteAllLeadsBatchTest {
    @TestSetup
    static void setup(){
        Lead[] leads = new List<Lead>();
        for(Integer i=0;i<10;i++) {
            Lead l = new Lead(FirstName='test' + i, LastName='test' + i, Company='test' + i, Rating='Cold', LeadSource='Web', Status = 'Open - Not Contacted', Email = i +'@domail.com');
            leads.add(l);
        }
        insert leads;    
    }
    @isTest static void test() {
        Test.startTest();
        DeleteAllLeadsBatchHandler.DeleteAllLeadsCallBatch();
        DeleteAllLeadsBatch del = new DeleteAllLeadsBatch();
        Id batchId = Database.executeBatch(del);
        System.assertEquals(10, [SELECT COUNT() FROM Lead where Rating = 'Cold']);
        Test.stopTest();
        System.assertEquals(0, [SELECT COUNT() FROM Lead where Rating = 'Cold']);
    }
}
