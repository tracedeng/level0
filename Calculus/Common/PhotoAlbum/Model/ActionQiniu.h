//
//  ActionQiniu.h
//  Calculus
//
//  Created by tracedeng on 15/12/17.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionQiniu : NSObject
- (void)doQiniuUpload:(NSDictionary *)photo token:(NSString *)token path:(NSString *)path;

@property (nonatomic, copy) void (^afterQiniuUpload)(NSString *path);

@end
