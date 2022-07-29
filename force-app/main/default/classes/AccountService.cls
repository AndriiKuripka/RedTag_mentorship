public with sharing class AccountService {
    public static void insertOpportunities(List<Account> newAccountList) {
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        for (Account acc: newAccountList){
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.Id;
            opp.Name = String.format(System.Label.OppName, new List<Object>{ acc.Name, acc.CreatedDate.format(System.Label.DateFormat) });
            opp.StageName = System.Label.OppStage;
            opp.CloseDate = Date.today().addDays(90);
            oppsToInsert.add(opp);
        }
        insert oppsToInsert;
    }
    
    public static void updateOpportunities(List<Account> newAccountList, Map<Id, Account> mapOldAccounts) {
        Map<Id, String> mapUpdatedAccName = new Map<Id,String>();
        for (Account acc : newAccountList) {
            if (acc.Name != mapOldAccounts.get(acc.Id).Name) {
                mapUpdatedAccName.put(acc.Id, String.format(System.Label.OppName, new List<Object>{ acc.Name, acc.CreatedDate.format(System.Label.DateFormat) }));    
            }
        }
        List<Opportunity> oppsToUpdate = [SELECT Id, Name, AccountId, CreatedDate FROM Opportunity WHERE AccountId IN: mapUpdatedAccName.keySet()];
        for (Opportunity opp : oppsToUpdate) {
            opp.Name = mapUpdatedAccName.get(opp.AccountId);
        }
        update oppsToUpdate;
    }

    public static void deleteOpportunities(List<Account> listOldAccounts) {
        List<Opportunity> oppsToDelete = [SELECT Id, Name, Amount, Account.Owner.FirstName, Account.Owner.Email FROM Opportunity WHERE AccountId IN: listOldAccounts];
        Map<Id,User> mapOwners= new Map<Id,User>();
        Map<Id,List<String>> allOppsForEachAcc = new Map<Id,List<String>>();
        for (Opportunity opp : oppsToDelete) {
            if (!mapOwners.containsKey(opp.AccountId)) {
                mapOwners.put(opp.AccountId, opp.Account.Owner);
            }
            if (!allOppsForEachAcc.containsKey(opp.AccountId)) {
                allOppsForEachAcc.put(opp.AccountId, new List<String>());
            }
            allOppsForEachAcc.get(opp.AccountId).add(
                String.format(System.Label.AllOpps, new List<Object>{(allOppsForEachAcc.get(opp.AccountId).size() + 1) , opp.Id, opp.Name, opp.Amount }));  
        }

        List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemplate = [SELECT Id, Subject, Body FROM EmailTemplate WHERE DeveloperName = 'AccountDeletedEmailTemplate'];
        for (Account acc : listOldAccounts) {
            String[] toEmails = new String[] {mapOwners.get(acc.Id).Email}; 
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{OwnerName}', mapOwners.get(acc.Id).FirstName);
            plainBody = plainBody.replace('{AccName}', acc.Name);
            plainBody = plainBody.replace('{AllOpps}', String.join(allOppsForEachAcc.get(acc.Id), '\n'));
            email.setToAddresses(toEmails);
            email.setSubject(emailTemplate.Subject);
            email.setPlainTextBody(plainBody);
            mailsToSend.add(email);
        }
        Messaging.sendEmail(mailsToSend);
        delete oppsToDelete;
    }

}
