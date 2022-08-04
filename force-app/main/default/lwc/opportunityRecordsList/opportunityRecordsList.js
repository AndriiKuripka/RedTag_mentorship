import { track, wire, api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import findOpportunities from '@salesforce/apex/OpportunityController.findOpportunities';
export default class OpportunityRecordsList extends NavigationMixin(LightningElement) {
    @api recordId;
    @track opportunities;
    @track columns = [
        {label: 'Name', 
        fieldName: "Name",  
        type: "button",  
        typeAttributes: { label: { fieldName: "Name" }, variant: "base" } },
        {label: 'Stage', fieldName: 'StageName',type:'text'},
        {label: 'Close Date', fieldName: 'CloseDate', type:'date'},
        {label: 'Amount', fieldName: 'Amount', type: 'currency'},
    ];
    @wire(findOpportunities,{accountId:'$recordId'}) 
    WireOpportunityRecords({error,data}){
        if(data){
            this.opportunities = data;
            this.error = undefined;
        }else{
            this.error = error;
            this.opportunities = undefined;
        }
    }
    navigateToOpportunityPage(event){
        this.recordId = event.detail?.row?.Id;
        console.log('Record Id ==> '+ this.recordId);
            this[NavigationMixin.Navigate]({
                type:'standard__recordPage',
                attributes:{
                    recordId: this.recordId,
                    objectApiName:'Opportunity',
                    actionName: 'edit'
            }
        });
    }
}