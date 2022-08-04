@isTest

class OpportunityControllerTest {
    @TestSetup
    static void makeData(){
        Account acc = new Account(Name = 'Test');
        insert acc;
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer count = 0; count < 10; count++) {
            opportunities.add(new Opportunity (Name = 'Test'+count, CloseDate = Date.today(),StageName ='Prospecting', AccountId = acc.Id, Amount = count));
        }
        insert opportunities;
    }
    @isTest
    static testMethod void testOppList (){
        Id accId = [SELECT Id FROM Account LIMIT 1].Id;
        System.assertEquals (OpportunityController.findOpportunities(accId).size(), 5, 'Only top 5 opportunities');
    
}
}