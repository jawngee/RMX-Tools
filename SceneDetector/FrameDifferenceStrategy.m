//
//  FrameDifferenceStrategy.m
//  SceneDetector
//
//  Created by Jon Gilkison on 8/7/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "FrameDifferenceStrategy.h"


@implementation FrameDifferenceStrategy

-(id)initWithDifference:(double)minDiff
{
	if (self=[super init])
	{
		minDifference=minDiff;
		sampleWidth=32;
		sampleHeight=32;
	}
	
	return self;
}

-(BOOL)firstFrame:(RGB24Pixel *)currentImage width:(NSInteger)width height:(NSInteger)height
{
	return [self nextFrame:currentImage width:width height:height];
}


-(BOOL)nextFrame:(RGB24Pixel *)currentImage width:(NSInteger)width height:(NSInteger)height;
{
	double quantize=96.0;
	
	GrayPixel *destPixels=malloc(sampleWidth*sampleHeight*2);
	
	UInt32 xDelta=width/sampleWidth;
	UInt32 yDelta=height/sampleHeight;
	
	
	for(int y=0; y<sampleHeight; y++)
	{
		for (int x=0; x<sampleWidth; x++)
		{
			double gray=0;
			
			for(int dy=0; dy<yDelta; dy++)
				for(int dx=0; dx<xDelta; dx++)
				{
					int px=(x*xDelta)+dx;
					int py=(y*yDelta)+dy;
					
					RGB24Pixel *pixel=&(currentImage[px+(py*width)]);
					gray+=(0.299 * (double)pixel->red + 0.587 * (double)pixel->green + 0.114 * (double)pixel->blue);
				}
			
			gray=gray/(xDelta*yDelta);
			GrayPixel *destPixel=&(destPixels[x+(y*sampleWidth)]);
			destPixel->gray=(int)(gray/quantize);
			destPixel->gray=destPixel->gray*quantize;
			destPixel->alpha=255;
		}
	}

	int difference=0;
	
	if (lastImage!=nil)
	{
		for(int y=0; y<sampleHeight; y++)
			for(int x=0; x<sampleWidth; x++)
			{
				GrayPixel *last=&(lastImage[x+(y*sampleHeight)]);
				GrayPixel *current=&(destPixels[x+(y*sampleHeight)]);
				
				if (last->gray!=current->gray)
					difference++;
			}
		
		free(lastImage);
	}
	
	lastImage=destPixels;
	
	double diff=difference/256.0;
	
	if (diff>minDifference)
		return YES;
	
	return NO;
}

@end
