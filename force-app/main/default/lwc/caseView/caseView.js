import { LightningElement, track, api} from 'lwc';
import { subscribe} from 'lightning/empApi';
import getCases from '@salesforce/apex/CaseViewController.getCases';
import getAllCases from '@salesforce/apex/CaseViewController.getAllCases';
import updateCase from '@salesforce/apex/CaseViewController.updateCase';
import getUserBranch from '@salesforce/apex/CaseViewController.getUserBranch';
import userId from '@salesforce/user/Id';
import INTRO from '@salesforce/resourceUrl/Intro';
import hasCasePermission from '@salesforce/customPermission/SeeCases';

const channelName = '/event/Case_Branch_Event__e';
export default class CaseView extends LightningElement {
    @api flexipageRegionWidth;
    @track data = [];
    @track caseId = '';
    currentUserBranchNumber = '';
    spinner = false;
    isSelected = false;
    columnSize = 'slds-size_1-of-1';
    columns = [
        {
            type:"button",
            fixedWidth: 100,
            typeAttributes: {
                label: 'Details',
                name: 'Details',
                variant: 'brand'
            }
        },
        {label: 'Case Number', fieldName: 'caseUrl', type: 'url', 
        typeAttributes: {
            label: {
               fieldName: 'caseNumber'}},
               target: '_blank'},
        {label: 'Created Date', fieldName: 'createdDate', type: 'date'},
        {label: 'Branch Number', fieldName: 'caseBranch', sortable: true},
        {label: 'Status', fieldName: 'caseStatus'},
    ];

    get isCheckBoxVisible() {
        return hasCasePermission;
    }

    connectedCallback(){
        this.showCaseRecords();
        this.handleSubscribe();
    }

    showCaseRecords(){
       if(this.currentUserBranchNumber === ''){
            getUserBranch({currentUserId: userId}).then(result => {
                this.currentUserBranchNumber = result;
                this.getCaseRecords();
            })
        } else{
            this.getCaseRecords();
        }
    }

    getCaseRecords() {
        getCases({branchNum: this.currentUserBranchNumber}).then(result => {
            this.data = result.map(caseRecord => {
                return {
                    caseNumber: caseRecord.CaseNumber,
                    caseUrl: `/${caseRecord.Id}`,
                    caseId: caseRecord.Id,
                    createdDate: caseRecord.CreatedDate,
                    caseBranch: caseRecord.BranchNumber__c,
                    caseStatus: caseRecord.Status
                }
            })
        }).catch(error => {
            console.error('Error on populating Case records! Error -> ' + error);
        });
    }

    getAllCaseRecords(){
        getAllCases().then(result => {
            this.data = result.map(caseRecord => {
                return {
                    caseNumber: caseRecord.CaseNumber,
                    caseUrl: `/${caseRecord.Id}`,
                    caseId: caseRecord.Id,
                    createdDate: caseRecord.CreatedDate,
                    caseBranch: caseRecord.BranchNumber__c,
                    caseStatus: caseRecord.Status
                }
            })
        }).catch(error => {
            console.error('Error on populating Case records! Error -> ' + error);
        });
    }

    showRecordDetail(event){
        this.columnSize = 'slds-size_1-of-2';
        this.caseId = event.detail.row.caseId;
        if (event.detail.row.caseStatus == 'New') {
            this.updateSelectedRecord(event);
        } else {
            this.isSelected = true;
        }
    }
    updateSelectedRecord(event){
        this.isSelected = false;
        this.spinner = true;
        updateCase({ caseId: this.caseId })
        .then(() => {
            this.spinner = false;
            this.isSelected = true;
            this.updateStatusOnDataTable(event.detail.row.caseNumber);
        })
        .catch((e) => {
            console.error(e)
        });
    }

    updateStatusOnDataTable(caseNumber) {
        this.data.forEach(function(caseData, index){
            if (caseData.caseNumber === caseNumber) {
                this[index].caseStatus = 'Working';
            }
        }, this.data);
    }

    closeDetails() {
        this.columnSize = 'slds-size_1-of-1';
        this.isSelected = false;
        this.caseId = '';
    }

   handleSubscribe(){
        const messageCallback = (response) => {
            if(this.currentUserBranchNumber == response.data.payload.BranchNumber__c){
                this.playAudio();
                this.getCaseRecords();
            }
        };  

        subscribe(channelName, -1, messageCallback)
        .catch(error => {
            console.error('handleSubscribe ', error);
        });
    }

    playAudio() {
        let audio = new Audio();
        audio.src = INTRO;
        audio.load();
        audio.play();
    }

    handleCheckBoxChange(event){
        if(event.target.checked){
            this.getAllCaseRecords();
        } else{
            this.showCaseRecords();
        }
        
    }
}