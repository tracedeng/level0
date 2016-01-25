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
+ (CIImage *)createQRForString:(NSString *)qrString;
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;
@end
