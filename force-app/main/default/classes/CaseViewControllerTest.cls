@isTest
private with sharing class CaseViewControllerTest {
    @TestSetup
    static void makeData(){
        User u = new User(
            LastName = 'Test',
            Email = 'kuripkaa@gmail.com',
            Alias = 'Tcode',
            Username = 'kuripkaa@gmail.com',
            CommunityNickname = 'test6431',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'GMT',
            ProfileID = '00e7Q000000IiNZ',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            BranchNumber__c = '0001'
        );
        insert u;

        Case c = new Case(
            Status = 'New',
            BranchNumber__c = '0001',
            Origin = 'Web'
        );
        insert c;
    }
    @isTest
    private static void getCasesTest() {
        User u = [SELECT Id, BranchNumber__c FROM User LIMIT 1];
        List<Case> casesActual = [SELECT Id, BranchNumber__c FROM Case WHERE BranchNumber__c =: u.BranchNumber__c];
        Test.startTest();
        List<Case> casesExpected = CaseViewController.getCases(u.BranchNumber__c);
        Test.stopTest();
        System.assertEquals(casesActual.size(), casesExpected.size());
    }

    @isTest
    private static void getAllCasesTest() {
        List<Case> casesActual = [SELECT Id FROM Case];
        Test.startTest();
        List<Case> casesExpected = CaseViewController.getAllCases();
        Test.stopTest();
        System.assertEquals(casesActual.size(), casesExpected.size());
    }

    @isTest
    private static void updateCases() {
        Case caseBefore = [SELECT Id, Status FROM Case LIMIT 1];
        System.assertEquals('New', caseBefore.Status);
        Test.startTest();
        CaseViewController.updateCase(caseBefore.Id);
        Test.stopTest();
        Case caseAfter = [SELECT Id, Status FROM Case LIMIT 1];
        System.assertEquals('Working', caseAfter.Status);
    }

    @isTest
    private static void getUserBranchTest() {
        User u = [SELECT Id, BranchNumber__c FROM User LIMIT 1];
        Test.startTest();
        String branch = CaseViewController.getUserBranch(u.Id);
        Test.stopTest();
        System.assertEquals(u.BranchNumber__c, branch);
    }
}
