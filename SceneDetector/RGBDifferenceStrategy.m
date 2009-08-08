//
//  RGBDifferenceStrategy.m
//  SceneDetector
//
//  Created by Jon Gilkison on 8/7/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "RGBDifferenceStrategy.h"


@implementation RGBDifferenceStrategy

-(id)init
{
	if (self=[super init])
	{
		baselineRgbDiffThreshold = 21;
		baselineRgbLevel = 90;
		minRgbDiffThreshold = 5;
		maxRgbDiffThreshold = 45;
		baselineUncertainty = 5;
		thresholdToLevelRatio = .395;

		defaultSampleSize = 2000;
		
		sampleLocations=calloc(defaultSampleSize,sizeof(UInt32 *));
		prevSamples=calloc(defaultSampleSize*3,sizeof(UInt32 *));
	}
	
	return self;
}

-(NSInteger)randomIntBetween:(NSInteger)a and:(NSInteger)b
{
    int range = b - a < 0 ? b - a - 1 : b - a + 1; 
    int value = (int)(range * ((float)random() / (float) LONG_MAX));
    return value == range ? a : a + value;
}


-(BOOL)wasPrevNewScene:(int)avgDiffChange avgRgbLevel:(int)avgRgbLevel
{
	double prevRgbLevelVariance = prevAvgRgbLevel - baselineRgbLevel;
	double prevDiffThreshold = (prevRgbLevelVariance * thresholdToLevelRatio) + baselineRgbDiffThreshold;
	
	prevDiffThreshold = (int)((maxRgbDiffThreshold<prevDiffThreshold) ? maxRgbDiffThreshold : prevDiffThreshold);
	prevDiffThreshold = (int)((minRgbDiffThreshold>prevDiffThreshold) ? minRgbDiffThreshold : prevDiffThreshold);
	
	if ((prevAvgDiffChange > prevDiffThreshold) && (avgDiffChange < (-prevAvgDiffChange * .5)))
		return YES;
	
	return NO;
}

-(BOOL)firstFrame:(RGB24Pixel *)currentImage width:(NSInteger)width height:(NSInteger)height
{
	srandom(time(0));
	
	UInt32 dataSize=width*height*3;
	
	for (int k = 0; k < defaultSampleSize; k++)
		sampleLocations[k] = [self randomIntBetween:0 and:dataSize];
	
	return [self nextFrame:currentImage width:width height:height];
}


-(BOOL)nextFrame:(RGB24Pixel *)currentImage width:(NSInteger)width height:(NSInteger)height
{
	
	BOOL sceneChanged = NO;
	
	Byte* b = (Byte*)currentImage;
	
	int lastLocation = 0;
	int sumDiffs = 0;
	int sumRgbLevels = 0;
	
	for (int k = 0; k < defaultSampleSize; k++)
	{
		b += sampleLocations[k] - lastLocation;
		// using xor rather than simple difference amplifies all differences, making scene changes more distinct
		sumDiffs += (*b ^ prevSamples[k]);
		sumRgbLevels += *b;
		
		lastLocation = sampleLocations[k];
		prevSamples[k] = *b;
	}
	
	int avgRgbLevel = sumRgbLevels / defaultSampleSize;
	int avgDiff = sumDiffs / defaultSampleSize;
	int avgDiffChange = avgDiff - prevAvgDiff;

	if ([self wasPrevNewScene:avgDiffChange avgRgbLevel:avgRgbLevel])
		sceneChanged = YES;

	prevAvgRgbLevel = avgRgbLevel;
	prevAvgDiffChange = avgDiffChange;
	prevAvgDiff = avgDiff;
	
	return sceneChanged;
}

@end
