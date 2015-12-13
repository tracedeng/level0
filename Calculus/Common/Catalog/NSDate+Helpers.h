//
//  NSDate+Helpers.h
//  
//
//  Created by tracedeng on 14/11/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Helpers)
- (NSInteger)getYear;
- (NSInteger)getMonth;
- (NSInteger)getDay;
- (NSInteger)getHour;
- (NSInteger)getMinute;
- (NSInteger)getSecond;
- (NSString *)intervalDateDescription;
- (NSInteger)intervalDateIndex;
- (NSInteger)intervalDateAge;
/*
- (NSInteger)getYear:(NSDate *)date;
- (NSInteger)getMonth:(NSDate *)date;
- (NSInteger)getDay:(NSDate *)date;
- (NSInteger)getHour:(NSDate *)date;
- (NSInteger)getMinute:(NSDate *)date;
- (NSInteger)getSecond:(NSDate *)date;*/
@end
