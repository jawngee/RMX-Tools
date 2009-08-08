//
//  SDVideoExporter.m
//  SceneDetector
//
//  Created by Jon Gilkison on 7/30/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "SDVideoExporter.h"



@implementation SDVideoExporter

@synthesize path;
@synthesize movie;
@synthesize lastFrame;
@synthesize lastTime;
@synthesize cutCount;

-(id)initWithPath:(NSString *)filePath
{
	self.path=filePath;
	return self;
}

-(void)startWithFile:(NSString *)filename fps:(double)fps timeScale:(long)timeScale movie:(QTMovie *)theMovie
{
	self.movie=theMovie;
	lastFrame=0;
	lastTime=0;
	cutCount=0;
}

-(QTTime)getScaledTime:(NSTimeInterval)time source:(QTMovie *)source
{
	QTTime stime=QTMakeTimeWithTimeInterval(time);
	TimeScale scale=GetMovieTimeScale([source quickTimeMovie]);
	QTTime result=QTMakeTimeScaled(stime, scale);
	
	return result;
}

-(void)cutAtFrame:(UInt32)theFrame andTime:(double)theTime
{
	QTTime time=[self getScaledTime:theTime source:movie];
	QTTime duration=[self getScaledTime:theTime-lastTime source:movie];
	QTTimeRange range=QTMakeTimeRange(time, duration);
	
	QTMovie *cut=[[QTMovie alloc] initWithMovie:movie timeRange:range error:nil];
	
	NSString *outpath=[NSString stringWithFormat:@"/Users/user/Desktop/shityeah.%04d.mov",cutCount];
	[cut writeToFile:outpath withAttributes:nil error:nil];
	
	cutCount++;
	lastTime=theTime;
}

-(void)finished
{
}

@end
