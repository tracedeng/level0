//
//  UIImage+FixOrientation.h
//  Wearable
//
//  Created by tracedeng on 15/7/9.
//  Copyright (c) 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FixOrientation)
- (UIImage *)fixOrientation;
- (UIImage *)fixOrientation:(UIImageOrientation)withOrientation;

+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size;    // 圆角uiimage
@end
