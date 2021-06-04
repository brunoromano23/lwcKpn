@isTest
global class BaseFailureFacadeMock extends BaseFacadeMock {
    public BaseFailureFacadeMock(Object body) {
        super(body, 500);
    }
}