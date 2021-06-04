import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOrderItems from '@salesforce/apex/ProductController.getOrderItems';
import activateOrder from '@salesforce/apex/ProductController.activateOrder';
import { getRecord } from 'lightning/uiRecordApi';
import STATUS from '@salesforce/schema/Order.Status';
const fields = [STATUS];

const columns = [
    { label: 'Name', fieldName: 'OrderItemName', type: 'text', sortable: 'true'}, 
    { label: 'Unit Price', fieldName: 'UnitPrice', type: 'currency', sortable: 'true'},
    { label: 'Quantity', fieldName: 'Quantity', sortable: 'true'},
    { label: 'Total Price', fieldName: 'TotalPrice', type: 'currency', sortable: 'true'}
]
export default class LwcOrderProducts extends LightningElement {
    @api recordId;
    @track data = [];
    @track showSpinner;
    @track error;
    @track filteredData;
    @track columns = columns;
    @track sortedBy;
    @track sortedDirection;

    subscription = null;
    @track disableButton = true;

    @wire(getRecord, { recordId: '$recordId', fields })
    order;
    
    connectedCallback(){
        this.getOrderItems();
    }

    getOrderItems()
    {
        this.showSpinner = true;
        getOrderItems({ orderId: this.recordId })
             .then(result => {
                if (this.ensureNotificationIsSuccess(result, true)) {
                    let orderItems = [];
                    this.data = result.content;

                    this.data.forEach(orderItem => {
                        let preparedOrderItem = {};
                        preparedOrderItem.Id = orderItem.Id;
                        if(orderItem.PricebookEntry) {
                            preparedOrderItem.OrderItemName = orderItem.PricebookEntry.Name;
                        }
                        preparedOrderItem.UnitPrice = orderItem.UnitPrice;
                        preparedOrderItem.Quantity = orderItem.Quantity;
                        preparedOrderItem.TotalPrice = orderItem.TotalPrice;
                        orderItems.push(preparedOrderItem);
                    }); 
                    if(this.data.length > 0){
                        this.disableButton = this.order.data.fields.Status.value == 'Activated' ? true : false;             
                    }

                    this.data = orderItems; 
                    }
                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                this.showErrorToast(this.buildErrorMessage(error));
            });

    }

    activateOrder(){
        this.showSpinner = true; 
        activateOrder({ orderId: this.recordId })
        .then(result => {
            if (this.ensureNotificationIsSuccess(result, true)) {
                this.showSuccessToast('Order and Order Items activated!');
                this.showSpinner = false;
                window.location.reload();
            }
        })
        .catch(error => {
            this.showSpinner = false;
            this.showErrorToast(this.buildErrorMessage(error));
        })
    }

    updateColumnSorting(event) {
        var dataToSort = JSON.parse(JSON.stringify(this.data));;
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        let fieldValue = row => row[this.sortedBy] || '';
        let reverse = this.sortedDirection === 'asc'? 1: -1;
        dataToSort = [...dataToSort.sort(
            (a,b)=>(a=fieldValue(a),b=fieldValue(b),reverse*((a>b)-(b>a)))
        )];
        this.data = dataToSort;
    }
    ensureNotificationIsSuccess(notification, showToast) {
        if (!notification.success) {
            const error = {
                body: {
                    message: notification.errors.toString()
                }
            };

            if (showToast)
                this.showErrorToast(this.buildErrorMessage(error));
            else
                this.setError = error;

            return false;
        }

        return true;
    }

    buildErrorMessage(error) {
        if (error.status)
            return `${error.status} (${error.statusText}) ${error.body ? '- ' + error.body.message : ''}.`

        return `${error.body ? '- ' + error.body.message : ''}`;
    }

    showSuccessToast(message) {
        const showToastEvent = new ShowToastEvent({
            message: message,
            variant: 'success'
        });

        this.dispatchEvent(showToastEvent);
    }

    showErrorToast(message) {
        const showToastEvent = new ShowToastEvent({
            message: message,
            variant: 'error'
        });

        this.dispatchEvent(showToastEvent);
    }
    get title() {
        return 'Order Products';
    }

    get dataHasItems() {
        return this.data && this.data.length > 0;
    }
}