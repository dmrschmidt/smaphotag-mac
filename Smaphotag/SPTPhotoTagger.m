//
//  SPTPhotoTagger.m
//  Smaphotag
//
//  Created by Dennis Schmidt on 22.08.12.
//  Copyright (c) 2012 Dennis Schmidt. All rights reserved.
//

#import "SPTPhotoTagger.h"
//#import "EXF.h"

@implementation SPTPhotoTagger

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

// Helper methods for location conversion
-(NSMutableArray*) createLocArray:(double) val{
    val = fabs(val);
    NSMutableArray* array = [[NSMutableArray alloc] init];
    double deg = (int)val;
    [array addObject:[NSNumber numberWithDouble:deg]];
    val = val - deg;
    val = val*60;
    double minutes = (int) val;
    [array addObject:[NSNumber numberWithDouble:minutes]];
    val = val - minutes;
    val = val *60;
    double seconds = val;
    [array addObject:[NSNumber numberWithDouble:seconds]];
    return array;
}
//
//-(void) populateGPS: (EXFGPSLoc*)gpsLoc :(NSArray*) locArray{
//    long numDenumArray[2];
//    long* arrPtr = numDenumArray;
//    [EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:0]];
//    EXFraction* fract = [[EXFraction alloc] initWith:numDenumArray[0] :numDenumArray[1]];
//    gpsLoc.degrees = fract;
//    [fract release];
//    [EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:1]];
//    fract = [[EXFraction alloc] initWith:numDenumArray[0] :numDenumArray[1]];
//    gpsLoc.minutes = fract;
//    [fract release];
//    [EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:2]];
//    fract = [[EXFraction alloc] initWith:numDenumArray[0] :numDenumArray[1]];
//    gpsLoc.seconds = fract;
//    [fract release]   
//}

@end
