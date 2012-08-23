//
//  SPTAppDelegate.h
//  Smaphotag
//
//  Created by Dennis Schmidt on 22.08.12.
//  Copyright (c) 2012 Dennis Schmidt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SPTAppDelegate : NSObject <NSApplicationDelegate>

- (IBAction)showSettings:(id)sender;

@property (assign) IBOutlet NSWindow *window;

@end
