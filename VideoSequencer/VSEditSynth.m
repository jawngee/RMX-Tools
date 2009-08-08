//
//  VSEditSynth.m
//  VideoSequencer
//
//  Created by Jon Gilkison on 7/23/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "VSEditSynth.h"
#import "VSSourceMovie.h"
#import "NSXMLNode+EasyNodeValues.h"
#import <QTKit/QTKit.h>
#import <QuickTime/QuickTime.h>
#import <ScreenSaver/ScreenSaver.h>
#import "VSEvent.h"
#import <QuickTime/QuickTimeErrors.h>
@implementation VSEditSynth

#pragma mark properties

@synthesize BPM;
@synthesize sources;
@synthesize sequencer;
@synthesize FPS;
@synthesize seed;
@synthesize audioFile;

#pragma mark private variables

NSXMLDocument *xmlDoc;


#pragma mark private methods

-(void)parseDoc
{
	NSError *err=nil;
	NSArray *nodes=[xmlDoc nodesForXPath:@".//synth/info/bpm" error:&err];
	if ([nodes count]>0)
		BPM=[[nodes objectAtIndex:0] doubleValueWithDefaultValue:120];

	nodes=[xmlDoc nodesForXPath:@".//synth/info/fps" error:&err];
	if ([nodes count]>0)
		FPS=[[nodes objectAtIndex:0] doubleValueWithDefaultValue:24];

	nodes=[xmlDoc nodesForXPath:@".//synth/info/seed" error:&err];
	if ([nodes count]>0)
		seed=[[nodes objectAtIndex:0] integerValueWithDefaultValue:666];

	nodes=[xmlDoc nodesForXPath:@".//synth/info/audio" error:&err];
	if ([nodes count]>0)
		audioFile=[[nodes objectAtIndex:0] stringValue];
	
	nodes=[xmlDoc nodesForXPath:@".//synth/sources/source" error:&err];
	for(int i=0; i<[nodes count]; i++)
	{
		NSString *attrVal=[[[nodes objectAtIndex:i] attributeForName:@"src"] stringValue];
		[sources addObject:[[VSSourceMovie alloc] initWithPath:attrVal]];
	}

	nodes=[xmlDoc nodesForXPath:@".//synth/sequencer" error:&err];
	if([nodes count]>0)
	{
		if (sequencer)
			sequencer=nil;
		
		sequencer=[[VSSequencer alloc] initWithXMLNode:[nodes objectAtIndex:0]];
	}
}

#pragma mark constructors

-(id)init
{
	if (self=[super init])
	{
		BPM=120;
		seed=666;
		sources=[[NSMutableArray alloc] init];
		sequencer=[[VSSequencer alloc] init];
	}
	
	return self;
}

-(id)initWithXMLString:(NSString *)xmlString
{
	if (self=[super init])
	{
		BPM=120;
		seed=666;
		sources=[[NSMutableArray alloc] init];
		sequencer=[[VSSequencer alloc] init];

		NSError *err=nil;

		xmlDoc = [[NSXMLDocument alloc] initWithXMLString:xmlString 
													  options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
														error:&err];
		if (xmlDoc == nil) 
			xmlDoc = [[NSXMLDocument alloc] initWithXMLString:xmlString
														  options:NSXMLDocumentTidyXML
															error:&err];
		if (xmlDoc == nil)  
			return nil;
		
		if (err)
			return nil;
		
		[self parseDoc];
	}
	
	return self;
}

-(id)initWithXMLFile:(NSString *)filename
{
	if (self=[super init])
	{
		BPM=120;
		seed=666;
		sources=[[NSMutableArray alloc] init];
		sequencer=[[VSSequencer alloc] init];

		NSError *err=nil;
		NSURL *furl = [NSURL fileURLWithPath:filename];
		if (!furl) 
		{
			NSLog(@"Can't create an URL from file %@.", filename);
			return nil;
		}
		
		xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:furl
													  options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
														error:&err];
		if (xmlDoc == nil) 
			xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:furl
														  options:NSXMLDocumentTidyXML
															error:&err];
		if (xmlDoc == nil)  
			return nil;
		
		if (err)
			return nil;
		
		[self parseDoc];
	}
	
	return self;
}

#pragma mark generate

NSInteger lastSourceIndex;


-(void)writeMessage:(NSString *)message
{
	puts([message cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(NSInteger)randomIntBetween:(NSInteger)a and:(NSInteger)b
{
    int range = b - a < 0 ? b - a - 1 : b - a + 1; 
    int value = (int)(range * ((float)random() / (float) LONG_MAX));
    return value == range ? a : a + value;
}


-(NSInteger)getNextSourceIndex
{
	NSInteger result=-666;
	
	do 
	{
		result=[self randomIntBetween:0 and:[sources count]-1];
//		NSLog(@"Next Index:%d",result);
		if (result != lastSourceIndex)
			break;
	} 
	while(true);
	
	lastSourceIndex=result;
	return result;
}

-(VSSourceMovie *)getNextSource
{
	NSInteger max=([sources count]>4) ? 4 : [sources count]-1;
	
	NSInteger result=[self randomIntBetween:0 and:max];
		//		NSLog(@"Next Index:%d",result);
		
	VSSourceMovie *source=[sources objectAtIndex:result];
	[sources removeObjectAtIndex:result];
	[sources addObject:source];

	lastSourceIndex=result;
	
	return source;
}

NSInteger lastPercentDone;

- (BOOL)movie:(QTMovie *)movie shouldContinueOperation:(NSString *)op withPhase:(QTMovieOperationPhase)phase atPercent:(NSNumber *)percent withAttributes:(NSDictionary *)attributes
{
    NSNumber *percentDoneDouble = [NSNumber numberWithDouble:[percent doubleValue] * 100.0];
	NSInteger percentDone=[percentDoneDouble intValue];
    
    switch (phase) {
        case QTMovieOperationBeginPhase:
			NSLog(@"Start.");
            break;
        case QTMovieOperationUpdatePercentPhase:
			if (percentDone!=lastPercentDone)
			{
				[self writeMessage:[NSString stringWithFormat:@"%f",[percentDoneDouble doubleValue]]];
				
				//NSLog(@"%@ .. %1.f%%",op,percentDoneDouble);
			}
			lastPercentDone=percentDone;
            break;
        case QTMovieOperationEndPhase:
			NSLog(@"Done.");
            break;
    }
	
    return YES;
}

-(QTTime)getScaledTime:(NSTimeInterval)time source:(QTMovie *)movie
{
	QTTime stime=QTMakeTimeWithTimeInterval(time);
	TimeScale scale=GetMovieTimeScale([movie quickTimeMovie]);
	QTTime result=QTMakeTimeScaled(stime, scale);
	
	return result;
}


-(void)generate:(NSString*)outputFile withSettings:(NSString *)settingsFile withBlack:(NSString*)theBlack withBase:(NSString *)theBase
{
	srandom(seed);
	
	lastSourceIndex=-666;
	
	NSMutableArray *events=[sequencer generateEventList:(60.0/BPM)*4.0];
	QTMovie *movie=[[QTMovie alloc] init];
	[movie setAttribute:[NSNumber numberWithBool:YES] forKey:QTMovieEditableAttribute]; /* make movie editable */
	
	QTMovie *blackMovie=[[QTMovie alloc] initWithFile:theBlack error:nil];
	
	
	NSTimeInterval totalTime=0;
	OSErr err;
	
	for(int i=0; i<[events count]; i++)
	{
		VSEvent *event=[events objectAtIndex:i];
		if (event.eventAction==vsOnAction)
		{
//			NSInteger current=[self getNextSourceIndex];
//			VSSourceMovie *source=[sources objectAtIndex:current];
			VSSourceMovie *source=[self getNextSource];
			[source.movie setAttribute:[NSNumber numberWithBool:YES] forKey:QTMovieEditableAttribute]; /* make movie editable */
			
			if ((source.currentTime+event.length)>source.duration)
			{
				NSLog(@"Flipped %@",source.path);
				source.currentTime=0;
			}
			
			QTTime insertAtTime=[self getScaledTime:event.startTime source:movie];
			QTTime sourceTime=[self getScaledTime:source.currentTime source:movie];
			QTTime duration=[self getScaledTime:event.length source:movie];

//			NSLog(@"Editing '%@' event time:%f source time: %qi   duration: %qi   at time: %qi", source.path, event.startTime, sourceTime.timeValue, duration.timeValue, insertAtTime.timeValue);
		
			err=InsertMovieSegment([source.movie quickTimeMovie], [movie quickTimeMovie], sourceTime.timeValue, duration.timeValue, insertAtTime.timeValue);
		//	NSLog(@"insert: %d",err);
			source.currentTime+=event.length;
		}
		else
		{
			QTTime insertAtTime=[self getScaledTime:event.startTime source:movie];
			QTTime sourceTime=[self getScaledTime:0 source:movie];
			QTTime duration=[self getScaledTime:event.length source:movie];

//			NSLog(@"Black Editing    event time:%f source time: %qi   duration: %qi   at time: %qi", event.startTime, sourceTime.timeValue, duration.timeValue, insertAtTime.timeValue);
			
			err=InsertMovieSegment([blackMovie quickTimeMovie], [movie quickTimeMovie], sourceTime.timeValue, duration.timeValue, insertAtTime.timeValue);
			//NSLog(@"black: %d",err);
		}
		
		totalTime=event.startTime+event.length;
		
		QTTime insertAtTime=[self getScaledTime:totalTime source:movie];
		QTTime sourceTime=[self getScaledTime:0 source:movie];
		QTTime duration=[self getScaledTime:1 source:movie];

		InsertMovieSegment([blackMovie quickTimeMovie], [movie quickTimeMovie], sourceTime.timeValue, duration.timeValue, insertAtTime.timeValue);
	}
	
//	NSLog(@"Total length: %f",totalTime);
	
	//UpdateMovie([movie quickTimeMovie]);

	


	
	QTTimeRange finalRage=QTMakeTimeRange([self getScaledTime:0 source:movie],[self getScaledTime:totalTime source:movie]);

//	NSString *temp=[outputFile stringByAppendingString:@".temp.mov"];

	QTMovie *finalMovie=[[QTMovie alloc] initWithMovie:movie timeRange:finalRage error:nil];
	
	[finalMovie setDelegate:self];


	NSDictionary *attributes=[NSDictionary dictionaryWithContentsOfFile:settingsFile];

	[finalMovie writeToFile:outputFile withAttributes:attributes];

	
	NSString *temp=[outputFile stringByAppendingString:@".with-audio.mov"];
	finalMovie=[[QTMovie alloc] initWithFile:outputFile error:nil];
	
	QTMovie *audioMovie=[[QTMovie alloc] initWithFile:audioFile error:nil];
	[audioMovie setAttribute:[NSNumber numberWithBool:YES] forKey:QTMovieEditableAttribute]; /* make movie editable */
	
	AddMovieSelection([finalMovie quickTimeMovie], [audioMovie quickTimeMovie]);
//	NSArray *audioTracks = [audioMovie tracksOfMediaType: QTMediaTypeSound];
//	for (int i = 0; i < [audioTracks count]; i++)
//	{
//		Track sourceTrack = [[audioTracks objectAtIndex: i] quickTimeTrack];
//		Track outTrack = NewMovieTrack([finalMovie  quickTimeMovie], 0, 0,  
//									   GetTrackVolume(sourceTrack));//copy the volume over..
//		Media sourceMedia = NewTrackMedia(outTrack, SoundMediaType,  
//										  [[audioMovie attributeForKey: QTMovieTimeScaleAttribute] longValue],  
//										  NULL, 0);
//		error = BeginMediaEdits(sourceMedia);
//		error = InsertTrackSegment(sourceTrack, outTrack,  
//								   GetTrackOffset(sourceTrack), GetTrackDuration(sourceTrack), 0);// 
//		error = EndMediaEdits(sourceMedia);
//		error = CopyTrackSettings(sourceTrack, outTrack);//make the  
//	}

	[finalMovie writeToFile:temp withAttributes:nil];
}

@end
