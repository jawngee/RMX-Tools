//
//  VSPattern.m
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/23/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "VSPattern.h"
#import "VSStep.h"
#import "NSXMLNode+EasyNodeValues.h"
#import "VSEvent.h"

@implementation VSPattern

@synthesize identifier;
@synthesize resolution;
@synthesize steps;

-(id)initWithXMLNode:(NSXMLNode *)node
{
	if (self=[super init])
	{
		steps=[[NSMutableArray alloc] init];
		resolution=[[(NSXMLElement *)node attributeForName:@"resolution"] integerValueWithDefaultValue:16];
		identifier=[[(NSXMLElement *)node attributeForName:@"id"] stringValue];

		NSError *err=nil;
		NSArray *nodes=[node nodesForXPath:@".//step" error:&err];
		for(int i=0; i<[nodes count]; i++)
		{
			VSStep *step=[[VSStep alloc] initWithXMLNode:[nodes objectAtIndex:i]];
			[steps addObject:step];
		}
	}
	
	return self;
}

-(NSMutableArray *)generateEventList:(NSTimeInterval *)runningTime barLength:(double)barLength
{
	double stepLength=barLength/resolution;
	
	// bar length in seconds
	// step length is bar/resolution
	

	NSMutableArray *result=[[NSMutableArray alloc] init];
	
	double startTime=*runningTime;
	
	for(int i=0; i<[steps count]; i++)
	{
		VSStep *step=[steps objectAtIndex:i];
		
		NSTimeInterval eventTime=(double)step.index*stepLength;
		double length=0;
	
		if (i<([steps count]-1))
			length=(([[steps objectAtIndex:i+1] index]-step.index)*stepLength);
		else
			length=((resolution-step.index)*stepLength);

		[result addObject:[[VSEvent alloc] initWithStart:startTime+eventTime andLength:length forAction:step.stepAction]];
		
	}

	return result;
}

@end
