//
//  ILSceneDetector.m
//  SceneDetector
//
//  Created by Jon Gilkison on 7/29/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "ILSceneDetector.h"


@implementation ILSceneDetector

@synthesize grabber;
@synthesize strategy;
@synthesize delegate;
@synthesize exporter;

-(id)initWithFile:(NSString *)filename
  minimumDistance:(double)minimumDistance
		 delegate:(id <ILSceneDetectorDelegate>)theDelegate
		 strategy:(id <AbstractDetectionStrategy>)theStrategy
		 exporter:(id <ILExporterProtocol>) theExporter
{
	if (self=[super init])
	{
		grabber=[[ILFrameGrabber alloc] initWithFile:filename];
		delegate=theDelegate;
		minDistance=minimumDistance;
		exporter=theExporter;
		strategy=theStrategy;
	}
	
	return self;
}

-(void)run
{
	QTTime duration=[grabber.movie duration];
	double durationS=duration.timeValue/duration.timeScale;
	double movieFPS=grabber.frameCount/durationS;
	
	[exporter startWithFile:[grabber.movie attributeForKey:QTMovieFileNameAttribute] fps:movieFPS timeScale:grabber.timeScale movie:grabber.movie];
	
	[grabber rewind];

	[strategy firstFrame:grabber.pixelData width:grabber.width height:grabber.height];
	[grabber next];
	
	while(grabber.currentFrame!=grabber.frameCount-1)
	{
		NSDate *start = [NSDate date];

		BOOL change=[strategy nextFrame:grabber.pixelData width:grabber.width height:grabber.height];

		if (change==YES)
			[exporter cutAtFrame:grabber.currentFrame andTime:(double)grabber.currentTime/(double)grabber.timeScale];

		NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:start];
		double fps=1/timeInterval;
		
		[delegate status:[grabber currentFrame] totalFrames:grabber.frameCount fps:fps];

		[grabber next];
		
	}
	
	[exporter finished];
}

@end
