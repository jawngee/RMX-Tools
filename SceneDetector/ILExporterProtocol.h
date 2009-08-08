//
//  SDExporterProtocol.h
//  SceneDetector
//
//  Created by Jon Gilkison on 7/30/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import <QuickTime/QuickTime.h>

@protocol ILExporterProtocol

-(void)startWithFile:(NSString *)filename fps:(double)fps timeScale:(long)timeScale movie:(QTMovie *)theMovie;
-(void)cutAtFrame:(UInt32)theFrame andTime:(double)theTime;
-(void)finished;

@end
