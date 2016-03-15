//
//  ChinaCityList.m
//  Calculus
//
//  Created by tracedeng on 16/3/15.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "ChinaCityList.h"

@interface ChinaCityList ()
@property (nonatomic, retain) NSString *plistBundle;
@property (nonatomic, retain) NSMutableArray *province;
@property (nonatomic, retain) NSArray *items;
@end

@implementation ChinaCityList

- (id)init {
    self = [super init];
    if (self) {
        self.plistBundle = [[NSBundle mainBundle] pathForResource:@"Provinces" ofType:@"plist"];
        self.items = [[NSArray alloc] initWithContentsOfFile:self.plistBundle];
    }
    return self;
}

- (NSMutableArray *)province {
    if (_province == nil) {
        _province = [[NSMutableArray alloc] init];
        for (NSDictionary *item in self.items) {
            [_province addObject:[item objectForKey:@"ProvinceName"]];
        }
    }
    
    return _province;
}

- (NSMutableArray *)citysOfProvince:(NSInteger)index {
    NSDictionary *province = [self.items objectAtIndex:index];
    NSMutableArray *citys = [[NSMutableArray alloc] init];
    for (NSDictionary *city in [province objectForKey:@"cities"]) {
        [citys addObject:[city objectForKey:@"CityName"]];
    }
    
    return citys;
}

//- (NSMutableArray *)zonesOfCity:(NSInteger)city ofProvince:(NSInteger)province {
//}

+ (NSArray *)readProvince {
    ChinaCityList *list = [[ChinaCityList alloc] init];
    
    return [NSArray arrayWithArray:[list province]];
}

+ (NSArray *)readCitysOfProvince:(NSInteger)index {
    ChinaCityList *list = [[ChinaCityList alloc] init];
    
    return [NSArray arrayWithArray:[list citysOfProvince:index]];
}
@end
