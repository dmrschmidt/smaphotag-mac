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

- (SPTPhotoTagger *)initWithDelegate:(NSObject<SPTPhotoTaggerDelegate> *)delegate {
    if(self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)notifyUserWhenDone {
    for(NSTask *task in self.taskList) {
        [task waitUntilExit];
    }
    
    [self.delegate didFinishTagging];
}

- (NSArray *)photoFileList:(NSString *)fileOrDir {
    BOOL isDir;
    NSMutableArray *photoFileList = [[NSMutableArray alloc] init];
    if([[NSFileManager defaultManager] fileExistsAtPath:fileOrDir isDirectory:&isDir] && isDir) {
        NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fileOrDir error:nil];
        for(NSString *file in fileList) {
            if([file hasSuffix:@"jpg"] || [file hasSuffix:@"jpeg"]) {
                [photoFileList addObject:[fileOrDir stringByAppendingPathComponent:file]];
            }
        }
    } else {
        [photoFileList addObject:fileOrDir];
    }
    return photoFileList;
}

- (void)determineTotalCountToTag:(NSString *)fileOrDir {
    BOOL isDir;
    NSUInteger gpxFileCount = 0;
    NSString *gpxPath = [[self class] smaphotagPath];
    if([[NSFileManager defaultManager] fileExistsAtPath:gpxPath isDirectory:&isDir] && isDir) {
        NSArray *gpxList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:gpxPath error:nil];
        for(NSString *gpxFile in gpxList) {
            if([gpxFile hasSuffix:@"gpx"]) {
                gpxFileCount++;
            }
        }
    }
    NSUInteger imageFileCount = [[self photoFileList:fileOrDir] count];
    self.totalCountToTag = (gpxFileCount * imageFileCount);
}

- (void)notifyUserAboutCompletedTask {
    self.alreadyTaggedCount++;
    [self.delegate didCompleteTagging:self.alreadyTaggedCount ofTotal:self.totalCountToTag];
}

- (void)tagFileOrFilesAtPath:(NSString *)fileOrdDirPath {
    BOOL isDir;
    NSString *exiftoolPath = [[NSBundle mainBundle] pathForResource:@"exiftool/exiftool" ofType:nil];
    NSString *gpxPath = [[self class] smaphotagPath];
    NSLog(@"looking fore GPX files at path %@", gpxPath);
    self.taskList = [[NSMutableArray alloc] init];
    [self determineTotalCountToTag:fileOrdDirPath];
    
    self.alreadyTaggedCount = 0;
    if([[NSFileManager defaultManager] fileExistsAtPath:gpxPath isDirectory:&isDir] && isDir) {
        NSArray *gpxList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:gpxPath error:nil];
        for(NSString *gpxFile in gpxList) {
            if(![gpxFile hasSuffix:@"gpx"]) continue;
            
            NSString *gpxFilePath = [gpxPath stringByAppendingPathComponent:gpxFile];
            for(NSString *filePath in [self photoFileList:fileOrdDirPath]) {
                NSArray *arguments = [NSArray arrayWithObjects:@"-geotag", gpxFilePath,
                                      @"-xmp:geotime<createdate", filePath, nil];
                NSTask *task = [NSTask launchedTaskWithLaunchPath:exiftoolPath arguments:arguments];
                [task setTerminationHandler:^(NSTask *task) { [self notifyUserAboutCompletedTask]; }];
                [self.taskList addObject:task];
            }
        }
        [self notifyUserWhenDone];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Google Drive folder missing" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please check if the path to Google Drive you've given - %@ is correct.", [[self class] googleDrivePath]];
        [alert runModal];
    }
}

@end
