//
//  SDXMLExporter.m
//  SceneDetector
//
//  Created by Jon Gilkison on 7/30/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "SDXMLExporter.h"


@implementation SDXMLExporter


-(id)initWithFile:(NSString *)filename
{
	outputFile=filename;
	
	doc=[[NSXMLDocument alloc] init];
	
	return self;
}

-(void)startWithFile:(NSString *)filename fps:(double)fps timeScale:(long)timeScale movie:(QTMovie *)theMovie
{
	NSXMLElement *root=[[NSXMLElement alloc] init];
	
	[root setName:@"scenes"];
	[doc setRootElement:root];
	
	NSXMLElement *info=[[NSXMLElement alloc] init];
	[info setName:@"info"];
	[root addChild:info];

	NSXMLElement *ele=[[NSXMLElement alloc] init];
	[ele setName:@"file"];
	[ele setStringValue:filename];
	[info addChild:ele];

	ele=[[NSXMLElement alloc] init];
	[ele setName:@"fps"];
	[ele setStringValue:[NSString stringWithFormat:@"%f", fps]];
	[info addChild:ele];

	ele=[[NSXMLElement alloc] init];
	[ele setName:@"timescale"];
	[ele setStringValue:[NSString stringWithFormat:@"%d", timeScale]];
	[info addChild:ele];
	
	cuts=[[NSXMLElement alloc] init];
	
	[cuts setName:@"cuts"];
	[root addChild:cuts];
}

-(void)cutAtFrame:(UInt32)theFrame andTime:(double)theTime
{
	NSXMLElement *cut=[[NSXMLElement alloc] init];
	
	NSNumber *frame=[NSNumber numberWithInteger:theFrame];

	NSInteger hours=theTime/3600;
	NSInteger minutes=(theTime/60)-(hours*60);
	NSInteger seconds=theTime-((minutes*60)+(hours*3600));
	NSInteger ms=(NSInteger)((theTime-seconds)*1000);
    NSString *timecode=([NSString stringWithFormat:@"%02d:%02d:%02d.%03d", hours, minutes, seconds, ms]);
	
	[cut setName:@"cut"];
	[cut setAttributesAsDictionary:[NSDictionary dictionaryWithObjectsAndKeys: frame, @"frame", [NSString stringWithFormat:@"%.3f",theTime], @"time", timecode, @"timecode", nil]];
	[cuts addChild:cut];
}

-(void)finished
{
	NSData *xmlData = [doc XMLDataWithOptions:NSXMLNodePrettyPrint];
	[xmlData writeToFile:outputFile atomically:YES];
}

@end
