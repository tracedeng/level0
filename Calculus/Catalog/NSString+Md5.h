//
//  NSString+Md5.h
//  xiaobao
//
//  Created by tracedeng on 14/11/18.
//  Copyright (c) 2014年 zizbi  智彼. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>

@interface NSString (Md5)

- (NSString *)md5HexDigest;
- (BOOL)isValidId;
@end
