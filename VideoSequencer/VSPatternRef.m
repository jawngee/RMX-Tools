//
//  VSPatternRef.m
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/24/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "VSPatternRef.h"


@implementation VSPatternRef

@synthesize pattern;
@synthesize loop;

-(id)initWithPattern:(VSPattern *)thePattern loop:(NSInteger)loopCount
{
	if (self=[super init])
	{
		pattern=thePattern;
		loop=loopCount;
	}
	
	return self;
}

@end
