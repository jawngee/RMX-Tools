//
//  VSStep.m
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/23/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "VSStep.h"
#import "NSXMLNode+EasyNodeValues.h"


@implementation VSStep

@synthesize stepAction;
@synthesize index;

-(id)initWithXMLNode:(NSXMLNode *)node
{
	if (self=[super init])
	{
		NSString *action=[[[(NSXMLElement *)node attributeForName:@"action"] stringValue] lowercaseString];
		
		if ([action isEqualToString:@"off"])
			stepAction=vsOffAction;
		else
			stepAction=vsOnAction;
		
		index=[[(NSXMLElement *)node attributeForName:@"index"] integerValueWithDefaultValue:0];
	}
	
	return self;
}
@end
