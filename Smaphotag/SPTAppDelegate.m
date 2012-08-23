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
    [self.window orderOut:nil];
}

- (void)setApplicationSettingsDefaults {
    // Set the application defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *googleDrivePath = [@"~/Google Drive/smaphotag" stringByExpandingTildeInPath];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 googleDrivePath, @"googleDrivePath", nil];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
}

// ./exiftool -geosync=+02:00:00 -geotag ~/Desktop/log.gpx "-xmp:geotime<createdate" ~/Desktop/sample
- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
    
    [self setApplicationSettingsDefaults];
    [SPTPhotoTagger tagFileOrFilesAtPath:filename];
    
//    NSDictionary *GPSData = [[SPTPhotoTagger exifForFile:filename] objectForKey:@"{GPS}"];
//    NSLog(@"EXIF DATA: %@", [GPSData valueForKey:@"Latitude"]);
    
    return YES;
}


@end
