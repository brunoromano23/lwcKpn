@isTest
public class ProductServiceTest {
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
    public static void getAvaliableProductsTest(){
        Order order = [Select Id From Order Limit 1];
        Test.startTest();
        List<PricebookEntry> prds = ProductService.getAvaliableProducts(order.Id);
        Test.stopTest();
        System.assert(prds.size() > 0, 'Returned list was empty');
    }
    @isTest
    public static void activateOrderTest(){
        Order order = [Select Id, OrderNumber, AccountId From Order Limit 1];
        Test.startTest();
        String returnedValue = ProductService.activateOrder(order.Id);
        Test.stopTest();
        Order orderActivated = [Select Id, Status From Order Where Id =: order.Id Limit 1];
        System.assert(orderActivated.Status == 'Activated');
    }
    @isTest
    public static void getOrderItemsTest(){
        Order order = [Select Id From Order Limit 1];
        Test.startTest();
        List<OrderItem> orderItems = ProductService.getOrderItems(order.Id);
        Test.stopTest();
        System.assert(orderItems.size() > 0, 'Returned list was empty');
    }
    @isTest
    public static void addProductsToOrderTest(){
        List<Order> orders = [Select Id from Order];
        List<PriceBookEntry> pbs = [Select Id from PriceBookEntry];
        List<Id> ids = new List<Id>();
        for(PricebookEntry pb : pbs)
            ids.add(pb.Id);
        Test.startTest();
        ProductService.addProductsToOrder(orders[0].Id, ids);
        Test.stopTest();
        List<OrderItem> orderItems = [Select Id From OrderItem Where OrderId =: orders[0].Id]; 
        system.assert(orderItems.size() > 0);
    }
}