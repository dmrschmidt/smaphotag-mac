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
    return @"/Users/dmrschmidt/Google Drive/smaphotag/1345684149.gpx";
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

+ (void)tagFileOrFilesAtPath:(NSString *)path {
    BOOL isDir;
    NSError *error = nil;
    
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    NSUInteger count = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error] count];
    NSLog(@"found %ld files at path", count);
    NSString *exiftoolPath = [[NSBundle mainBundle] pathForResource:@"exiftool/exiftool" ofType:nil];
    
    NSArray *arguments = [NSArray arrayWithObjects:@"-geosync=+02:00:00", @"-geotag", [self googleDrivePath], @"-xmp:geotime<createdate", path, nil];
    NSTask *task = [NSTask launchedTaskWithLaunchPath:exiftoolPath arguments:arguments];
    [task waitUntilExit];
    NSLog(@"exited with status %d", [task terminationStatus]);
}

@end
