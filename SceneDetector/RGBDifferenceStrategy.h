//
//  RGBDifferenceStrategy.h
//  SceneDetector
//
//  Created by Jon Gilkison on 8/7/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PixelDefs.h"

@interface RGBDifferenceStrategy : NSObject 
{
    // RGB difference threshold which indicates a scene change when at baseline RGB level 
	double baselineRgbDiffThreshold;
	double baselineRgbLevel;

	// min and max thresholds based on the ranges found in real data
	double minRgbDiffThreshold;
	double maxRgbDiffThreshold;
	
	// this much above or below threshold means we're in the uncertain range
	double baselineUncertainty;

	// amount to change diff threshold in relation to changes in RGB level (21/90, 21.395/91, etc.)
	double thresholdToLevelRatio;
	
	/// Number of random samples to take from each media frame analyzed.
	int defaultSampleSize;
	
	// positions in the frame data array at which to sample
	UInt32 *sampleLocations;
	
	// buffer of samples taken on last call to SceneChanged()
	UInt32 *prevSamples;
	
	int prevAvgDiffChange;
	int prevAvgDiff;
	int prevAvgRgbLevel;
}

-(id)init;
-(BOOL)firstFrame:(RGB24Pixel *)currentImage width:(NSInteger)width height:(NSInteger)height;
-(BOOL)nextFrame:(RGB24Pixel *)currentImage width:(NSInteger)width height:(NSInteger)height;

@end
