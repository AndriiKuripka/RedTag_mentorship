import { LightningElement, track } from 'lwc';
import getCityWeatherRecords from '@salesforce/apex/WeatherMapController.getCityWeatherRecords';
import getSettings from '@salesforce/apex/WeatherMapController.getSettings';


export default class LightningMapExample extends LightningElement {
    @track mapMarkers = [];
    @track columns = [
        { label: 'City Name', fieldName: 'cityName'},
        { label: 'Date', fieldName: 'date'},
        { label: 'Temperature', fieldName: 'temperature'},
        { label: 'Pressure', fieldName: 'pressure'},
        { label: 'Temperature feels like', fieldName: 'temperatureFeelsLike'},
        { label: 'Wind Speed', fieldName: 'windSpeed'}
    ];
    @track weather;
    @track data = [];
    currentCity;
    
    connectedCallback(){
        getSettings().then(response => {
            this.mapMarkers =  response.map((el) => {
                let marker = {
                    location: {
                        City: el.City_Name__c,
                    },

                    value: el.City_Name__c,
                    icon: 'standard:address',
                    title: el.City_Name__c,

                };
                return marker;
            });
            console.log(this.mapMarkers);
        });
    }

    markerSelect(event){
        this.currentCity = event.target.selectedMarkerValue;
        this.data = [];
        getCityWeatherRecords({city:this.currentCity}).then(response => {
            this.weather = response[0];

            this.data =  response.map((weatherTable) => {
                let el ={
                    cityName: weatherTable.City_Name__c,
                    date: weatherTable.Date__c,
                    temperature: weatherTable.Temperature__c,
                    pressure: weatherTable.Pressure__c,
                    temperatureFeelsLike: weatherTable.Temp_Feels_Like__c,
                    windSpeed: weatherTable.Wind_Speed__c,
                    humidity: weatherTable.Humidity__c
                };
                return el;
            });
        })
    }
}