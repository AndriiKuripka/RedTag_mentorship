public class BatchDeleteAllLeadsController  {

    @AuraEnabled
    public static void BatchDeleteAllLeadsCall(){
        BatchDeleteAllLeads myBatchObject = new BatchDeleteAllLeads();
        Id batchId = Database.executeBatch(myBatchObject);
        System.debug(batchId);
    }

}