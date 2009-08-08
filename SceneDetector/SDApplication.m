//
//  SDApplication.m
//  SceneDetector
//
//  Created by Jon Gilkison on 7/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SDApplication.h"
#import <AppKit/AppKit.h>
#import "ILFrameGrabber.h"

#import "SDXMLExporter.h"
#import "SDVideoExporter.h"

#import "ILExporterProtocol.h"
#import "FrameDifferenceStrategy.h"
#import "RGBDifferenceStrategy.h"

@implementation SDApplication

-(id)init
{
	if (self=[super init])
	{
		// in case we need to use NSImage
		[NSApplication sharedApplication];
	}
	
	return self;
}

-(void)run
{
	NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
	
	NSString *input=[args stringForKey:@"input"];
	
	NSString *format=[args stringForKey:@"exporter"];
	NSString *output=[args stringForKey:@"output"];
	
	double minDifference=[args doubleForKey:@"difference"];
	double minDistance=[args doubleForKey:@"distance"];

	if (minDifference<=0)
		minDifference=0.20;
	if (minDistance<=0)
		minDistance=0.5;

	id<ILExporterProtocol> exporter=nil;
		
	if ([format isEqualToString:@"xml"])
		exporter=[[SDXMLExporter alloc] initWithFile:output];
	else if ([format isEqualToString:@"xml"])
		exporter=[[SDVideoExporter alloc] initWithPath:output];
	
	NSString *strategyType=[args stringForKey:@"strategy"];
	
	id<AbstractDetectionStrategy> strategy;
	
	if ([strategyType isEqualToString:@"rgb"])
		strategy=[[RGBDifferenceStrategy alloc] init];
	else
		strategy=[[FrameDifferenceStrategy alloc] initWithDifference:minDifference];
	
	ILSceneDetector *detector=[[ILSceneDetector alloc] initWithFile:input minimumDistance:minDistance delegate:self strategy:strategy exporter:exporter];
	
	[detector run];
}

-(void)status:(UInt32)currentFrame totalFrames:(UInt32)totalFrames fps:(double)fps
{
	NSString *message=[NSString stringWithFormat:@"%f",(double)currentFrame/(double)totalFrames];
	puts([message cStringUsingEncoding:NSUTF8StringEncoding]);
}
@end
