@isTest 
public class ProductClientTest {
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
    public static void sendOrderToExternalTest(){
        Order order = [Select Id From Order Limit 1];
        List<Order> orders = new OrderSelector().selectById(new List<Id>{order.Id});
        List<OrderItem> orderItems = new OrderItemSelector().selectByOrderId(new List<Id>{order.Id});

        OrderExternal orderExternal = new OrderExternal(orders[0], orderItems);
        
        Test.setMock(HttpCalloutMock.class, new BaseSuccessFacadeMock(orderExternal));
        Test.startTest();
        String jsonBody = JSON.serialize(orderExternal);
        HttpResponse response = ProductClient.sendOrderToExternal(jsonBody);

        Test.stopTest();
        
        System.assertEquals(200, response.getStatusCode(), 'Request status code different then 200');
    }
}