//
//  PhotoAlbum.h
//  Wearable
//
//  Created by tracedeng on 15/3/13.
//  Copyright (c) 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoAlbum : NSObject
@property (nonatomic, retain) NSMutableArray *photoAlbumImages;
@property (nonatomic, copy) void (^afterEnumerateAssets)();

- (void)enumerateAssets;
- (UIImage *)fetchThumbnailAtIndex:(NSInteger)index;
- (UIImage *)fetchFullScreenAtIndex:(NSInteger)index;
- (NSURL *)fetchUrlScreenAtIndex:(NSInteger)index;
@end
