public abstract class BaseClient {
    public static HttpResponse sendRequest(String endpointUrl, String method) {
        return sendRequest(endpointUrl, method, null);
    }

    public static HttpResponse sendRequest(String endpointUrl, String method, String body) {
        return sendRequest(endpointUrl, method, body, null);
    }

    public static HttpResponse sendRequest(
        String endpointUrl, 
        String method, 
        String body, 
        Map<String, String> headers) {
        return sendRequest(endpointUrl, method, body, headers, null);
    }

    public static HttpResponse sendRequest(
        String endpointUrl, 
        String method, 
        String body, 
        Map<String, String> headers, 
        Map<String, String> parameters) {
        HttpRequest request = createRequest(endpointUrl, method, body, headers, parameters);
        HttpResponse response = send(request);

        return response;
    }

    public static HttpResponse sendGetRequest(String endpointUrl) {
        return sendGetRequest(endpointUrl, null);
    }

    public static HttpResponse sendGetRequest(String endpointUrl, Map<String, String> headers) {
        return sendGetRequest(endpointUrl, headers, null);
    }

    public static HttpResponse sendGetRequest(
        String endpointUrl, 
        Map<String, String> headers, 
        Map<String, String> parameters) {
        HttpRequest request = createRequest(endpointUrl, 'GET', null, headers, parameters);
        HttpResponse response = send(request);

        return response;
    }

    public static HttpResponse sendPostRequest(String endpointUrl, String body) {
        return sendPostRequest(endpointUrl, body, null);
    }

    public static HttpResponse sendPostRequest(
        String endpointUrl, 
        String body, 
        Map<String, String> headers) {
        return sendPostRequest(endpointUrl, body, headers, null);
    }

    public static HttpResponse sendPostRequest(
        String endpointUrl, 
        String body, 
        Map<String, String> headers, 
        Map<String, String> parameters) {
        HttpRequest request = createRequest(endpointUrl, 'POST', body, headers, parameters);
        HttpResponse response = send(request);

        return response;
    }

    public static HttpResponse sendDeleteRequest(String endpointUrl) {
        HttpRequest request = createRequest(endpointUrl, 'DELETE', null, null, null);
        HttpResponse response = send(request);

        return response;
    }
    public static Map<String, Object> getResponseBody(HttpResponse response) {
        return (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
    }

    public static String getStringResponseBody(HttpResponse response) {
        return response.getBody();
    }

    public static Boolean isStatus2xx(Integer statusCode){
        return statusCode >= 200 && statusCode <= 299;
    }

    public static Boolean isStatusForbidden(Integer statusCode) {
        return statusCode == 401;
    }

    @testVisible
    private static HttpRequest createRequest(String endpointUrl, string method) {
        return createRequest(endpointUrl, method, null, null);
    }

    @testVisible
    private static HttpRequest createRequest(String endpointUrl, string method, String body) {
        return createRequest(endpointUrl, method, body, null);
    }

    @testVisible
    private static HttpRequest createRequest(
        String endpointUrl, 
        string method, 
        String body, 
        Map<String, String> headers) {
        return createRequest(endpointUrl, method, body, headers, null);
    }

    @testVisible
    private static HttpRequest createRequest(
        String endpointUrl, 
        string method, 
        String body, 
        Map<String, String> headers, 
        Map<String, String> parameters) {
        HttpRequest request = new HttpRequest();

        if (String.isBlank(endpointUrl) || String.isEmpty(endpointUrl) || endpointUrl == null) {
            InvalidParameterValueException parameterException = new InvalidParameterValueException('endpointurl', '');
            parameterException.setMessage('invalid argument "endpointurl", cannot be empty');

            throw parameterException;
        }

        if (String.isBlank(method) || String.isEmpty(method) || method == null) {
            InvalidParameterValueException parameterException = new InvalidParameterValueException('method', '');
            parameterException.setMessage('invalid argument "method", cannot be empty');

            throw parameterException;
        }

        if (parameters != null && parameters.size() > 0) {
            endpointUrl += '?';
            for (String key : parameters.keySet()) {
                endpointUrl += key + '=' + parameters.get(key) + '&';
            }
        }

        request.setEndpoint(endpointUrl);
        request.setMethod(method);
        request.setTimeout(90000); 

        if (body != null) {
            request.setBody(JSON.serialize(body));
        }

        if (headers != null && headers.size() > 0) {
            for (String key : headers.keySet()) {
                request.setHeader(key, headers.get(key));
            }
        }

        System.debug('created request: ' + request);

        return request;
    }

    @testVisible
    private static HttpResponse send(HttpRequest request) {
        if (request == null) {
            InvalidParameterValueException parameterException = new InvalidParameterValueException('request', '');
            parameterException.setMessage('invalid argument "request", cannot be empty');

            throw parameterException;
        }

        Boolean retry = false;
        Integer reqCount = 0;
        Integer maxReqCount = 2;

        HttpResponse response;
        Exception ex;

        setAccept(request);
        setContentType(request);
        
        try {
            response = new Http().send(request);

            if (isStatusForbidden(response.getStatusCode())) {
                throw new HttpException('ERROR');
            } 
        } catch (Exception e) {
            throw e;
        }
    

        return response;
    }

    private static void setAccept(HttpRequest request) {
        request.setHeader('Accept', 'application/json');
    }

    private static void setContentType(HttpRequest request) {
        request.setHeader('Content-Type', 'application/json');
    }

}
