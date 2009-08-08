//
//  VSEvent.h
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/24/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VSStep.h"

@interface VSEvent : NSObject 
{
	NSTimeInterval startTime;
	NSTimeInterval length;
	VSAction eventAction;
}

@property NSTimeInterval startTime;
@property NSTimeInterval length;
@property VSAction eventAction;

-(id)initWithStart:(NSTimeInterval)start andLength:(NSTimeInterval)theLength forAction:(VSAction)theAction;

@end
