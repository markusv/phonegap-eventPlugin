//
//  EventManager.h
//  iAmMobile
//
//  Created by Markus Voss on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>


@interface EventManager : PGPlugin <EKEventEditViewDelegate>{
	EKEventStore *myEventStore;
}

- (void) newEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) addEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
