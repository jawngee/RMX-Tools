//
//  ApplicatioMain.m
//  VideoRangeExtractor
//
//  Created by Jon Gilkison on 8/3/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "ApplicationMain.h"


@implementation ApplicationMain

-(void)writeMessage:(NSString *)message
{
	puts([message cStringUsingEncoding:NSUTF8StringEncoding]);
	//	NSData *data=[[message stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
	//	NSFileHandle *handle=[NSFileHandle fileHandleWithStandardOutput];
	//	[handle writeData:data];
	//	[handle release];
}

-(void)run
{
	NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
	
	NSString *input=[args stringForKey:@"input"];
	NSString *output=[args stringForKey:@"output"];
	BOOL flatten=[args boolForKey:@"flatten"];
	NSString *settings=[args stringForKey:@"settings"];
	double start=[args doubleForKey:@"start"];
	double end=[args doubleForKey:@"end"];
	
	ILVideoRangeExtractor *extractor=[[ILVideoRangeExtractor alloc] initWithController:self inputPath:input startTime:start endTime:end flatten:flatten settingsFile:settings];
	[extractor convert:output];
}

-(void)setExtractionProgress:(NSString *)state progress:(double)progress
{
	//	[self writeMessage:state];
	[self writeMessage:[NSString stringWithFormat:@"%f",progress]];
}

- (void)extractionStarted
{
	[self writeMessage:@"Starting"];
}

- (void)extractionFinished
{
	[self writeMessage:@"Done"];
}

@end
