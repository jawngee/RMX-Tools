//
//  AbstractDetectionStrategy.h
//  SceneDetector
//
//  Created by Jon Gilkison on 8/7/09.
//  Copyright 2009 Massify. All rights reserved.
//
#import "PixelDefs.h"

@protocol AbstractDetectionStrategy

-(BOOL)firstFrame:(RGB24Pixel *)currentImage width:(NSInteger)width height:(NSInteger)height;
-(BOOL)nextFrame:(RGB24Pixel *)currentImage width:(NSInteger)width height:(NSInteger)height;

@end
