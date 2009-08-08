//
//  NSXMLNode+EasyNodeValues.h
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/24/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSXMLNode(EasyNodeValues)

-(double)doubleValueWithDefaultValue:(double)defaultValue;
-(NSInteger)integerValueWithDefaultValue:(NSInteger)defaultValue;

@end


