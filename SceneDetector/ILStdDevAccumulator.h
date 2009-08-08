//
//  ILStdDevAccumulator.h
//  SceneDetector
//
//  Created by Jon Gilkison on 7/29/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ILStdDevAccumulator : NSObject
{
	double sum;
	double sum2;
	unsigned int num;
}

-(id)init;
-(double)value: (double)v;
-(unsigned int)count;
-(double)mean;
-(double)variance;
-(double)stddev;

@end
