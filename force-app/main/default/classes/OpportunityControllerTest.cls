@isTest
private class OpportunityControllerTest {
    @TestSetup
    private static void makeData(){
        Account acc = new Account(Name = 'TestAcc');
        insert acc;
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer count = 0; count < 10; count++) {
            opportunities.add(new Opportunity (Name = 'TestOpp'+count, CloseDate = Date.today(), Amount = count, StageName ='Prospecting', AccountId = acc.Id));
        }
        insert opportunities;
    }
    @isTest 
    private static void testOppList (){
        Id accId = [SELECT Id FROM Account LIMIT 1].Id;
        Test.startTest();
            List<Opportunity> testResult = OpportunityController.findOpportunities(accId, 5);
            System.assertEquals(5, testResult.size(), 'Only top 5 opportunities');
            System.assert(testResult[0].Amount >= testResult[4].Amount);
        Test.stopTest();
    }
}