public with sharing class OpportunityController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> findOpportunities(String accountId) {
        return [
            SELECT Name, StageName, CloseDate, Amount
            FROM Opportunity
            WHERE AccountId=:accountId
            AND StageName NOT IN('Closed Won','Closed Lost')
            ORDER BY Amount DESC
            LIMIT 5];
    }
}