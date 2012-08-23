//
//  SPTPhotoTagger.h
//  Smaphotag
//
//  Created by Dennis Schmidt on 22.08.12.
//  Copyright (c) 2012 Dennis Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPTPhotoTagger : NSObject

+ (NSDictionary *)exifForFile:(NSString *)file;
+ (void)tagFileOrFilesAtPath:(NSString *)path;

@end
