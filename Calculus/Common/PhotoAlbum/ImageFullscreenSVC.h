//
//  ImageFullscreenSVC.h
//  Wearable
//
//  Created by tracedeng on 15/3/13.
//  Copyright (c) 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbum.h"

@interface ImageFullscreenSVC : UIViewController <UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger totalImageCount;        //总共有多少张图片
@property (nonatomic, assign) NSInteger currentImageCount;      //当前展示的是第几张图片

@property (nonatomic, assign) PhotoAlbum *photoAlbum;
@end
