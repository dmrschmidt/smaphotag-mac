//
//  SPTAppDelegate.m
//  Smaphotag
//
//  Created by Dennis Schmidt on 22.08.12.
//  Copyright (c) 2012 Dennis Schmidt. All rights reserved.
//

#import "SPTAppDelegate.h"

@implementation SPTAppDelegate

- (void)showIntroductionScreen {
    [self.window orderFront:nil];
    [self.window makeKeyWindow];
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Welcome to Smaphotag" defaultButton:@"Yeeha!!" alternateButton:nil otherButton:nil informativeTextWithFormat:@"After syncing your App with Dropbox, simply select your local Dropbox folder in this apps settings.\n\n When you've imported some photos you took during your last session with Smaphotag, simply drag & drop them on the dock icon.\n\nYou can close the App window, it runs only in the Doch.\n\nThat's it! Enjoy!"];
    [alert runModal];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Insert code here to initialize your application
    [self setApplicationSettingsDefaults];
    
    [self.window registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    [self.window orderOut:nil];
    [self.window setStyleMask:NSTitledWindowMask | NSClosableWindowMask];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:@"isVeryFirstAppLaunch"]) {
        [defaults setBool:NO forKey:@"isVeryFirstAppLaunch"];
        [defaults synchronize];
        [self showIntroductionScreen];
    }
}

- (void)setApplicationSettingsDefaults {
    // Set the application defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *googleDrivePath = [@"~/Dropbox" stringByExpandingTildeInPath];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 googleDrivePath,               @"googleDrivePath",
                                 [NSNumber numberWithBool:YES], @"isVeryFirstAppLaunch", nil];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
}

- (void)showProgressIndicatorView {
    self.window.title = @"Smaphotag GPS Tagging";
    [self.window setContentView:self.progressView];
    [self.window orderFront:nil];
    [self.window makeKeyWindow];
    
    [self.progressIndicator setDoubleValue:0.0];
    [self.progressIndicator setMinValue:0.0];
    [self.progressIndicator setMaxValue:1.0];
    [self.progressIndicator setIndeterminate:YES];
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
    [self.window orderOut:nil];
    [self.progressIndicator stopAnimation:self];
    NSAlert *alert = [NSAlert alertWithMessageText:@"GPS Tagging Complete" defaultButton:@"Yeeha!!" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Your photos have been tagged succesfully."];
    [alert runModal];
}

- (void)didCompleteTagging:(NSUInteger)lastTagged ofTotal:(NSUInteger)total {
//    if([self.progressIndicator isIndeterminate]) {
//        [self.progressIndicator stopAnimation:self];
//        [self.progressIndicator setIndeterminate:NO];
//    }
//    [self.progressIndicator setDoubleValue:(lastTagged / (CGFloat)total)];
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
