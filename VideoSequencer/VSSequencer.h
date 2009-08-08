//
//  VSSequencer.h
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/23/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface VSSequencer : NSObject 
{
	NSMutableDictionary *patterns;
	NSMutableArray *playlist;
}

@property (retain,nonatomic) NSMutableDictionary *patterns;
@property (retain,nonatomic) NSMutableArray *playlist;

-(id)init;
-(id)initWithXMLNode:(NSXMLNode *)node;

-(NSMutableArray *)generateEventList:(double)barLength;

@end
