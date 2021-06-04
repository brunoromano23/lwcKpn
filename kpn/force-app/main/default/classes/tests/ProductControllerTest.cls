@isTest
public class ProductControllerTest {
    @TestSetup
    public static void testSetup() {
        Account account = TestDataFactory.createAccount();
        insert account;

        Product2 product = TestDataFactory.createProduct2();
        insert product;

        PricebookEntry pricebookEntry = TestDataFactory.createPricebookEntry(product.Id, TestDataFactory.getStandardpricebookId());
        insert pricebookEntry;

        Order order = TestDataFactory.createOrder(account.Id);
        order.PriceBook2Id = pricebookEntry.PriceBook2Id;
        insert order;

        OrderItem orderItem = TestDataFactory.createOrderItem(order.Id, product.Id, pricebookEntry.Id);
        insert orderItem;
    }
    @isTest
    static void getAvaliableProductsTest() {
        Order order = [Select Id From Order Limit 1];
        Test.startTest();
        BaseNotification response = ProductController.getAvaliableProducts(order.Id);
        Test.stopTest();

        System.assert(!response.success, 'Notification status was different than failure');
    }
    @isTest
    static void getOrderItemsTest() {
        Order order = [Select Id From Order Limit 1];
        Test.startTest();
        BaseNotification response = ProductController.getOrderItems(order.Id);
        Test.stopTest();

        System.assert(!response.success, 'Notification status was different than failure');
    }
    @isTest
    static void addProductsToOrderTest() {
        Order order = [Select Id From Order Limit 1];
        List<PriceBookEntry> pbs = [Select Id from PriceBookEntry];
        List<Id> ids = new List<Id>();
        for(PricebookEntry pb : pbs)
            ids.add(pb.Id);
        Test.startTest();
        BaseNotification response = ProductController.addProductsToOrder(order.Id, ids);
        Test.stopTest();

        System.assert(!response.success, 'Notification status was different than failure');
    }
    @isTest
    static void activateOrderTest() {
        Order order = [Select Id, OrderNumber, AccountId From Order Limit 1];
        Test.startTest();
        BaseNotification response = ProductController.activateOrder(order.Id);
        Test.stopTest();

        System.assert(!response.success, 'Notification status was different than failure');
    }

}
