import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAvaliableProducts from '@salesforce/apex/ProductController.getAvaliableProducts';
import addProductsToOrder from '@salesforce/apex/ProductController.addProductsToOrder';
import { getRecord } from 'lightning/uiRecordApi';
import STATUS from '@salesforce/schema/Order.Status';
const fields = [STATUS];

const columns = [
    { label: 'Name', fieldName: 'Name', type : 'text', sortable: 'true'}, 
    { label: 'List Price', fieldName: 'UnitPrice', type: 'currency', sortable: 'true'}
]
export default class LwcAvaliableProducts extends LightningElement {
    @api recordId;
    @track data = [];
    @track showSpinner;
    @track error;
    @track filteredData;
    @track columns = columns;
    allData;
    filterableFields = ['Name', 'UnitPrice'];
    @track sortedBy;
    @track sortedDirection;
    @track priceBook2Id;
    @track disableButton = false;
    

    @wire(getRecord, { recordId: '$recordId', fields })
    order;

    @wire(getAvaliableProducts, { orderId: '$recordId'})
    getProducts({ data, error }) {
        this.showSpinner = true;
        if(data) {
            if (this.ensureNotificationIsSuccess(data, true)) {
                this.data = data.content;
                this.filteredData = this.data;
                this.allData = this.data;
                this.disableButton = this.data.length == 0 || this.order.data.fields.Status.value == 'Activated' ? true : false;         
            }
            this.showSpinner = false;
        } else if(error) {
            this.showSpinner = false;
            this.showErrorToast(this.buildErrorMessage(error) );
        }
    }
    addProducts() {   
        this.showSpinner = true;     
        var dt = this.template.querySelector('lightning-datatable');
        var selectedRows = dt.getSelectedRows();
        var listIds = [];
        if(selectedRows.length > 0){
            selectedRows.forEach(function(prd){
                listIds.push(prd.Id);
            });
        }      
        else{
            this.showErrorToast('Please select at least one product');
            this.showSpinner = false;
            return;
        }
        addProductsToOrder({ 
            orderId: this.recordId,
            idsPriceBookEntries: listIds })
            .then((result) => {
                this.showSpinner = false;
                if (this.ensureNotificationIsSuccess(result, true)) {
                    this.showSuccessToast('Products added successfully!');
                    window.location.reload();
                }
            })
            .catch(error => {
                this.showSpinner = false;
                this.showErrorToast(this.buildErrorMessage(error));
            });
    }

    handleResults(event){
        this.filteredData = event.detail.filteredData
    }
    updateColumnSorting(event) {
        var dataToSort = JSON.parse(JSON.stringify(this.filteredData));;
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        let fieldValue = row => row[this.sortedBy] || '';
        let reverse = this.sortedDirection === 'asc'? 1: -1;
        dataToSort = [...dataToSort.sort(
            (a,b)=>(a=fieldValue(a),b=fieldValue(b),reverse*((a>b)-(b>a)))
        )];
        this.filteredData = dataToSort;
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
        return 'Avaliable Products';
    }

    get dataHasItems() {
        return this.data && this.data.length > 0;
    }
}