
//
//  EventManager.m
//  
//
//  Created by Markus Voss on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventManager.h"


@implementation EventManager

NSString *callbackId = nil;


-(CDVPlugin*) initWithWebView:(UIWebView*)theWebView
{
	NSLog(@"test");
    self = (EventManager*)[super initWithWebView:(UIWebView*)theWebView];
    if (self) {
        myEventStore = [[EKEventStore alloc] init];
    }
	return self;
}

// - (void) addEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) addEvent:(CDVInvokedUrlCommand*)command
{
	NSDictionary* options = [command.arguments objectAtIndex:0];
	callbackId = command.callbackId;
	NSString *title = nil, *startDate = nil, *endDate = nil, *location = nil, *eventId = nil;
	NSString *notes = nil, *allDay = nil, *relativeAlarmOffset1 = nil, *relativeAlarmOffset2 = nil;
	EKEvent *theEvent;
	
	// set the properties from javascript
	title = [options valueForKey:@"title"];
	startDate = [options valueForKey:@"startDate"];
	endDate = [options valueForKey:@"endDate"];
	location = [options valueForKey:@"location"];
	notes = [options valueForKey:@"notes"];
	allDay = [options valueForKey:@"allDay"];
	relativeAlarmOffset1 = [options valueForKey:@"relativeAlarmOffset1"];
	relativeAlarmOffset2 = [options valueForKey:@"relativeAlarmOffset2"];
	eventId = [options valueForKey:@"eventId"];
	
	if (eventId && [eventId length] > 0) {
		theEvent = [myEventStore eventWithIdentifier: eventId];
	}
	else {	
		theEvent = [EKEvent eventWithEventStore: myEventStore];
		// set the properties form javascript if provided
		if (title && [title length] > 0) {
			[theEvent setTitle: title];
		}
		if (startDate && [startDate length] > 0) {
			[theEvent setStartDate:[NSDate dateWithTimeIntervalSince1970: [startDate intValue]]];		
		}
		if (endDate && [endDate length] > 0) {
			[theEvent setEndDate:[NSDate dateWithTimeIntervalSince1970: [endDate intValue]]];
		}
		if (location && [location length] > 0) {
			[theEvent setLocation: location];
		}
		if (notes && [notes length] > 0) {
			[theEvent setNotes: notes];
		}
		if (allDay && [allDay caseInsensitiveCompare: @"true"] == NSOrderedSame) {
			[theEvent setAllDay: true];
		}
		if (relativeAlarmOffset1 && [relativeAlarmOffset1 length] > 0) {
			[theEvent addAlarm: [EKAlarm alarmWithRelativeOffset: -[relativeAlarmOffset1 intValue]]];
		}
		if (relativeAlarmOffset2 && [relativeAlarmOffset2 length] > 0) {
			[theEvent addAlarm: [EKAlarm alarmWithRelativeOffset: -[relativeAlarmOffset2 intValue]]];
		}
	}
	
	// create an EKEventEditViewController to display the event.
	EKEventEditViewController *controller = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
	controller.event = theEvent;
	
	// set the addController's event store to the current event store.
	controller.eventStore = myEventStore;
	
	// present EventsAddViewController as a modal view controller
//	[[super appViewController] presentModalViewController:controller animated:YES];
    [self.viewController presentModalViewController:controller animated:YES];
	
	controller.editViewDelegate = self;
}

-(void) showNoAccessErrorMessage;
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"window.plugins.eventManager.didFinishWithResult('4');"];
    //[self performSelector:@selector(writeJavascript:) onThread:[NSThread mainThread] withObject:jsString2 waitUntilDone:NO];
}
    
    
- (void) newEvent:(CDVInvokedUrlCommand*)command {
	if(![myEventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
    	[self addEvent: command];
    	return;
	}
	[myEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
		if (granted){
			dispatch_sync (dispatch_get_main_queue (), ^{
				[self addEvent: command];
			});
		} else {
			dispatch_sync (dispatch_get_main_queue (), ^{
				[self showNoAccessErrorMessage];
			});
		}
	}];
}


/******* Delegate methods from EKEventEditViewDelegate protocol  ****/
 
 
 /**
 * Invoked when the user finished editing the event.
 */
- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
	EKEvent *thisEvent = controller.event;
	NSString *webviewResult = nil;
	
	switch (action) {
        case EKEventEditViewActionSaved:
			webviewResult = @"1";
            break;
        case EKEventEditViewActionCanceled:
			webviewResult = @"2";
            break;
		case EKEventEditViewActionDeleted:
			webviewResult = @"3";
            break;
		default:
			webviewResult = @"1";
    }
	
	/*NSString* jsString2 = nil;
	jsString2 = [[NSString alloc] initWithFormat:@"window.plugins.eventManager.didFinishWithResult('%@','%@');", webviewResult, [thisEvent eventIdentifier]];
	[self.webView stringByEvaluatingJavaScriptFromString:jsString2];
	*/
	NSLog(@"Reached Success");
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self writeJavascript:[pluginResult toSuccessCallbackString:callbackId]];
	[self.viewController dismissModalViewControllerAnimated:YES];
}

@end
