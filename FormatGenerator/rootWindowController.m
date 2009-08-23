//
//  rootWindowController.m
//  FormatGenerator
//
//  Created by Jon Gilkison on 8/23/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import "rootWindowController.h"
#import <QTKit/QTKit.h>
#import <QuickTime/QuickTime.h>

@implementation rootWindowController

@synthesize popUp;

- (void)awakeFromNib
{
	qtSettings=nil;
	
	components=[[NSMutableArray array] retain];
	
	ComponentDescription cd;
	Component c = NULL;
	
	cd.componentType = MovieExportType;
	cd.componentSubType = 0;
	cd.componentManufacturer = 0;
	cd.componentFlags = canMovieExportFiles;
	cd.componentFlagsMask = canMovieExportFiles;
	
	[popUp removeAllItems];
	
	while((c = FindNextComponent(c, &cd)))
	{
		Handle name = NewHandle(4);
		ComponentDescription exportCD;
		
		if (GetComponentInfo(c, &exportCD, name, nil, nil) == noErr)
		{
			unsigned char *namePStr = *name;
			NSString *nameStr = [[NSString alloc] initWithBytes:&namePStr[1] length:namePStr[0] encoding:NSUTF8StringEncoding];
			
			NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
										nameStr, @"name",
										[NSData dataWithBytes:&c length:sizeof(c)], @"component",
										[NSNumber numberWithLong:exportCD.componentType], @"type",
										[NSNumber numberWithLong:exportCD.componentSubType], @"subtype",
										[NSNumber numberWithLong:exportCD.componentManufacturer], @"manufacturer",
										nil];
			[components addObject:dictionary];
			
			[popUp addItemWithTitle:nameStr]; 
			[nameStr release];
		}
		
		DisposeHandle(name);
	}
}

- (IBAction) configureSettings:sender
{
	Component c;
	
	memcpy(&c, [[[components objectAtIndex:[popUp indexOfSelectedItem]] objectForKey:@"component"] bytes], sizeof(c));
	
	MovieExportComponent exporter = OpenComponent(c);
	Boolean canceled;
	ComponentResult err = MovieExportDoUserDialog(exporter, NULL, NULL, 0, 0, &canceled);
	if(err)
	{
		NSLog(@"Got error %d when calling MovieExportDoUserDialog",err);
		CloseComponent(exporter);
		return;
	}
	if(canceled)
	{
		CloseComponent(exporter);
		return;
	}
	QTAtomContainer settings;
	err = MovieExportGetSettingsAsAtomContainer(exporter, &settings);
	if(err)
	{
		NSLog(@"Got error %d when calling MovieExportGetSettingsAsAtomContainer",err);
		CloseComponent(exporter);
		return;
	}
	qtSettings = [[NSData dataWithBytes:*settings length:GetHandleSize(settings)] retain];
	DisposeHandle(settings);
	
	CloseComponent(exporter);
}

- (IBAction) saveSettings:sender
{
	if (qtSettings==nil)
		return;
	
	NSDictionary *component=[components objectAtIndex:[popUp indexOfSelectedItem]];
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithBool:YES], QTMovieExport,
								 [component objectForKey:@"subtype"], QTMovieExportType,
								 [component objectForKey:@"manufacturer"], QTMovieExportManufacturer,
								 qtSettings, QTMovieExportSettings,
								 // do not set the QTMovieFlatten flag! (causes export settings to be ignored)
								 nil];
	
	NSSavePanel *save = [NSSavePanel savePanel];
	
	int result=[save runModal];
	
	if (result==NSOKButton)
	{
		if (![attributes writeToFile:[save filename] atomically:YES])
		{
			NSRunAlertPanel(@"Could not save settings.",@"Could not do it.",@"OK",@"OK",nil);
		}
	}
}

@end
