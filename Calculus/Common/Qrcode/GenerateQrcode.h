//
//  GenerateQrcode.h
//  Calculus
//
//  Created by tracedeng on 16/1/24.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface GenerateQrcode : NSObject
+ (UIImage *)createWithString:(NSString *)string;
+ (UIImage *)createWithString:(NSString *)string qrColor:(UIColor *)qrColor bgColor:(UIColor *)bgColor size:(CGSize)size;
+ (UIImage *)createQRImage:(UIImage *)qrImage logoImage:(UIImage *)logoImage;
@end
