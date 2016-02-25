//
//  MMaterialManager.h
//  Calculus
//
//  Created by tracedeng on 15/12/18.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMaterialManager : NSObject
+ (NSDictionary *)getMaterial;
+ (void)setMaterial:(NSDictionary *)material;
+ (void)changeMaterialOfKey:(NSString *)key withValue:(NSString *)value;
@end
