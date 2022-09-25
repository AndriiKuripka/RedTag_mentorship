public with sharing class CaseViewController {
    @AuraEnabled(cacheable=true)
    public static List<Case> getCases(String branchNum) {
        List<Case> listCases = [
            SELECT 
                Id, 
                CaseNumber,
                Status,
                BranchNumber__c, 
                CreatedDate 
                FROM Case WHERE BranchNumber__c = :branchNum
                ORDER BY CreatedDate DESC];
        return listCases;
    }

    @AuraEnabled(cacheable=true)
    public static List<Case> getAllCases() {
        List<Case> listCases = [
            SELECT 
                Id, 
                CaseNumber,
                Status,
                BranchNumber__c, 
                CreatedDate 
                FROM Case
                ORDER BY CreatedDate DESC];
        return listCases;
    }

    @AuraEnabled(cacheable=false)
    public static void updateCase(Id caseId){
        Case caseRecord = [SELECT Id, Status FROM Case WHERE Id = :caseId];
        caseRecord.Status = 'Working';
        update caseRecord;
    }

    @AuraEnabled(cacheable=true)
    public static string getUserBranch(Id currentUserId){
        User userRecord = [SELECT Id, BranchNumber__c FROM User WHERE Id =: currentUserId];
        String userBranch = userRecord.BranchNumber__c;
        return userBranch;
    }
}
