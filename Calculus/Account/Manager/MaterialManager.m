//
//  MaterialManager.m
//  Calculus
//
//  Created by tracedeng on 15/12/16.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MaterialManager.h"

@interface MaterialManager ()
@property (nonatomic, retain) NSMutableDictionary *currentMaterial;    //当前skey，失效－nil
@end

@implementation MaterialManager
- (id)init {
    self = [super init];
    if (self) {
        self.currentMaterial = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+ (MaterialManager *)shareMaterialManager {
    static MaterialManager *materialManager = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        materialManager = [[self alloc] init];
    });
    
    return materialManager;
}

+ (NSDictionary *)getMaterial {
    return [MaterialManager shareMaterialManager].currentMaterial;
}

+ (void)changeMaterialOfKey:(NSString *)key withValue:(NSString *)value {
    [[MaterialManager shareMaterialManager].currentMaterial setObject:value forKey:key];
}

+ (void)setMaterial:(NSDictionary *)material {
    [[MaterialManager shareMaterialManager].currentMaterial setDictionary:material];
}
@end
