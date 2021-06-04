public class OrderExternal {
    public OrderExternal(Order order, List<OrderItem> orderItens) {
        this.orderNumber = order.OrderNumber;
        this.accountNumber = order.Account.AccountNumber;
        this.type = order.Type;
        this.status = order.Status;
        List<OrderProductExternal> orderPrds = new List<OrderProductExternal>();
        for(OrderItem orderItem :orderItens){
            OrderProductExternal orderProduct = new OrderProductExternal();
            orderProduct.name = orderItem.PricebookEntry.Product2.Name;
            orderProduct.code = orderItem.PricebookEntry.Product2.ProductCode;
            orderProduct.unitPrice = orderItem.UnitPrice;
            orderProduct.quantity = orderItem.Quantity;
            orderPrds.add(orderProduct);
        }
        this.orderProduct = orderPrds;
    }

    public String orderNumber { get; private set; }
    public String accountNumber { get; private set; }
    public String type { get; private set; }
    public String status { get; private set; }
    public List<OrderProductExternal> orderProduct {get;set;}

    public class OrderProductExternal{
        public String name { get; private set; }
        public String code { get; private set; }
        public Decimal unitPrice { get; private set; }
        public Decimal quantity { get; private set; }

    }
}
