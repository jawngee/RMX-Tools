//
//  VSPatternRef.h
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/24/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VSPattern.h"

@interface VSPatternRef : NSObject 
{
	VSPattern *pattern;
	NSInteger loop;
}

@property (retain,nonatomic) VSPattern *pattern;
@property (assign,nonatomic) NSInteger loop;

-(id)initWithPattern:(VSPattern *)thePattern loop:(NSInteger)loopCount;

@end
