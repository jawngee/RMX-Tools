//
//  VSApplication.m
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/24/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "VSApplication.h"
#import "VSEditSynth.h"

@implementation VSApplication

-(id)init
{
	return [super init];
}

-(void)run
{
	NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
	
	NSString *source=[args stringForKey:@"input"];
	NSString *settingsFile=[args stringForKey:@"settings"];
	NSString *output=[args stringForKey:@"output"];
	NSString *blackSource=[args stringForKey:@"black"];
	NSString *base=[args stringForKey:@"base"];

	VSEditSynth *synth=[[VSEditSynth alloc] initWithXMLFile:source];
	[synth generate:output withSettings:settingsFile withBlack:blackSource withBase:base];
}
@end
