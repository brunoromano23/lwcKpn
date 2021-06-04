public with sharing class ProductController {
    @AuraEnabled(cacheable=true)
    public static BaseNotification getAvaliableProducts(Id orderId) {
        try {
            return new BaseNotification(ProductService.getAvaliableProducts(orderId));
        } catch (Exception ex) {
           BaseNotification response = new BaseNotification();
           response.addErrors(new List<String> { ex.getMessage() });
           return response;
        }
    }
    @AuraEnabled
    public static BaseNotification addProductsToOrder(Id orderId, List<Id> idsPriceBookEntries) {
        try {
            ProductService.addProductsToOrder(orderId, idsPriceBookEntries);
            return new BaseNotification();
        } catch (Exception ex) {
           BaseNotification response = new BaseNotification();
           response.addErrors(new List<String> { ex.getMessage() });
           return response;
        }
    }
    @AuraEnabled(cacheable=true)
    public static BaseNotification getOrderItems(Id orderId) {
        try {
            return new BaseNotification(ProductService.getOrderItems(orderId));
        } catch (Exception ex) {
           BaseNotification response = new BaseNotification();
           response.addErrors(new List<String> { ex.getMessage() });
           return response;
        }
    }
    @AuraEnabled
    public static BaseNotification activateOrder(Id orderId) {
        try {
            String returnedValue = ProductService.activateOrder(orderId);
            return new BaseNotification();
        } catch (Exception ex) {
           BaseNotification response = new BaseNotification();
           response.addErrors(new List<String> { ex.getMessage() });
           return response;
        }
    }
}
