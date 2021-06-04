@isTest
public class PriceBookSelectorTest {
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
    public static void selectByIdOrderedProductsTest(){
        List<PricebookEntry> listPbs = [Select Id, pricebook2Id from PriceBookEntry];
        List<Order> orders = [Select Id, Pricebook2Id from Order];
        List<Id> ids = new List<Id>();
        for(PricebookEntry pb : listPbs)
            ids.add(pb.Id);
        Test.startTest();
        List<PricebookEntry> pbs = new PriceBookSelector().selectByIdOrderedProducts(ids, orders[0].Pricebook2Id);
        Test.stopTest();
        
        System.assert(pbs.size() > 0, 'Returned list was empty');
    }
 
    @isTest
    public static void selectByOrderPriceBookTest(){
        List<Order> orders = [Select Id, Pricebook2Id from Order];
        Test.startTest();
        List<PricebookEntry> pbs = new PriceBookSelector().selectByOrderPriceBook(orders[0].Pricebook2Id);
        Test.stopTest();
        
        System.assert(pbs.size() > 0, 'Returned list was empty');
    }
    @isTest
    public static void selectByIdsTest(){
        List<PricebookEntry> listPbs = [Select Id from PriceBookEntry];
        List<Id> ids = new List<Id>();
        for(PricebookEntry pb : listPbs)
            ids.add(pb.Id);
        Test.startTest();
        List<PricebookEntry> pbs = new PriceBookSelector().selectByIds(ids);
        Test.stopTest();
        
        System.assert(pbs.size() > 0, 'Returned list was empty');
    }
}