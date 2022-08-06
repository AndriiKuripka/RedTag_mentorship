import { track, wire, api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import findOpportunities from '@salesforce/apex/OpportunityController.findOpportunities';
export default class OpportunityRecordsList extends NavigationMixin(LightningElement) {
    @api recordId;
    @api RecordsAmount;
    @track opportunities;
    @track columns = [
        {label: 'Name', fieldName: "Name", type: "button", 
        typeAttributes: { label: { fieldName: "Name" }, name:'viewOpp', variant: "base" } },
        {label: 'Stage', fieldName: 'StageName',type:'text'},
        {label: 'Close Date', fieldName: 'CloseDate', type:'date'},
        {label: 'Amount', fieldName: 'Amount', type: 'currency'},
    ];
    @wire(findOpportunities,{accountId:'$recordId',queryLimit:'$RecordsAmount'}) 
    WireOpportunityRecords({error,data}){
        if(data){
            this.opportunities = data;
            this.error = undefined;
        }else{
            this.error = error;
            this.opportunities = undefined;
        }
    }
    viewOpportunity(event){
        const action = event.detail.action;
        switch (action.name){
            case 'viewOpp':
                this[NavigationMixin.Navigate]({
                    type:'standard__recordPage',
                    attributes:{
                        recordId: event.detail?.row?.Id,
                        objectApiName:'Opportunity',
                        actionName: 'view'
                    }
                });
                break;
            default:
        }
    }
}