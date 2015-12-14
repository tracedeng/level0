//
//  SKeyManager.m
//  Calculus
//
//  Created by tracedeng on 15/12/14.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "SKeyManager.h"

@interface SKeyManager ()
@property (nonatomic, retain) NSString *currentSkey;    //当前skey，失效－nil
@end

@implementation SKeyManager

+ (SKeyManager *)shareSkeyManager {
    static SKeyManager *skeyManager = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        skeyManager = [[self alloc] init];
    });
    
    return skeyManager;
}

+ (NSString *)getSkey {
    return [SKeyManager shareSkeyManager].currentSkey;
}

+ (void)changeSkey:(NSString *)skey {
    if (![skey isEqualToString:[SKeyManager shareSkeyManager].currentSkey]) {
        [SKeyManager shareSkeyManager].currentSkey = skey;
    }
}

@end
