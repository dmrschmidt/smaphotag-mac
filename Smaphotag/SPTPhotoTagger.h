//
//  SPTPhotoTagger.h
//  Smaphotag
//
//  Created by Dennis Schmidt on 22.08.12.
//  Copyright (c) 2012 Dennis Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SPTPhotoTaggerDelegate <NSObject>

- (void)didFinishTagging;
- (void)didCompleteTagging:(NSUInteger)lastTagged ofTotal:(NSUInteger)total;

@end

@interface SPTPhotoTagger : NSObject

+ (NSString *)smaphotagPath;
+ (NSDictionary *)exifForFile:(NSString *)file;
- (SPTPhotoTagger *)initWithDelegate:(NSObject<SPTPhotoTaggerDelegate> *)delegate;
- (void)tagFileOrFilesAtPath:(NSString *)path;

@property(nonatomic) NSMutableArray *taskList;
@property(assign) NSUInteger totalCountToTag;
@property(assign) NSUInteger alreadyTaggedCount;
@property(assign) NSObject<SPTPhotoTaggerDelegate> *delegate;

@end
