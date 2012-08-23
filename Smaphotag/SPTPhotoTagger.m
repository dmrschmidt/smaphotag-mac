//
//  SPTPhotoTagger.m
//  Smaphotag
//
//  Created by Dennis Schmidt on 22.08.12.
//  Copyright (c) 2012 Dennis Schmidt. All rights reserved.
//

#import "SPTPhotoTagger.h"

@implementation SPTPhotoTagger

+ (NSString *)googleDrivePath {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *googleDrivePath = [[defaults valueForKey:@"googleDrivePath"] stringByExpandingTildeInPath];
    return googleDrivePath;
}

+ (NSString *)smaphotagPath {
    NSString *smaphotagPath = [[self googleDrivePath] stringByAppendingPathComponent:@"smaphotag"];
    return smaphotagPath;
}

+ (NSDictionary *)exifForFile:(NSString *)file {
    NSDictionary *dic = nil;
    NSURL *url = [NSURL fileURLWithPath:file];
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)CFBridgingRetain(url), NULL);
    
    if(NULL == source) {
        CGImageSourceStatus status = CGImageSourceGetStatus(source);
        NSLog (@"Error: file name : %@ - Status: %d", file, status);
    } else {
        CFDictionaryRef metadataRef = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
        if(metadataRef) {
            NSDictionary *immutableMetadata = (NSDictionary *)CFBridgingRelease(metadataRef);
            if(immutableMetadata) {
                dic = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary *)metadataRef];
            }
            CFRelease(metadataRef);
        }
        CFRelease(source);
        source = nil;
    }
    return dic;
}

- (void)notifyUserWhenDone {
    for(NSTask *task in self.taskList) {
        [task waitUntilExit];
    }
    NSAlert *alert = [NSAlert alertWithMessageText:@"GPS Tagging Complete" defaultButton:@"Yeeha!!" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Your photos have been tagged succesfully."];
    [alert runModal];
}

- (void)tagFileOrFilesAtPath:(NSString *)path {
    BOOL isDir;
    NSString *exiftoolPath = [[NSBundle mainBundle] pathForResource:@"exiftool/exiftool" ofType:nil];
    NSString *gpxPath = [[self class] smaphotagPath];
    NSLog(@"looking fore GPX files at path %@", gpxPath);
    self.taskList = [[NSMutableArray alloc] init];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:gpxPath isDirectory:&isDir] && isDir) {
        NSArray *gpxList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:gpxPath error:nil];
        for(NSString *gpxFile in gpxList) {
            if(![gpxFile hasSuffix:@"gpx"]) continue;
            
            NSString *gpxFilePath = [gpxPath stringByAppendingPathComponent:gpxFile];
            NSArray *arguments = [NSArray arrayWithObjects:@"-geosync=+02:00:00", @"-geotag",
                                  gpxFilePath, @"-xmp:geotime<createdate", path, nil];
            NSTask *task = [NSTask launchedTaskWithLaunchPath:exiftoolPath arguments:arguments];
            [self.taskList addObject:task];
        }
        [self notifyUserWhenDone];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Google Drive folder missing" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please check if the path to Google Drive you've given - %@ is correct.", [[self class] googleDrivePath]];
        [alert runModal];
    }
}

@end
