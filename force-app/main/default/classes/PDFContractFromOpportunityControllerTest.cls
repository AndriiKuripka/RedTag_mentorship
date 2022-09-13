@isTest
private class PDFContractFromOpportunityControllerTest {
   @TestSetup
    private static void makeData(){
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
            EmailEncodingKey = 'UTF-8'
        );
        insert u;

        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < 1; i++){
            contacts.add(new Contact(
                LastName = 'test' + ' ' + i
            ));
        }
        insert contacts;

        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 1; i++){
            accounts.add(new Account(
                Name = 'test' + ' ' + i,
                Rating = 'Prospecting'
            ));
        }
        insert accounts;

        Contract contr = new Contract(
            AccountId = accounts[0].Id,
            Status = 'Draft',
            StartDate = System.today(),
            CompanySignedId = contacts[0].Id,
            CustomerSignedId = u.Id
        );
        insert contr;

        Product2 product = new Product2(
            Name = 'oppName'
        );
        insert product;

        Pricebook2 pricebook = new Pricebook2(
            Name = 'Test Pricebook',
            IsActive = true
        );
        insert pricebook;

        PricebookEntry price = new PricebookEntry(
            Pricebook2Id = pricebook.Id, 
            Product2Id = product.Id,
            UnitPrice = 10000,
            IsActive = true
        );
        insert price;

        Opportunity opp = new Opportunity(
            Name = 'TestOpp',
            StageName = 'Prospecting',
            CloseDate = System.today().addMonths(1),
            ContractId = contr.Id,
            Pricebook2Id = pricebook.Id
        );
        insert opp;

        OpportunityLineItem oppProduct = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Product2Id = product.Id,
            Quantity = 5,
            UnitPrice = 10,
            PricebookEntryId = price.Id
        );
        insert oppProduct;

    }
    @isTest

    private static void createPDFControllerTest(){
        Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name LIKE 'Test' LIMIT 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        PDFContractFromOpportunityController pdfController = new PDFContractFromOpportunityController(sc);
        System.assertEquals(pdfController.opp.Id, opp.Id);
    }
    @isTest
    private static void generatePDFTest(){
        Id docId = PDFContractFromOpportunityController.getStep(opp.Id);
        System.assertEquals(docId, [SELECT contentDocumentId FROM ContentVersion LIMIT 1].contentDocumentId);
    }
}