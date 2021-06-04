public class OrderSelector extends fflib_SObjectSelector{
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
                Order.Id,
                Order.PriceBook2Id,
                Order.Status,
                Order.AccountId,
                Order.Type,
                Order.OrderNumber
        };
    }
    
    public Schema.SObjectType getSObjectType() {
        return Order.sObjectType;
    }

    public List<Order> selectById(List<Id> idSet) {
        fflib_QueryFactory query = newQueryFactory()
            .setCondition('Id in :idSet');

        new AccountSelector().configureQueryFactoryFields(query, 'Account');


        return Database.query(query.toSOQL());
    }
}