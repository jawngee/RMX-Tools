//
//  ILSceneDetectorDelegate.h
//  SceneDetector
//
//  Created by Jon Gilkison on 7/29/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol ILSceneDetectorDelegate
-(void)status:(UInt32)currentFrame totalFrames:(UInt32)totalFrames fps:(double)fps;
@end