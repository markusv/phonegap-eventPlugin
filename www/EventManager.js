/**
 * EventManager.js
 * Created by Markus Voss on 9/1/10.
 */


/**
 * This is returned to possible javascript callback functions if the event 
 * was added successfulll.
 */
var EVENT_ADDED_SUCCESSFULL = 1;


/**
 * This is returned to possible javascript callback functions if the event
 * was added canceled.
 */
var EVENT_ADDED_CANCEL = 2;


/**
 * This status is returned to possible javascript callback functions if a
 * event was deleted. 
 */
var EVENT_DELETED = 3;


/**
 * No access to calendar. 
 */
var EVENT_NO_ACCESS = 4;


/**
 * The javascript object representation the EventManager. Call to funcions
 * of the ContactManager with window.plugins.contactsManager.functionName.
 */
function EventManager() {
	this.resultCallback = null; // Function
};


/**
 * Adds a new event.
 */
EventManager.prototype.newEvent = function(event, successCallback) {	
    if (!event) {
		event = {};
	}
	this.resultCallback = successCallback;
	/*if (successCallback) {
		event.successCallback = GetFunctionName(successCallback);
	}*/
	console.log("run cordova exec");
	cordova.exec(function() {
		alert("successCallback");
	},function() {
		alert("errorCallback");
	},"EventManager", "newEvent", [event]);
};


/**
 * Called by C code when a event adding operation has finished. 
 * @param result The reslut from the C code. 
 * @param eventId The id of the evnet if any event was added added. 
 */
EventManager.prototype.didFinishWithResult = function(res, eventId) {
	if (this.resultCallback) {
		this.resultCallback(res, eventId);
	}
};


/**
 * Adds this to the window.plugin on construction.
 */
cordova.addConstructor(function() {
	if(!window.plugins) {
		window.plugins = {};
	}
	window.plugins.eventManager = new EventManager();
});
