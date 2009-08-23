//
//  rootWindowController.h
//  FormatGenerator
//
//  Created by Jon Gilkison on 8/23/09.
//  Copyright 2009 Massify. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rootWindowController : NSWindowController 
{
	IBOutlet NSPopUpButton *popUp;
	
	NSMutableArray *components;
	NSData *qtSettings;
}

@property (nonatomic, retain) NSPopUpButton *popUp;

- (IBAction) configureSettings:sender;
- (IBAction) saveSettings:sender;

@end
