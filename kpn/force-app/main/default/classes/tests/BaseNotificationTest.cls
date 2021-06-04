@isTest
private class BaseNotificationTest {

    @isTest
    static void createFailureNotificationWithErrors() {
        BaseNotification notification = new BaseNotification();
        notification.addErrors(new List<String> { 'An error has ocurred.' });

        System.assert(
            !notification.success, 
            'Notification status was different from failure');
        System.assertEquals(
            'An error has ocurred.', 
            notification.errors.get(0), 
            'Error message was different from expected');
    }

    @isTest
    static void createFailureNotificationWithValidations() {
        BaseNotification notification = new BaseNotification();
        notification.addValidations(new List<String> { 'A business error has ocurred.' });

        System.assert(
            !notification.success, 
            'Notification status was different from failure');
        System.assertEquals(
            'A business error has ocurred.', 
            notification.validations.get(0), 
            'Error message was different from expected');
    }

    @isTest
    static void createSuccessNotificationWithMessages() {
        String content = 'content result';
        BaseNotification notification = new BaseNotification(content);
        notification.addMessages(new List<String> { 'Operation completed successfully.' });

        System.assert(
            notification.success, 
            'Notification status was different from success');
        System.assertEquals(
            content, 
            notification.content, 
            'Content message was different from expected');
        System.assertEquals(
            'Operation completed successfully.', 
            notification.messages.get(0), 
            'Success message was different from expected');
    }

    @isTest
    static void setContent() {
        String content = 'my content';
        BaseNotification notification = new BaseNotification();
        notification.setContent(content);

        System.assertEquals(content, notification.content, 'Notification content was different from expected');
    }
}