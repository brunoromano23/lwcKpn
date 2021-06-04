@isTest
public class OrderSelectorTest {
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

    }
    @isTest
    public static void selectByIdTest(){
        List<Order> orders = [Select Id from Order];
        Test.startTest();
        List<Order> ordersReturned = new OrderSelector().selectById(new List<ID> { orders[0].Id });
        Test.stopTest();

        System.assert(ordersReturned.size() > 0, 'Returned list was empty');
    }
}