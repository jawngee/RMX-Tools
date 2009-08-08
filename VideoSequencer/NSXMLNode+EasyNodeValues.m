//
//  NSXMLNode+EasyNodeValues.m
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/24/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "NSXMLNode+EasyNodeValues.h"


@implementation NSXMLNode(EasyNodeValues)

-(double)doubleValueWithDefaultValue:(double)defaultValue
{
	NSString *string=[self stringValue];
	NSScanner *scan=[NSScanner scannerWithString:string];
	double value;
	if ([scan scanDouble:&value]==YES)
		return value;
	
	return defaultValue;
}

-(NSInteger)integerValueWithDefaultValue:(NSInteger)defaultValue
{
	NSString *string=[self stringValue];
	NSScanner *scan=[NSScanner scannerWithString:string];
	NSInteger value;
	if ([scan scanInteger:&value]==YES)
		return value;
	
	return defaultValue;
}

@end
