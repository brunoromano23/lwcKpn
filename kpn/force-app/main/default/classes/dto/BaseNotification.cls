public class BaseNotification {
    @AuraEnabled public Boolean success {get; set;}
    @AuraEnabled public Object content {get; set;}
    @AuraEnabled public List<String> validations {get; set;}
    @AuraEnabled public List<String> errors {get; set;}
    @AuraEnabled public List<String> messages {get; set;}

    public BaseNotification() {
        this.success = true;
        this.validations = new List<String>();
        this.errors = new List<String>();
        this.messages = new List<String>();
    }

    public BaseNotification(Object content) {
        this();
        this.content = content;
    }

    public void setContent(Object content) {
        this.content = content;
    }

    public void addValidations(List<String> validations) {
        this.validations.addAll(validations);
        this.success = false;
    }

    public void addMessages(List<String> messages) {
        this.messages.addAll(messages);
    }

    public void addErrors(List<String> errors) {
        this.errors.addAll(errors);
        this.success = false;
    }
}
