//
//  VSEditSynth.h
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/23/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VSSequencer.h"

@interface VSEditSynth : NSObject 
{
	double BPM;
	double FPS;
	double seed;
	NSMutableArray *sources;
	VSSequencer *sequencer;
	NSString *audioFile;
}

@property (assign, nonatomic) double BPM;
@property (assign, nonatomic) double FPS;
@property (assign, nonatomic) double seed;
@property (retain, nonatomic) NSMutableArray *sources;
@property (retain, nonatomic) VSSequencer *sequencer;
@property (retain, nonatomic) NSString *audioFile;

-(id)init;
-(id)initWithXMLString:(NSString *)xmlString;
-(id)initWithXMLFile:(NSString *)filename;

-(void)generate:(NSString*)outputFile withSettings:(NSString *)settingsFile withBlack:(NSString*)theBlack withBase:(NSString *)theBase;

@end
