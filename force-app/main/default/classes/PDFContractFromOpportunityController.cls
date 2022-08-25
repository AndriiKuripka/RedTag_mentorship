public with sharing class PDFContractFromOpportunityController {
    @AuraEnabled
    public static String getStep(Id recordId){
        Opportunity opp = [SELECT Name, ContractId FROM Opportunity WHERE Id=:recordId];
        if (opp.ContractId == null) {
            return 'step1';
        }
        Contract contr = [SELECT CompanySignedId, CustomerSignedId FROM Contract WHERE Id =: opp.ContractId];
        if (contr.CustomerSignedId == null) {
            return 'step2';
        }
        if (contr.CompanySignedId == null) {
            return 'step3';
        }
        List<OpportunityLineItem> products = [SELECT Name, Quantity, TotalPrice FROM OpportunityLineItem WHERE OpportunityId=:recordId];
        if (products.isEmpty()) {
            return 'step4';
        }
        
        PageReference pdf = Page.PDFContractFromOpportunity;
        pdf.getParameters().put('id', recordId);

        Blob b;
        if(!Test.isRunningTest()){
            b = pdf.getContentAsPdf();
        }
        else{
            b = Blob.valueOf('TEST');
        }

        ContentVersion v = new ContentVersion(
            VersionData = b,
            Title = 'Contract',
            PathOnClient = 'Contract.pdf'
        );
        insert v;

        Id docId = [SELECT contentDocumentId FROM ContentVersion WHERE Id=:v.Id].contentDocumentId;

        insert new ContentDocumentLink(
            ContentDocumentId = docId,
            ShareType = 'I',
            LinkedEntityId = recordId, 
            Visibility = 'AllUsers'
        );

        return 'step5';
    }
}
