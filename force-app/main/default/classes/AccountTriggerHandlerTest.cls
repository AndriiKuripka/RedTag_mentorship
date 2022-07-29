@isTest
private class AccountTriggerHandlerTest{
    private static final Integer ACCOUNT_NUMBER = 5;

    @TestSetup static void testSetup(){
        insert TestDataFactory.createAccounts(ACCOUNT_NUMBER);
    }

    @isTest static void testInsertOpportunity(){
        Test.startTest();
        List<Account> accounts = [SELECT Id, Name FROM Account];
        List<Opportunity> opps = [SELECT Id, Name, StageName, CloseDate, Account.Name FROM Opportunity];
		Test.stopTest(); 
        
        System.assertEquals(ACCOUNT_NUMBER, opps.size());
        System.assertEquals(opps.get(0).Name, String.format(System.Label.OppName, new List<Object>{ opps.get(0).Account.Name, Datetime.now().format(System.Label.DateFormat) }));
        System.assertEquals(opps.get(0).StageName, System.Label.OppStage);
        System.assertEquals(opps.get(0).CloseDate, Date.today().addDays(90));
    }

    @isTest static void testUpdateOpportunity(){
        Account account = [SELECT Id, Name FROM Account LIMIT 1];
        account.Name = 'UpdatedTestAccount0';

        Test.StartTest();
            update account;
        Test.StopTest();

        List<Opportunity> opps = [SELECT Id, Name, AccountId FROM Opportunity WHERE Account.Id =:account.Id];
        System.assert(opps.get(0).Name.contains(account.Name), 'Opportunity name should contain Account name');
    }

    @isTest static void testDeleteOpportunity(){
        Account account = [SELECT Id, Name FROM Account LIMIT 1];
        List<Opportunity> op = [SELECT Id, Name, Account.Name, Account.Owner.Name, Account.Owner.Email FROM Opportunity WHERE AccountId =:account.Id];

        Test.StartTest();
            delete account;
            System.assertEquals(0, [SELECT count() FROM Opportunity WHERE AccountId =:account.Id], 'Opportunity should be deleted');
            System.assertEquals(1, Limits.getEmailInvocations(), 'Email should be sent');
        Test.StopTest();

    }
}