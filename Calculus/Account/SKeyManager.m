//
//  SKeyManager.m
//  Calculus
//
//  Created by tracedeng on 15/12/14.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "SKeyManager.h"

@interface SKeyManager ()
@property (nonatomic, retain) NSMutableDictionary *currentSkey;    //当前skey，失效－nil
@end

@implementation SKeyManager

- (id)init {
    self = [super init];
    if (self) {
        self.currentSkey = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+ (SKeyManager *)shareSkeyManager {
    static SKeyManager *skeyManager = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        skeyManager = [[self alloc] init];
    });
    
    return skeyManager;
}

+ (NSDictionary *)getSkey {
    return [SKeyManager shareSkeyManager].currentSkey;
}

+ (void)changeSkey:(NSString *)skey ofAccount:(NSString *)number {
    [[SKeyManager shareSkeyManager].currentSkey setObject:number forKey:@"account"];
    [[SKeyManager shareSkeyManager].currentSkey setObject:skey forKey:@"skey"];
}

+ (void)clearSkey {
    [[SKeyManager shareSkeyManager].currentSkey setObject:@"" forKey:@"skey"];
}
@end
