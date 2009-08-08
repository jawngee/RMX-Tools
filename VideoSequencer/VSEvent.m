//
//  VSEvent.m
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/24/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "VSEvent.h"


@implementation VSEvent

@synthesize startTime;
@synthesize length;
@synthesize eventAction;

-(id)initWithStart:(NSTimeInterval)start andLength:(NSTimeInterval)theLength forAction:(VSAction)theAction
{
	if (self=[super init])
	{
		startTime=start;
		length=theLength;
		eventAction=theAction;
	}
	
	return self;
}

@end
