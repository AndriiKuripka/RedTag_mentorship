import { LightningElement, api, track } from 'lwc';
import cancel from '@salesforce/label/c.Cancel';
import ok from '@salesforce/label/c.Ok';
import success from '@salesforce/label/c.Success';
import titleSuccess from '@salesforce/label/c.SuccessTitle';
import msgSuccess from '@salesforce/label/c.SuccessMsg';
import error from '@salesforce/label/c.Error';
import mode from '@salesforce/label/c.ToastMode';
import getSubjectPicklistValues from '@salesforce/apex/CreateCampaignTaskController.getSubjectPicklistValues';
import saveTask from '@salesforce/apex/CreateCampaignTaskController.saveTask';
import { showToast } from "c/utils";

export default class CreateCampaignTask extends LightningElement {
	@api recordId;
	@track subjectOptions = [];
	@track isModalOpen = false;
	subjectValue;
	dateValue;
	description;
	userId;

	label = {
		cancel,
		ok,
		success,
		error,
		mode,
		titleSuccess,
		msgSuccess
    };

	connectedCallback(){
		getSubjectPicklistValues()
			.then((result) => {
				this.subjectOptions = result.map(x => {
					return {label: x, value: x};
				});
			})
			.catch((error)=> {
				console.error(error);
			});
	}

	handleChangeSubject(event) {
		this.subjectValue = event.detail.value;
	}
	handleChangeDate(event){
		this.dateValue = event.detail.value;
	}
	handleChangeDescription(event){
		this.description = event.detail.value;
	}
	editChangeUserId(event){
		this.userId = event.target.value;
	}

	isFormValid() {
		let isValid = true;
		let inputFields = this.template.querySelectorAll('.validate');
		inputFields.forEach(inputField => {
			if(!inputField.checkValidity()) {
				inputField.reportValidity();
				isValid = false;
			}
		});
		this.template.querySelectorAll('lightning-input-field').forEach(element => {
			if (!element.value) {
				element.reportValidity();
				isValid = false;
			}
		});
		return isValid;
	}
	
	addTask() {
		if(!this.isFormValid()){
			return;
		}
		saveTask({
			subject: this.subjectValue, 
			activityDate: this.dateValue, 
			description: this.description,
			campaignId: this.recordId, 
			userId: this.userId
		}).then(() => {
			showToast(titleSuccess, msgSuccess, mode, success, this);
		}).catch((error) => {
			showToast(error, error, mode, error, this);
		});
	}
	

	openModal() {
		this.isModalOpen = true;
	}
	closeModal() {
		this.isModalOpen = false;
	}
}