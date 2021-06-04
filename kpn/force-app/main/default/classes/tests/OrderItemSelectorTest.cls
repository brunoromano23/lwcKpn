@isTest
public class OrderItemSelectorTest {
    @TestSetup
    public static void testSetup() {
        Account account = TestDataFactory.createAccount();
        insert account;

        Product2 product = TestDataFactory.createProduct2();
        insert product;

        PricebookEntry pricebookEntry = TestDataFactory.createPricebookEntry(product.Id, TestDataFactory.getStandardpricebookId());
        insert pricebookEntry;

        Order order = TestDataFactory.createOrder(account.Id);
        insert order;

        OrderItem orderItem = TestDataFactory.createOrderItem(order.Id, product.Id, pricebookEntry.Id);
        insert orderItem;
    }
    @isTest
    public static void selectByOrderIdTest(){
        List<Order> orders = [Select Id from Order];
        Test.startTest();
        List<OrderItem> orderItems = new OrderItemSelector().selectByOrderId(new List<ID> { orders[0].Id });
        Test.stopTest();

        System.assert(orderItems.size() > 0, 'Returned list was empty');
    }
    @isTest
    public static void selectByPbIdsAndOrderIdTest(){
        List<Order> orders = [Select Id from Order];
        List<PriceBookEntry> pbs = [Select Id from PriceBookEntry];
        List<Id> ids = new List<Id>();
        for(PricebookEntry pb : pbs)
            ids.add(pb.Id);

        Test.startTest();
        List<OrderItem> orderItems = new OrderItemSelector().selectByPbIdsAndOrderId(new List<ID> { orders[0].Id }, ids);
        Test.stopTest();

        System.assert(orderItems.size() > 0, 'Returned list was empty');
    }
}