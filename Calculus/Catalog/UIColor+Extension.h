//
//  UIColor+Extension.h
//  Wearable
//
//  Created by tracedeng on 15/6/15.
//  Copyright (c) 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;
@end
