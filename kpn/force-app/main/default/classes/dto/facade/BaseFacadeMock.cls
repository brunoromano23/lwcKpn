global abstract class BaseFacadeMock implements HttpCalloutMock {    
    public BaseFacadeMock(Object body, Integer statusCode) {
        this.bodies = new Map<String, Object>();
        this.bodies.put('body', body);

        this.statusCode = statusCode;
    }

    public BaseFacadeMock(Map<String, Object> bodies, Integer statusCode) {
        this.bodies = bodies;
        this.statusCode = statusCode;
    }
        
    public Map<String, Object> bodies { get; private set; }

    public Integer statusCode { get; private set; }

    global HTTPResponse respond(HTTPRequest request) {
        Object body = null;

        if (this.bodies.size() == 1) {
            body = this.bodies.get('body');
        } else {
            body = this.bodies.get(request.getEndpoint());
        }

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(JSON.serialize(body));
        response.setStatusCode(this.statusCode);

        return response; 
    }
}
