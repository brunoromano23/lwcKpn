@isTest
private class BaseClientTest {

    @isTest
    static void sendRequestWithEndPointAndMethodShouldReturnSuccessResponse() {
        Account mock = new Account(Name = 'AccountName');
        Test.setMock(HttpCalloutMock.class, new BaseSuccessFacadeMock(mock));
        Test.startTest();
 
        HttpResponse response = BaseClient.sendRequest('endpointUrl', 'GET');
        Map<String, Object> responseBody = BaseClient.getResponseBody(response);

        Test.stopTest();
        
        System.assertEquals(200, response.getStatusCode(), 'Request status code different then 200');
        System.assertEquals('AccountName', responseBody.get('Name'), 'Mocked property doesnt serialized into object');
    }

    @isTest
    static void sendRequestWithEndPointAndMethodShouldReturnFailureResponse() {
        HttpErrorResponse responseBody = new HttpErrorResponse('an error occurred', '0001', '2891802');
        Test.setMock(HttpCalloutMock.class, new BaseFailureFacadeMock(responseBody));
        Boolean result = false;
        String message;

        try {
           Test.startTest();
            HttpResponse response = BaseClient.sendRequest('endpointUrl', 'GET');
            if(response.getStatusCode() == 500)
                throw new HttpException();
            Test.stopTest();
        } catch (Exception ex) {
           result = true;
           message = ex.getMessage();
        }
        System.assert(result, true);
    }

    @isTest
    static void sendGetRequestShouldReturnSuccessResponse() {
        Account mock = new Account(Name = 'AccountName');
        Test.setMock(HttpCalloutMock.class, new BaseSuccessFacadeMock(mock));
        Test.startTest();

        HttpResponse response = BaseClient.sendGetRequest('endpointUrl');
        Map<String, Object> responseBody = BaseClient.getResponseBody(response);

        Test.stopTest();
        
        System.assertEquals(200, response.getStatusCode(), 'Request status code different then 200');
        System.assertEquals(
            'AccountName', 
            responseBody.get('Name'), 
            'Mocked property doesnt serialized into object');
    }

    @isTest
    static void sendGetRequestShouldReturnFailureResponse() {
        HttpErrorResponse responseBody = new HttpErrorResponse('an error occurred', '0001', '2891802');
        Test.setMock(HttpCalloutMock.class, new BaseFailureFacadeMock(responseBody));
        Boolean result = false;
        String message;
        try {
            Test.startTest();
            HttpResponse response = BaseClient.sendGetRequest('endpointUrl');
            if(response.getStatusCode() == 500)
                throw new HttpException();
            Test.stopTest();
        } catch (Exception ex) {
           result = true;
           message = ex.getMessage();
        }
        
        System.assert(result, true);
    }

    @isTest
    static void sendPostRequestShouldReturnSuccessResponse() {
        Account mock = new Account(Name = 'AccountName');
        Test.setMock(HttpCalloutMock.class, new BaseSuccessFacadeMock(mock));
        Test.startTest();

        HttpResponse response = BaseClient.sendPostRequest(
            'endpointUrl', 
            JSON.serialize(new Account(Name = 'AccountName')));

        Map<String, Object> responseBody = BaseClient.getResponseBody(response);

        Test.stopTest();
        
        System.assertEquals(200, response.getStatusCode(), 'Request status code different then 200');
        System.assertEquals(
            'AccountName', 
            responseBody.get('Name'), 
            'Mocked property doesnt serialized into object');
    }

    @isTest
    static void sendPostRequestShouldReturnFailureResponse() {
        HttpErrorResponse responseBody = new HttpErrorResponse('an error occurred', '0001', '2891802');
        Test.setMock(HttpCalloutMock.class, new BaseFailureFacadeMock(responseBody));

        Boolean result = false;
        String message;

        try {
            Test.startTest();
            HttpResponse response = BaseClient.sendPostRequest(
                'endpointUrl', 
                JSON.serialize(new Account(Name = 'AccountName')));
			if(response.getStatusCode() == 500)
                throw new HttpException();
            
            Test.stopTest();
        } catch (Exception ex) {
           result = true;
           message = ex.getMessage();
        }
        System.assert(result, true);
    }

    @isTest
    static void createSimpleRequestShouldReturnEndpointAndMethod() {
        HttpRequest request = BaseClient.createRequest('endpoint', 'GET');

        System.assertEquals('endpoint', request.getEndpoint(), 'informed endpoint was not set on HttpRequest');
        System.assertEquals('GET', request.getMethod(), 'informed method was not set on HttpRequest');
    }

    @isTest
    static void createRequestWithBodyShouldReturnEndpointMethodAndBody() {
        Account body = new Account(Name = 'AccountName');
        HttpRequest request = BaseClient.createRequest('endpoint', 'POST', JSON.serialize(body));

        System.assertEquals('endpoint', request.getEndpoint(), 'informed endpoint was not set on HttpRequest');
        System.assertEquals('POST', request.getMethod(), 'informed method was not set on HttpRequest');
        System.assert(request.getBody() != null, 'informed body was not set on HttpRequest');
    }

    @isTest
    static void createRequestWithHeadersShouldReturnEndpointMethodAndHeaders() {
        Map<String, String> headers = new Map<String, String>();
        headers.put('x-custom-header', 'custom-value');

        HttpRequest request = BaseClient.createRequest('endpoint', 'POST', null, headers);

        System.assertEquals('endpoint', request.getEndpoint(), 'informed endpoint was not set on HttpRequest');
        System.assertEquals('POST', request.getMethod(), 'informed method was not set on HttpRequest');
        System.assertEquals(
            'custom-value', 
            request.getHeader('x-custom-header'), 
            'informed header was not set on HttpRequest');
    }

    @isTest
    static void createRequestWithParametersShouldReturnEndpointMethodAndParameters() {
        Map<String, String> parameters = new Map<String, String>();
        parameters.put('objectId', '123xyf');

        HttpRequest request = BaseClient.createRequest('endpoint', 'GET', null, null, parameters);

        System.assertEquals('GET', request.getMethod(), 'informed method was not set on HttpRequest');
        System.assert(request.getEndpoint().contains('objectId'), 'informed endpoint was not set on HttpRequest');
        System.assert(request.getEndpoint().contains('123xyf'), 'informed endpoint was not set on HttpRequest');
    }

    @isTest
    static void createRequestWithEmptyEndpointShouldReturnException() {
        Boolean result = false;
        try {
            HttpRequest request = BaseClient.createRequest('', 'GET');        
        } catch (Exception ex) {
           result = ex.getMessage().contains('invalid argument "endpointurl", cannot be empty');
        }

        System.Assert(result, 'expected exception was not returned');
    }

    @isTest
    static void createRequestWithEmptyMethodShouldReturnException() {
        Boolean result = false;
        try {
            HttpRequest request = BaseClient.createRequest('endpoint', '');
        } catch (Exception ex) {
           result = ex.getMessage().contains('invalid argument "method", cannot be empty');
        }

        System.Assert(result, 'expected exception was not returned');
    }

    @isTest
    static void sendNullRequestShouldReturnInvalidParameterException() {
        Boolean result = false;
        
        try {
            Test.startTest();
            HttpResponse response = BaseClient.send(null);
            Test.stopTest();
        } catch (InvalidParameterValueException ex) {
           result = ex.getMessage().contains('invalid argument "request", cannot be empty');
        }

        System.Assert(result, 'expected exception was not returned');
    }

    @isTest
    static void sendInvalidRequestShouldReturnException() {
        Boolean result = false;
        try {
            Test.startTest();

            HttpRequest request = new HttpRequest();
            HttpResponse response = BaseClient.send(request);
            
            Test.stopTest();
        } catch (Exception ex) {
           result = true;
        }

        System.Assert(result, 'expected exception was not returned');
    }

    @isTest
    static void isStatusOkShouldReturnTrue(){

        Boolean status;

        status = BaseClient.isStatus2xx(200);
        System.assert(status, 'Status should be true to status code 200');

        status = BaseClient.isStatus2xx(201);
        System.assert(status, 'Status should be true to status code 201');

    }

    @isTest
    static void isStatusOkShouldReturnFalse(){

        Boolean status;

        status = BaseClient.isStatus2xx(400);
        System.assert(!status, 'Status should be false to status code 400');

        status = BaseClient.isStatus2xx(500);
        System.assert(!status, 'Status should be false to status code 500');

    }
}
