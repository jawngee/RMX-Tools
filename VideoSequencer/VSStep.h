//
//  VSStep.h
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/23/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum
{
	vsOnAction,
	vsOffAction
} VSAction;

@interface VSStep : NSObject 
{
	NSInteger index;
	VSAction stepAction;
}

@property NSInteger index;
@property VSAction stepAction;

-(id)initWithXMLNode:(NSXMLNode *)node;

@end
