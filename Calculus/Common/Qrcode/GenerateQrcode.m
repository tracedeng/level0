//
//  GenerateQrcode.m
//  Calculus
//
//  Created by tracedeng on 16/1/24.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "GenerateQrcode.h"

@implementation GenerateQrcode

#pragma mark -- 生成二维码图片
+ (UIImage *)createWithString:(NSString *)string  {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    return [UIImage imageWithCIImage:filter.outputImage];;
}


#pragma mark -- 自定义颜色和背景颜色的二维码
+ (UIImage *)createWithString:(NSString *)string qrColor:(UIColor *)qrColor bgColor:(UIColor *)bgColor size:(CGSize)size {
    
    NSData *data = [string dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:data forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage", qrFilter.outputImage,
                             @"inputColor0", [CIColor colorWithCGColor:qrColor.CGColor],
                             @"inputColor1", [CIColor colorWithCGColor:bgColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    return codeImage;
}


#pragma mark -- 为二维码图片添加logo
+ (UIImage *)createQRImage:(UIImage *)qrImage logoImage:(UIImage *)logoImage {
    // 设置上下文
    UIGraphicsBeginImageContext(qrImage.size);
    // 把二维码画出来
    [qrImage drawInRect:CGRectMake(0, 0, qrImage.size.width, qrImage.size.height)];
    // 设置logo的大小,logo默认是30x30
    CGRect logoRect = CGRectMake(qrImage.size.width/2 - qrImage.size.height * 0.1, qrImage.size.height/2 - qrImage.size.height * 0.1, qrImage.size.width * 0.2, qrImage.size.height * 0.2);
    CGRect logoBgRect = CGRectMake(qrImage.size.width/2 - qrImage.size.height * 0.1 - 2, qrImage.size.height/2 - qrImage.size.height * 0.1 - 2, qrImage.size.width * 0.2 + 4, qrImage.size.height * 0.2 + 4);
    
    // logo的背景区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:logoBgRect];

    // logo的背景区域
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:logoRect];
    [[UIColor whiteColor] setFill];
    [path fill];
    
    // TODO。。。定位区域根据加密内容变化，定位有问题
//    CGFloat width = qrImage.size.width/49 * 5.5;
//    
//    UIBezierPath *pathTopLeft = [UIBezierPath bezierPathWithRect:CGRectMake(width, width, width, width)];
//    [[UIColor greenColor] setFill];
//    [pathTopLeft fill];
//    
//    UIBezierPath *pathTopRight = [UIBezierPath bezierPathWithRect:CGRectMake(qrImage.size.width - 2 * width, width, width, width)];
//    [[UIColor redColor] setFill];
//    [pathTopRight fill];
//    
//    UIBezierPath *pathBotLeft = [UIBezierPath bezierPathWithRect:CGRectMake(width, qrImage.size.height-2*width , width, width)];
//    [[UIColor blueColor] setFill];
//    [pathBotLeft fill];
    
    // 再把logo画在背景区域上
    [logoImage drawInRect:logoRect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
