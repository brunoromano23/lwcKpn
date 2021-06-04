public class ProductClient extends BaseClient{
    public static String sendOrderToExternal(String bodyObject) {
        String endpointUrl = 'https://kpntest.requestcatcher.com/';
		String returnedValue = '';
        HttpResponse response = sendPostRequest(endpointUrl, bodyObject);
        if(response.getStatusCode() == 200){
            return 'SUCCESS';
        }
        else{
            throw new HttpException('ERROR -> ' + response.getStatusCode() + ' - ' + response.getBody());
        }
    }
}