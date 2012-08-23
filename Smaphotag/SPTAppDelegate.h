//
//  SPTAppDelegate.h
//  Smaphotag
//
//  Created by Dennis Schmidt on 22.08.12.
//  Copyright (c) 2012 Dennis Schmidt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPTPhotoTagger.h"

@interface SPTAppDelegate : NSObject <NSApplicationDelegate, SPTPhotoTaggerDelegate>

- (IBAction)showSettings:(id)sender;
- (IBAction)saveSettings:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSView *settingsView;
@property (nonatomic, retain) IBOutlet NSView *progressView;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *progressIndicator;

@end
