//
//  SDXMLExporter.h
//  SceneDetector
//
//  Created by Jon Gilkison on 7/30/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ILExporterProtocol.h"
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>

@interface SDVideoExporter : NSObject<ILExporterProtocol> 
{
	NSString *path;
	QTMovie *movie;
	UInt32 lastFrame;
	double lastTime;
	NSInteger cutCount;
}

@property (retain, nonatomic) NSString *path;
@property (retain, nonatomic) QTMovie *movie;
@property (assign, nonatomic) UInt32 lastFrame;
@property (assign, nonatomic) double lastTime;
@property (assign, nonatomic) NSInteger cutCount;

-(id)initWithPath:(NSString *)path;

-(void)startWithFile:(NSString *)filename fps:(double)fps timeScale:(long)timeScale movie:(QTMovie *)theMovie;
-(void)cutAtFrame:(UInt32)theFrame andTime:(double)theTime;
-(void)finished;

@end
