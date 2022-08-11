public class DeleteAllLeadsBatch implements Database.Batchable<sObject>{
    
    public Database.QueryLocator  start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Lead Where Rating = \'Cold\'');
    }

    public void execute(Database.BatchableContext bc, List<Lead> records){
        delete records;
    }
    
    public void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId('00X7Q000000E5T7');
        email.setTargetObjectId(UserInfo.getUserId());
        email.setSaveAsActivity(false);
        Messaging.sendEmail(new List<Messaging.Email> { email });
        System.debug('Batch is done!' + UserInfo.getUserEmail());
    }
}