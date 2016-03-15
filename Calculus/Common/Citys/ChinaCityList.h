//
//  ChinaCityList.h
//  Calculus
//
//  Created by tracedeng on 16/3/15.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChinaCityList : NSObject
+ (NSArray *)readProvince;
+ (NSArray *)readCitysOfProvince:(NSInteger)index;
//- (NSArray *)zoneListOfProvince:(NSInteger)province city:(NSInteger)city;
@end
