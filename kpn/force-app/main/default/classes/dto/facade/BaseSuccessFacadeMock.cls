@isTest
global class BaseSuccessFacadeMock extends BaseFacadeMock {
    public BaseSuccessFacadeMock(Object body) {
        super(body, 200);
    }

    public BaseSuccessFacadeMock(Map<String, Object> bodies, Integer statusCode) {
        super(bodies, 200);
    }
}