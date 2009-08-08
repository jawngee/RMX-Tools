//
//  VSSourceMovie.m
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/24/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "VSSourceMovie.h"


@implementation VSSourceMovie

@synthesize movie;
@synthesize path;
@synthesize duration;
@synthesize currentTime;

-(id)initWithPath:(NSString *)filepath
{
	if (self=[super init])
	{
		movie=[[QTMovie alloc] initWithFile:filepath error:nil];
		path=filepath;
		NSTimeInterval interval=0;
		QTGetTimeInterval([movie duration], &interval);
		duration=interval;
		currentTime=0;
	}
	
	return self;
}

@end
