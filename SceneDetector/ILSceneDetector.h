//
//  ILSceneDetector.h
//  SceneDetector
//
//  Created by Jon Gilkison on 7/29/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ILFrameGrabber.h"
#import "ILSceneDetectorDelegate.h"
#import "ILStdDevAccumulator.h"
#import "ILExporterProtocol.h"
#import "PixelDefs.h"
#import "AbstractDetectionStrategy.h"


@interface ILSceneDetector : NSObject
{
	ILFrameGrabber *grabber;

	id <ILSceneDetectorDelegate>delegate;
	id <AbstractDetectionStrategy> strategy;
	id <ILExporterProtocol> exporter;

	double minDistance;
	
}


@property (retain, nonatomic) ILFrameGrabber *grabber;
@property (retain, nonatomic) id <ILSceneDetectorDelegate>delegate;
@property (retain, nonatomic) id <ILExporterProtocol> exporter;
@property (retain, nonatomic) id <AbstractDetectionStrategy> strategy;


-(id)initWithFile:(NSString *)filename
  minimumDistance:(double)minimumDistance
		 delegate:(id <ILSceneDetectorDelegate>)theDelegate
		 strategy:(id <AbstractDetectionStrategy>)theStrategy
		 exporter:(id <ILExporterProtocol>) theExporter;

-(void)run;

@end
