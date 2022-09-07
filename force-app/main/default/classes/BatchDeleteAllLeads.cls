public class BatchDeleteAllLeads implements Database.Batchable<sObject>{

	public Database.QueryLocator  start(Database.BatchableContext bc) {
		String cold = Label.Cold;
		return Database.getQueryLocator('SELECT Id FROM Lead Where Rating =: cold');
	}

	public void execute(Database.BatchableContext bc, List<Lead> records){
		delete records;
	}
	
	public void finish(Database.BatchableContext bc){
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: Label.DelLeadsTemplateName];
		email.setTemplateId(template.Id);
		email.setTargetObjectId(UserInfo.getUserId());
		email.setSaveAsActivity(false);
		Messaging.sendEmail(new List<Messaging.Email> { email });
		System.debug('Batch is done!' + UserInfo.getUserEmail());
	}
}