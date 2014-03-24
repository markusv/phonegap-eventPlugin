/**
 * EventManager.js
 * Created by Markus Voss on 9/1/10.
 */

/**
 * The javascript object representation the EventManager. Call to funcions
 * of the ContactManager with window.plugins.contactsManager.functionName.
 */
function EventManager() {
	this.resultCallback = null; // Function
};



/**
 * This is returned to possible javascript callback functions if the event 
 * was added successfulll.
 */
EventManager.prototype.EVENT_ADDED_SUCCESSFULL = 1;


/**
 * This is returned to possible javascript callback functions if the event
 * was added canceled.
 */
EventManager.prototype.EVENT_ADDED_CANCEL = 2;


/**
 * This status is returned to possible javascript callback functions if a
 * event was deleted. 
 */
EventManager.prototype.EVENT_DELETED = 3;


/**
 * No access to calendar. 
 */
EventManager.prototype.EVENT_NO_ACCESS = 4;


/**
 * Adds a new event.
 */
EventManager.prototype.newEvent = function(event, successCallback, errorCallback) {	
    if (!event) {
		event = {};
	}
	this.resultCallback = successCallback;
	cordova.exec(successCallback,errorCallback,"EventManager", "newEvent", [event]);
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
