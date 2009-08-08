//
//  VSPattern.h
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/23/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VSPattern : NSObject 
{
	NSString *identifier;
	NSInteger resolution;
	NSMutableArray *steps;
}

@property (retain, nonatomic) NSString *identifier;
@property (assign, nonatomic) NSInteger resolution;
@property (retain, nonatomic) NSMutableArray *steps;

-(id)initWithXMLNode:(NSXMLNode *)node;
-(NSMutableArray *)generateEventList:(NSTimeInterval *)runningTime barLength:(double)barLength;

@end
