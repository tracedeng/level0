//
//  SKeyManager.h
//  Calculus
//
//  Created by tracedeng on 15/12/14.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKeyManager : NSObject
+ (NSDictionary *)getSkey;      //当前skey
+ (void)changeSkey:(NSString *)skey ofAccount:(NSString *)number;    // 设置当前skey
+ (void)clearSkey;      //logout时清楚skey
@end
