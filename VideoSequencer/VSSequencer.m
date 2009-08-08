//
//  VSSequencer.m
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/23/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "VSSequencer.h"
#import "VSPattern.h"
#import "VSPatternRef.h"
#import "NSXMLNode+EasyNodeValues.h"

@implementation VSSequencer

@synthesize patterns;
@synthesize playlist;

-(id)init
{
	if (self=[super init])
	{
		patterns=[[NSMutableDictionary alloc] init];
		playlist=[[NSMutableArray alloc] init];
	}
	
	return self;
}

-(id)initWithXMLNode:(NSXMLNode *)node
{
	if (self=[super init])
	{
		patterns=[[NSMutableDictionary alloc] init];
		playlist=[[NSMutableArray alloc] init];

		NSError *err=nil;
		NSArray *nodes=[node nodesForXPath:@".//patterns/pattern" error:&err];
		for(int i=0; i<[nodes count]; i++)
		{
			VSPattern *pattern=[[VSPattern alloc] initWithXMLNode:[nodes objectAtIndex:i]];
			[patterns setValue:pattern forKey:pattern.identifier];
		}

		nodes=[node nodesForXPath:@".//playlist/patternref" error:&err];
		for(int i=0; i<[nodes count]; i++)
		{
			NSXMLElement *ele=(NSXMLElement *)[nodes objectAtIndex:i];
			
			NSString *patId=[[ele attributeForName:@"id"] stringValue];
			NSInteger loop=[[ele attributeForName:@"loop"] integerValueWithDefaultValue:1];

			VSPattern *pattern=[patterns objectForKey:patId];
			
			if (pattern)
			{
				VSPatternRef *ref=[[VSPatternRef alloc] initWithPattern:pattern loop:loop];
				[playlist addObject:ref];
			}
		}
	}
	
	return self;
}

-(NSMutableArray *)generateEventList:(double)barLength
{
	NSMutableArray *result=[[NSMutableArray alloc] init];
	
	NSTimeInterval runningTime=0;
	
	for(int i=0; i<[playlist count]; i++)
	{
		VSPatternRef *ref=[playlist objectAtIndex:i];
		
		for(int l=0; l<ref.loop; l++)
		{
			[result addObjectsFromArray:[ref.pattern generateEventList:&runningTime barLength:barLength]];
			runningTime+=barLength;
		}
	}
	
	return result;
}
					
@end
