//
//  SPTAppDelegate.m
//  Smaphotag
//
//  Created by Dennis Schmidt on 22.08.12.
//  Copyright (c) 2012 Dennis Schmidt. All rights reserved.
//

#import "SPTAppDelegate.h"

@implementation SPTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Insert code here to initialize your application
    [self setApplicationSettingsDefaults];
    
    self.settingsView = self.window.contentView;
    
    [self.window registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    [self.window orderOut:nil];
    [self.window setStyleMask:NSTitledWindowMask | NSClosableWindowMask];
}

- (void)setApplicationSettingsDefaults {
    // Set the application defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *googleDrivePath = [@"~/Google Drive" stringByExpandingTildeInPath];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 googleDrivePath, @"googleDrivePath", nil];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
}

- (void)showProgressIndicatorView {
    self.window.title = @"Smaphotag GPS Tagging";
    [self.window setContentView:self.progressView];
    [self.window orderFront:nil];
    [self.window makeKeyWindow];
    
    [self.progressIndicator startAnimation:self];
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
    
    [self showProgressIndicatorView];
    SPTPhotoTagger *photoTagger = [[SPTPhotoTagger alloc] initWithDelegate:self];
    [photoTagger tagFileOrFilesAtPath:filename];
    
    // NSDictionary *GPSData = [[SPTPhotoTagger exifForFile:filename] objectForKey:@"{GPS}"];
    // NSLog(@"EXIF DATA: %@", [GPSData valueForKey:@"Latitude"]);
    
    return YES;
}

#pragma mark -
#pragma mark SPTPhotoTaggerDelegate methods

- (void)didFinishTagging {
    [self.progressIndicator stopAnimation:self];
    [self.window orderOut:nil];
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"GPS Tagging Complete" defaultButton:@"Yeeha!!" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Your photos have been tagged succesfully."];
    [alert runModal];
}

- (void)didCompleteTagging:(NSUInteger)lastTagged ofTotal:(NSUInteger)total {
    
}

#pragma mark -
#pragma mark Settings

- (IBAction)showSettings:(id)sender {
    self.window.title = @"Smaphotag Settings";
    [self.window setContentView:self.settingsView];
    [self.window orderFront:nil];
    [self.window makeKeyWindow];
}

- (IBAction)saveSettings:(id)sender {
    NSLog(@"saving settings");
}

@end
