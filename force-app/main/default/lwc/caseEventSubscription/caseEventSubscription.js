import { LightningElement, api } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import USER_ID from '@salesforce/user/Id';
import INTRO from '@salesforce/resourceUrl/Intro';

const channelName = '/event/Case_Event__e';

export default class CaseEventSubscription extends LightningElement {
    @api recordId;
    subscription = {}
    
    connectedCallback(){
        console.clear();
        this.handleError();
        this.handleSubscribe();
    }

    disconnectedCallback(){
        this.handleUnsubscribe();
    }

    handleSubscribe(){
        const messageCallback = (response) => {
            if(this.recordId === response.data.payload.Record_Id__c && USER_ID !== response.data.payload.User_Id__c){
                const evt = new ShowToastEvent({
                    title: 'Case is in use!',
                    message: 'This case was just picked up by another agent.',
                    variant: 'warning',
                });
                this.dispatchEvent(evt);
                this.playAudio();
            }
        };  

        subscribe(channelName, -1, messageCallback)
        .then(response => {
            this.subscription = response;
        })
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

    handleUnsubscribe(){
        unsubscribe(this.subscription);
    }

    handleError(){
        onError(error => {
            console.log('err: ', JSON.stringify(error));
        })
    }
}