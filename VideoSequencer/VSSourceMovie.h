//
//  VSSourceMovie.h
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/24/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import <QuickTime/QuickTime.h>

@interface VSSourceMovie : NSObject 
{
	QTMovie *movie;
	NSString *path;
	NSTimeInterval duration;
	NSTimeInterval currentTime;
}

@property (retain,nonatomic) QTMovie *movie;
@property (retain,nonatomic) NSString *path;
@property NSTimeInterval duration;
@property NSTimeInterval currentTime;

-(id)initWithPath:(NSString *)filepath;

@end
