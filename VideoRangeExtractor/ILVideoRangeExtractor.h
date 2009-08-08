//
//  ILVideoRangeExtractor.h
//  ConverterCommandLine
//
//  Created by Jon Gilkison on 8/3/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>

@protocol ExtractorProgressProtocol

-(void)setExtractionProgress:(NSString *)state progress:(double)progress;

- (void)extractionStarted;
- (void)extractionFinished;

@end

@interface ILVideoRangeExtractor : NSObject 
{
@public
	QTMovie					*movie;
@private
	id		<ExtractorProgressProtocol>converterController;
	
	NSDictionary			*attributes;
	
	BOOL flatten;
}

-(id)initWithController:(id <ExtractorProgressProtocol>)controller inputPath:(NSString *)inputPath startTime:(double)startTime endTime:(double)endTime flatten:(BOOL)flattenMovie settingsFile:(NSString *)settingsFile;
-(void)convert:(NSString *)outputPath;

@end
