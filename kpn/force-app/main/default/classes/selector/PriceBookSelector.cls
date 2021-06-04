public class PriceBookSelector extends fflib_SObjectSelector{
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            	PriceBookEntry.Name,
                PriceBookEntry.UnitPrice,
                PriceBookEntry.Id,
                PriceBookEntry.Product2Id
        };
    }
    
    public Schema.SObjectType getSObjectType() {
        return PriceBookEntry.sObjectType;
    }
    
    public List<PriceBookEntry> selectByIdOrderedProducts(List<Id> ids, Id priceBook2Id) {
        List<PricebookEntry> listPriceBookEntryAvaliable = new List<PricebookEntry>();
        listPriceBookEntryAvaliable.addAll(this.selectByIds(ids));
        listPriceBookEntryAvaliable.addAll(this.selectByIdsUnassociated(ids, priceBook2Id));
        return listPriceBookEntryAvaliable;
    }

    public List<PriceBookEntry> selectByIdsUnassociated(List<Id> ids, Id priceBook2Id) {
        
        fflib_QueryFactory query = newQueryFactory()
            .setCondition('Id NOT IN: ids AND Pricebook2Id =: priceBook2Id');

        return Database.query(query.toSOQL());
    }
    public List<PriceBookEntry> selectByOrderPriceBook(Id priceBook2Id) {
        
        fflib_QueryFactory query = newQueryFactory()
            .setCondition('Pricebook2Id =: priceBook2Id');

        return Database.query(query.toSOQL());
    }

    public List<PriceBookEntry> selectByIds(List<Id> idSet) {
        fflib_QueryFactory query = newQueryFactory()
            .setCondition('Id in :idSet');

        return Database.query(query.toSOQL());
    }
   
}