public class AccountSelector extends fflib_SObjectSelector{
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
                Account.Id,
                Account.Name,
                Account.AccountNumber
        };
    }
    
    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }

    public List<Account> selectById(List<Id> idSet) {
        fflib_QueryFactory query = newQueryFactory()
            .selectFields(new List<String> {'Account.Name', 'Account.AccountNumber'})
            .setCondition('Id in :idSet');

        return Database.query(query.toSOQL());
    }
}
