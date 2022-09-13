/** Created by B.Myrko - on 8/12/2020.*/
import { ShowToastEvent } from "lightning/platformShowToastEvent";

function showToast(message, title, mode, variant, context) {
	const event = new ShowToastEvent({
		message: message,
		title: title,
		mode: mode,
		variant: variant
	});
	context.dispatchEvent(event);
	context.dispatchEvent(new CustomEvent('close'));
}

function sendEventToParent(
	context,
	eventName,
	detail,
	bubbles = true,
	composed = true
) {
	const eventPayload = {
		detail,
		bubbles,
		composed
	};
	context.dispatchEvent(new CustomEvent(eventName, eventPayload));
}




export {
  showToast,
  sendEventToParent
};