public class DeleteAllLeadsBatchHandler  {

    @AuraEnabled
    public static void DeleteAllLeadsCallBatch(){
        DeleteAllLeadsBatch myBatchObject = new DeleteAllLeadsBatch();
        Id batchId = Database.executeBatch(myBatchObject);
        System.debug(batchId);
    }

}