import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import fetchContactData from '@salesforce/apex/ContactApiController.fetchContactData';
import fetchOrderData from '@salesforce/apex/ContactApiController.fetchOrderData';

const FIELDS = ['Contact.Email', 'Contact.Phone'];

export default class ContactDataList extends LightningElement {
    @api recordId;
    @track data = [];
    @track error;
    contactEmail;
    contactPhone;
    contactMapBySource = {}; // Holds contact name by source

    columns = [
        { label: 'Source', fieldName: 'Source' },
        { label: 'Name', fieldName: 'Name' },
        { label: 'Email', fieldName: 'Email' },
        { label: 'Mobile Phone', fieldName: 'Phone' },
        { label: 'Birth Date', fieldName: 'Birth Date' }
    ];

    @track order = [];
    @track orderError;

    orderColumns = [
        { label: 'Source', fieldName: 'Source' },
        { label: 'Name', fieldName: 'CName' }, // Contact Name matched by Source
        { label: 'Order Number', fieldName: 'OrderNumber' },
        { label: 'Email', fieldName: 'Email' },
        { label: 'Mobile Phone', fieldName: 'Phone' },
        { label: 'Amount', fieldName: 'Amount' },
        { label: 'Date', fieldName: 'Date' },
        { label: 'Description', fieldName: 'Description' }
    ];

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredContact({ error, data }) {
        if (data) {
            this.contactEmail = data.fields.Email.value;
            this.contactPhone = data.fields.Phone.value;
            this.fetchData(); // First fetch contacts
        } else if (error) {
            this.error = error;
            console.error('Record fetch error:', error);
        }
    }

    fetchData() {
        fetchContactData({ email: this.contactEmail, phone: this.contactPhone })
            .then((result) => {
                console.log('Contact result', result);
                this.data = result;
                this.error = undefined;

                // Build map: Source → Contact Name
                this.contactMapBySource = {};
                result.forEach(contact => {
                    if (contact.Source) {
                        this.contactMapBySource[contact.Source] = contact.Name;
                    }
                });

                // Now fetch orders after contacts are mapped
                this.fetchOrderInfo();
            })
            .catch((err) => {
                this.error = err;
                this.data = [];
                console.error('API call error:', err);
            });
    }

    fetchOrderInfo() {
        fetchOrderData({ email: this.contactEmail })
            .then((result) => {
                // Attach correct contact name based on source
                const ordersWithName = result.map(order => {
                    const source = order.Source;
                    const cname = this.contactMapBySource[source] || 'N/A';
                    return { ...order, CName: cname };
                });

                this.order = ordersWithName;
                console.log('Order data:', this.order);
                this.orderError = undefined;
            })
            .catch((err) => {
                this.orderError = err;
                this.order = [];
                console.error('API call error:', err);
            });
    }
}