//
//  ActionQiniu.m
//  Calculus
//
//  Created by tracedeng on 15/12/17.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionQiniu.h"
#import "QiniuSDK.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+FixOrientation.h"

@implementation ActionQiniu

- (void)doQiniuUpload:(NSDictionary *)photo token:(NSString *)token path:(NSString *)path {
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    //    NSData *data = [@"Hello, World!" dataUsingEncoding : NSUTF8StringEncoding];
    ALAsset *asset = [photo objectForKey:@"asset"];
    NSData *data = UIImageJPEGRepresentation([[UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]] fixOrientation:(UIImageOrientation)[asset defaultRepresentation].orientation], 0.0);
    
    [upManager putData:data key:path token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        DLog(@"%@", info);
        DLog(@"%@", resp);
        if (self.afterQiniuUpload) {
            self.afterQiniuUpload([resp objectForKey:@"key"]);
        }
    } option:nil];
}

@end
