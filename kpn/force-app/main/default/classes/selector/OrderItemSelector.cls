public class OrderItemSelector extends fflib_SObjectSelector{
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
                OrderItem.Quantity,
                OrderItem.UnitPrice,
                OrderItem.TotalPrice,
                OrderItem.Id,
                OrderItem.Product2Id,
                OrderItem.OrderId,
                OrderItem.PriceBookEntryId,
                OrderItem.PricebookEntry.Product2Id
        };
    }
    
    public Schema.SObjectType getSObjectType() {
        return OrderItem.sObjectType;
    }

    public List<OrderItem> selectByOrderId(List<Id> idSet) {
        fflib_QueryFactory query = newQueryFactory()
            .selectFields(new List<String> {'PricebookEntry.Product2.Name', 'PricebookEntry.Product2.ProductCode'})
            .setCondition('OrderId in :idSet');
        
        new PriceBookSelector().configureQueryFactoryFields(query, 'PricebookEntry');

        return Database.query(query.toSOQL());
    }
    public List<OrderItem> selectByPbIdsAndOrderId(List<Id> idOrderSet, List<Id> ids) {
        fflib_QueryFactory query = newQueryFactory()
            .setCondition('OrderId in :idOrderSet AND PriceBookEntryId in :ids');

        return Database.query(query.toSOQL());
    }
}