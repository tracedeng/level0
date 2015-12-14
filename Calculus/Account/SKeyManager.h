//
//  SKeyManager.h
//  Calculus
//
//  Created by tracedeng on 15/12/14.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKeyManager : NSObject
+ (NSString *)getSkey;      //当前skey
+ (void)changeSkey:(NSString *)skey;    // 设置当前skey
@end
