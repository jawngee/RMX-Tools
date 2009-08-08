//
//  ApplicationMain.m
//  ConverterCommandLine
//
//  Created by Jon Gilkison on 7/21/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "ApplicationMain.h"

@implementation ApplicationMain


-(id)init
{
	return self;
}
  
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
	
	[self writeMessage:[@"Converting" stringByAppendingString:[args stringForKey:@"input"]]];
	[self writeMessage:[@"To" stringByAppendingString:[args stringForKey:@"output"]]];
	[self writeMessage:[@"Using" stringByAppendingString:[args stringForKey:@"settings"]]];

	QuicktimeConverter *converter=[[QuicktimeConverter alloc] initWithController:self inputPath:[args stringForKey:@"input"] settingsFile:[args stringForKey:@"settings"]];
	[converter convert:[args stringForKey:@"output"]];
}

-(void)setConversionProgress:(NSString *)state progress:(double)progress
{
//	[self writeMessage:state];
	[self writeMessage:[NSString stringWithFormat:@"%f",progress]];
}

- (void)conversionStarted
{
	[self writeMessage:@"Starting"];
}

- (void)conversionFinished
{
	[self writeMessage:@"Done"];
}

@end
