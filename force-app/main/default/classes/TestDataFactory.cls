@isTest
public class TestDataFactory {
    public static List<Account> createAccounts(Integer numOfAccounts) {
        List<Account> testAccounts = new List<Account>();
        for (Integer i=0; i<numOfAccounts; i++) {
            Account testAccount = new Account();
            testAccount.Name = 'TestAccount' + i;
            testAccount.Description = 'Created by TestDataFactory';
            testAccounts.add(testAccount);
        }
        return testAccounts;
    }
}