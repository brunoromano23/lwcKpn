public class TestDataFactory {
    public static Account createAccount() {
        Account myAccount = new Account();
        myAccount.Name = 'Account Test';
        return myAccount;
    }

    public static Product2 createProduct2() {
        return createProduct2('Teste product');
    }
    
    public static Product2 createProduct2(String name) {
        return new Product2(
            Name = name,
            isActive = true
        );
    }
    public static PricebookEntry createPricebookEntry(Id productId, Id pricebookid) {
        return new PricebookEntry(
            IsActive = true,
            Product2Id = productId,
            Pricebook2Id = pricebookid,
            UnitPrice = 10
        );
    }
    public static Id getStandardpricebookId(){
        return Test.getStandardPricebookId();
    }
    public static Order createOrder(ID accountId) {
        return new Order(
            Name = 'Order',
            AccountId = accountId,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Pricebook2Id = getStandardpricebookId()
        );
    }
    public static OrderItem createOrderItem(ID orderId, ID productId, ID pricebookEntryId) {
        return new OrderItem(
            Product2Id = productId,
            OrderId = orderId,
            UnitPrice = 1,
            PricebookEntryId = pricebookEntryId,
            Quantity = 1
        );
    }
}