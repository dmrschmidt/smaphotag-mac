//
//  SPTAppDelegate.m
//  Smaphotag
//
//  Created by Dennis Schmidt on 22.08.12.
//  Copyright (c) 2012 Dennis Schmidt. All rights reserved.
//

#import "SPTAppDelegate.h"
#import "SPTPhotoTagger.h"

@implementation SPTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self.window registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
    NSLog(@"EXIF DATA: %@", [SPTPhotoTagger exifForFile:filename]);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"exiftool/exiftool" ofType:nil];
    NSLog(@"path: %@", path);
    
    NSArray *arguments = [NSArray arrayWithObjects:@"-GPSLongitude=\"7.422809\"", @"-GPSLatitude=\"48.419973\"", filename, nil];
    NSTask *task = [NSTask launchedTaskWithLaunchPath:path arguments:arguments];
    return YES;
}


@end
