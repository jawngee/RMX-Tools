//
//  QuicktimeConverter.m
//  ConverterCommandLine
//
//  Created by Jon Gilkison on 7/20/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "QuicktimeConverter.h"


@implementation QuicktimeConverter

-(id)initWithController:(id <ConverterController>)controller inputPath:(NSString *)inputPath settingsFile:(NSString *)settingsFile
{
	converterController=controller;
	
	attributes=[NSDictionary dictionaryWithContentsOfFile:settingsFile];
	[attributes retain];
	
	movie=[QTMovie movieWithFile:inputPath error:nil];
	[movie setDelegate:self];
	[movie retain];
	
	return self;
	
}

- (BOOL)movie:(QTMovie *)movie shouldContinueOperation:(NSString *)op withPhase:(QTMovieOperationPhase)phase atPercent:(NSNumber *)percent withAttributes:(NSDictionary *)attributes
{
    NSNumber *percentDoneDouble = [NSNumber numberWithDouble:[percent doubleValue] * 100.0];
    
    switch (phase) {
        case QTMovieOperationBeginPhase:
			[converterController conversionStarted];
            break;
        case QTMovieOperationUpdatePercentPhase:
			[converterController setConversionProgress:op progress:[percentDoneDouble doubleValue]];
            break;
        case QTMovieOperationEndPhase:
			[converterController conversionFinished];
            break;
    }
	
    return YES;
}

-(void)convert:(NSString *)outputPath
{
	[movie writeToFile:outputPath withAttributes:attributes];
}


@end
