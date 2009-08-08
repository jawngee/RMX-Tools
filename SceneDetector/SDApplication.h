//
//  SDApplication.h
//  SceneDetector
//
//  Created by Jon Gilkison on 7/29/09.
//  Copyright 2009 Interface Lab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ILSceneDetector.h"

@interface SDApplication : NSObject<ILSceneDetectorDelegate>
{
}

-(id)init;
-(void)run;
-(void)status:(UInt32)currentFrame totalFrames:(UInt32)totalFrames fps:(double)fps;

@end
