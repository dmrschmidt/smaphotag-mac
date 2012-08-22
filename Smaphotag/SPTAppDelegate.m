//
//  SPTAppDelegate.m
//  Smaphotag
//
//  Created by Dennis Schmidt on 22.08.12.
//  Copyright (c) 2012 Dennis Schmidt. All rights reserved.
//

#import "SPTAppDelegate.h"

@implementation SPTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self.window registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
    NSLog(@"filename: %@", filename);
    return YES;
}

@end
