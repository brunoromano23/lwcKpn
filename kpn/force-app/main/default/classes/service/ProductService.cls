public class ProductService {
    private static PriceBookSelector priceBookSelector = new PriceBookSelector();
    private static OrderSelector orderSelector = new OrderSelector();
    private static OrderItemSelector orderItemSelector = new OrderItemSelector();

    public static List<PricebookEntry> getAvaliableProducts(Id orderId) {
        List<PriceBookEntry> priceBookEntries = new List<PricebookEntry>();
        List<Order> orders = orderSelector.selectById(new List<Id>{orderId});
        Id priceBook2Id = orders[0].Pricebook2Id;
        List<OrderItem> orderItems = orderItemSelector.selectByOrderId(new List<Id>{orderId});
        List<Id> pbIds = new List<Id>();
        for(OrderItem orderItem : orderItems)
            pbIds.add(orderItem.PriceBookEntryId);

        if(pbIds.size() > 0)
            priceBookEntries = priceBookSelector.selectByIdOrderedProducts(pbIds, priceBook2Id);
        else 
            priceBookEntries = priceBookSelector.selectByOrderPriceBook(priceBook2Id);

        return priceBookEntries;
    }
    public static List<OrderItem> getOrderItems(Id orderId) {
        List<OrderItem> orderItems = orderItemSelector.selectByOrderId(new List<Id>{orderId});
        return orderItems;
    }
    public static void addProductsToOrder(Id orderId, List<Id> idsPriceBookEntries) {
        List<OrderItem> orderItensUpsert = new List<OrderItem>();
        List<Id> idsExistingPBItens = new List<Id>();
        List<Order> order = orderSelector.selectById(new List<Id>{orderId});
        Id priceBook2Id = order[0].Pricebook2Id;
        List<OrderItem> orderItems = orderItemSelector.selectByPbIdsAndOrderId(new List<Id>{orderId}, idsPriceBookEntries);
        for(OrderItem orderItem : orderItems){
            orderItem.Quantity = orderItem.Quantity + 1;
            idsExistingPBItens.add(orderItem.PriceBookEntryId);
        }
        
        List<PriceBookEntry> priceBookEntries = priceBookSelector.selectByIds(idsPriceBookEntries);
        for(PriceBookEntry pbe : priceBookEntries){
            if(!idsExistingPBItens.contains(pbe.Id)){
                OrderItem orderItem = new OrderItem();
                orderItem.OrderId = orderId;
                orderItem.PriceBookEntryId = pbe.Id;
                orderItem.Quantity = 1;
                orderItem.UnitPrice = pbe.UnitPrice;
                orderItensUpsert.add(orderItem);
            }
        }
        
        orderItensUpsert.addAll(orderItems);

        upsert orderItensUpsert;
    }
    public static String activateOrder(Id orderId) {
        String returnedValue = '';
        List<Order> orders = orderSelector.selectById(new List<Id>{orderId});
        List<OrderItem> orderItems = getOrderItems(orderId);
        for(Order order : orders)
            order.Status = 'Activated';

        If(!Test.isRunningTest())
            returnedValue = sendToExternal(orders[0], orderItems);
            
        update orders;
        return returnedValue;
        }
    private static String sendToExternal(Order order, List<OrderItem> orderItems)
    {
        OrderExternal orderExternal = new OrderExternal(order, orderItems);
        string s = Json.serialize(orderExternal);
        String returnedValue = ProductClient.sendOrderToExternal(Json.serialize(orderExternal));
        return returnedValue;
    }
}
