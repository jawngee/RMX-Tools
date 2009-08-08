//
//  ILStdDevAccumulator.m
//  SceneDetector
//
//  Created by Jon Gilkison on 7/29/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "ILStdDevAccumulator.h"

@implementation ILStdDevAccumulator
-(id)init
{
	sum = sum2 = 0.0;
	num = 0;
	return self;
}
-(double)value: (double)v
{
	sum = sum + v;
	sum2 = sum2 + v*v;
	num++;
	return [self stddev];
}
-(unsigned int)count
{
	return num;
}
-(double)mean
{
	return (num>0) ? sum/(double)num : 0.0;
}
-(double)variance
{
	double m = [self mean];
	return (num>0) ? (sum2/(double)num - m*m) : 0.0;
}
-(double)stddev
{
	return sqrt([self variance]);
}
@end
