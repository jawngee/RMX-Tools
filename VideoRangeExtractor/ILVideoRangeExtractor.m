//
//  ILVideoRangeExtractor.m
//  ConverterCommandLine
//
//  Created by Jon Gilkison on 8/3/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "ILVideoRangeExtractor.h"


@implementation ILVideoRangeExtractor


-(id)initWithController:(id <ExtractorProgressProtocol>)controller inputPath:(NSString *)inputPath startTime:(double)startTime endTime:(double)endTime flatten:(BOOL)flattenMovie settingsFile:(NSString *)settingsFile
{
	converterController=controller;
	
	if (settingsFile!=nil)
	{
		attributes=[NSDictionary dictionaryWithContentsOfFile:settingsFile];
		[attributes retain];
		flatten=NO;
	}
	else 
		flatten=flattenMovie;
	
	NSError *error=nil;
	QTMovie *srcMovie=[QTMovie movieWithFile:inputPath error:&error];
	
	if (error!=nil)
	{
		NSLog(@"Error %@",[error localizedDescription]);
		exit([error code]);
	}

	TimeScale scale=GetMovieTimeScale([srcMovie quickTimeMovie]);
	QTTime start=QTMakeTimeScaled(QTMakeTimeWithTimeInterval(startTime), scale);
	QTTime durr=QTMakeTimeScaled(QTMakeTimeWithTimeInterval(endTime-startTime), scale);
	
	movie=[[QTMovie alloc] initWithMovie:srcMovie timeRange:QTMakeTimeRange(start,durr) error:nil];
	[movie setDelegate:self];
	[movie retain];
	
	return self;
	
}

- (BOOL)movie:(QTMovie *)movie shouldContinueOperation:(NSString *)op withPhase:(QTMovieOperationPhase)phase atPercent:(NSNumber *)percent withAttributes:(NSDictionary *)attributes
{
    NSNumber *percentDoneDouble = [NSNumber numberWithDouble:[percent doubleValue] * 100.0];
    
    switch (phase) {
        case QTMovieOperationBeginPhase:
			[converterController extractionStarted];
            break;
        case QTMovieOperationUpdatePercentPhase:
			[converterController setExtractionProgress:op progress:[percentDoneDouble doubleValue]];
            break;
        case QTMovieOperationEndPhase:
			[converterController extractionFinished];
            break;
    }
	
    return YES;
}

-(void)convert:(NSString *)outputPath
{
	if (attributes!=nil)
	{
		[movie writeToFile:outputPath withAttributes:attributes];
	}
	else if (flatten)
	{
		NSMutableDictionary *attrDict = [[NSMutableDictionary alloc] initWithDictionary: [movie movieAttributes]];

        [attrDict setObject: [NSNumber numberWithBool:YES] forKey:QTMovieFlatten];
		
		[movie writeToFile:outputPath withAttributes:attrDict];
	}
	else
		[movie writeToFile:outputPath withAttributes:nil];
}


@end
