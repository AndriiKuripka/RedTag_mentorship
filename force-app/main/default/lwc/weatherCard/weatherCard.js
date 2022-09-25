import { LightningElement, api } from 'lwc';

export default class WeatherCard extends LightningElement {
    @api weather;
}