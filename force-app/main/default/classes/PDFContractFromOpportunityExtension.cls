public with sharing class PDFContractFromOpportunityExtension {
    public Contract contr {get;set;}
    public String firstPdfPageFormated {get;set;}
    public String sellerCompanyName {get;set;}
    public String customerName {get;set;}
    public List<OpportunityLineItem> products {get;set;}

    public PDFContractFromOpportunityExtension(ApexPages.StandardController stdController){
        Opportunity record = (Opportunity)stdController.getRecord();
        Opportunity opp = [SELECT Id, ContractId FROM Opportunity WHERE Id=:record.Id];
        contr = [SELECT CompanySignedId, CustomerSignedId FROM Contract WHERE Id =: opp.ContractId];
        customerName = [SELECT Name FROM Contact WHERE Id=:contr.CustomerSignedId LIMIT 1].Name;
        sellerCompanyName = [SELECT Name FROM User WHERE Id=:contr.CompanySignedId LIMIT 1].Name;
        products = [SELECT Name, Quantity, TotalPrice FROM OpportunityLineItem WHERE OpportunityId=:opp.Id];
        firstPdfPageFormated = System.Label.FirstPdfPage.replace('{customer}',customerName).replace('{seller company}',sellerCompanyName);
    }
    
    
}
