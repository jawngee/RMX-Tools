//
//  ApplicatioMain.h
//  VideoRangeExtractor
//
//  Created by Jon Gilkison on 8/3/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ILVideoRangeExtractor.h"

@interface ApplicationMain : NSObject<ExtractorProgressProtocol> 
{

}

-(void)run;


@end
