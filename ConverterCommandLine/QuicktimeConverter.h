//
//  QuicktimeConverter.h
//  ConverterCommandLine
//
//  Created by Jon Gilkison on 7/20/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import <QuickTime/QuickTime.h>
#import <QuickTime/QuickTimeComponents.h>

@protocol ConverterController

-(void)setConversionProgress:(NSString *)state progress:(double)progress;

- (void)conversionStarted;
- (void)conversionFinished;

@end

@interface QuicktimeConverter : NSObject 
{
	QTMovie					*movie;
	id		<ConverterController>converterController;
	NSDictionary			*attributes;
}

-(id)initWithController:(id <ConverterController>)controller inputPath:(NSString *)inputPath settingsFile:(NSString *)settingsFile;
-(void)convert:(NSString *)outputPath;

@end
