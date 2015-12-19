//
//  MMaterialManager.m
//  Calculus
//
//  Created by tracedeng on 15/12/18.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MMaterialManager.h"

@interface MMaterialManager ()
@property (nonatomic, retain) NSMutableDictionary *currentMaterial;    //当前资料，失效－nil
@end

@implementation MMaterialManager
- (id)init {
    self = [super init];
    if (self) {
        self.currentMaterial = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+ (MMaterialManager *)shareMaterialManager {
    static MMaterialManager *materialManager = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        materialManager = [[self alloc] init];
    });
    
    return materialManager;
}

+ (NSDictionary *)getMaterial {
    return [MMaterialManager shareMaterialManager].currentMaterial;
}

+ (void)changeMaterialOfKey:(NSString *)key withValue:(NSString *)value {
    [[MMaterialManager shareMaterialManager].currentMaterial setObject:value forKey:key];
}

+ (void)setMaterial:(NSDictionary *)material {
    [[MMaterialManager shareMaterialManager].currentMaterial setDictionary:material];
}
@end
