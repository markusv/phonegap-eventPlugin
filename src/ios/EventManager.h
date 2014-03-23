//
//  EventManager.h
//  
//
//  Created by Markus Voss on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>


@interface EventManager : CDVPlugin <EKEventEditViewDelegate>{
	EKEventStore *myEventStore;
}

- (void) addEvent:(CDVInvokedUrlCommand*)command;
- (void) newEvent:(CDVInvokedUrlCommand*)command;

@end
