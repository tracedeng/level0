//
//  PhotoAlbum.m
//  Wearable
//
//  Created by tracedeng on 15/3/13.
//  Copyright (c) 2015年 tracedeng. All rights reserved.
//

#import "PhotoAlbum.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoAlbum ()
@end

@implementation PhotoAlbum

- (NSMutableArray *)photoAlbumImages {
    if (_photoAlbumImages == nil) {
        _photoAlbumImages = [[NSMutableArray alloc] init];
    }
    return _photoAlbumImages;
}

- (void)enumerateAssets {
    
    [[PhotoAlbum defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    NSURL *assetUrl = [result valueForProperty:@"ALAssetPropertyAssetURL"];
                    //[0] = "id=6E5438ED-9A8C-4ED0-9DEA-AB2D8F8A9360&",
                    //[1] = JPG，同一图片文件id相同，文件名随机生成
                    NSString *extension = [[[[assetUrl query] componentsSeparatedByString:@"ext="] objectAtIndex:1] lowercaseString];
                    NSString *name = [NSString stringWithFormat:@"%u", (210000000 + (arc4random() % 210000001))];
                    NSString *fileName = [NSString stringWithFormat:@"%@.%@", name, extension];
                    
                    [self.photoAlbumImages addObject:[NSDictionary dictionaryWithObjectsAndKeys:result, @"asset", name, @"name", fileName, @"fileName", nil]];
                    //[self.photoAlbumImages addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageWithCGImage:[[result defaultRepresentation] fullResolutionImage]], @"fullResolution", [UIImage imageWithCGImage:[result thumbnail]], @"thumbnail", name, @"name", fileName, @"fileName", nil]];
                }
            }];
        }else{
            //遍历结束
            self.afterEnumerateAssets();
        }
    } failureBlock:^(NSError *error) {
        //
        DLog(@"%@", error.localizedDescription);
    }];
}

- (UIImage *)fetchThumbnailAtIndex:(NSInteger)index {
    return [UIImage imageWithCGImage:[[self.photoAlbumImages[index] objectForKey:@"asset"] thumbnail]];
}

- (UIImage *)fetchFullScreenAtIndex:(NSInteger)index {
    return [UIImage imageWithCGImage:[[[self.photoAlbumImages[index] objectForKey:@"asset"] defaultRepresentation] fullScreenImage]];
}

- (NSURL *)fetchUrlScreenAtIndex:(NSInteger)index {
    return [[[self.photoAlbumImages[index] objectForKey:@"asset"] defaultRepresentation] url];
}
/**
 *  处理下面的情况
 *  从 A控制器 persent 到用 ALAssetsLibrary 去选择多张图片区获取 相册图片B控制器，选择完图片后， 要将图片传给A控制器的属性里面， 但是总是空的
 *  @return <#return value description#>
 */
+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    
    return library;
}

@end
