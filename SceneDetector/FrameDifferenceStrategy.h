//
//  FrameDifferenceStrategy.h
//  SceneDetector
//
//  Created by Jon Gilkison on 8/7/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AbstractDetectionStrategy.h"
#import "PixelDefs.h"

@interface FrameDifferenceStrategy : NSObject<AbstractDetectionStrategy> 
{
@private
	GrayPixel *lastImage;
	double minDifference;
	int sampleWidth;
	int sampleHeight;
}

-(id)initWithDifference:(double)minDiff;

-(BOOL)firstFrame:(RGB24Pixel *)currentImage width:(NSInteger)width height:(NSInteger)height;
-(BOOL)nextFrame:(RGB24Pixel *)currentImage width:(NSInteger)width height:(NSInteger)height;

@end
