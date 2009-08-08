//
//  ApplicationMain.h
//  ConverterCommandLine
//
//  Created by Jon Gilkison on 7/21/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QuicktimeConverter.h"


@interface ApplicationMain : NSObject<ConverterController> 
{

}

-(id)init;
-(void)run;

-(void)setConversionProgress:(NSString *)state progress:(double)progress;

- (void)conversionStarted;
- (void)conversionFinished;

@end
