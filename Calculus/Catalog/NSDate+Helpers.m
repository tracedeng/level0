//
//  NSDate+Helpers.m
//  
//
//  Created by tracedeng on 14/11/14.
//
//

#import "NSDate+Helpers.h"

@implementation NSDate (Helpers)

- (NSInteger)getYear {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    return [components year];
}

- (NSInteger)getMonth {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    return [components month];
}

- (NSInteger)getDay {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    return [components day];
}

- (NSInteger)getHour {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:self];
    return [components hour];
}

- (NSInteger)getMinute {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:self];
    return [components minute];
}

- (NSInteger)getSecond {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitSecond fromDate:self];
    return [components second];
}
/*
- (NSInteger)getYear:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] init];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:date];
    return [components year];
}

- (NSInteger)getMonth:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] init];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:date];
    return [components month];
}

- (NSInteger)getDay:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] init];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:date];
    return [components day];
}

- (NSInteger)getHour:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] init];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:date];
    return [components hour];
}

- (NSInteger)getMinute:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] init];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:date];
    return [components minute];
}

- (NSInteger)getSecond:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] init];
    NSDateComponents *components = [calendar components:NSCalendarUnitSecond fromDate:date];
    return [components second];
}*/

/**
 *  展示与当前时间间隔描述
 *
 *  @return <#return value description#>
 */
- (NSString *)intervalDateDescription {
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self];
    NSInteger yearInterval = interval / (365 * 24 * 3600);
//    NSInteger yearInterval = [[NSDate date] getYear] - [self getYear];
    if (yearInterval > 0) {
        return [NSString stringWithFormat:@"%d年前", yearInterval];
    }
    NSInteger monthInterval = interval / (30 * 24 * 3600);
//    NSInteger monthInterval  = [[NSDate date] getMonth] - [self getMonth];
    if (monthInterval > 0) {
        return [NSString stringWithFormat:@"%d月前", monthInterval];
    }
    
    NSInteger dayInterval = interval / (24 * 3600);
//    NSInteger dayInterval = [[NSDate date] getDay] - [self getDay];
    if (dayInterval > 0) {
        if (1 == dayInterval) {
            return @"昨天";
        }
        return [NSString stringWithFormat:@"%d天前",dayInterval];
    }
    NSInteger hourInterval = interval / 3600;
//    NSInteger hourInterval = [[NSDate date] getHour] - [self getHour];
    if (hourInterval > 0) {
        return [NSString stringWithFormat:@"%d小时前", hourInterval];
    }
    NSInteger minuteInterval = interval / 60;
//    NSInteger minuteInterval = [[NSDate date] getMinute] - [self getMinute];
    if (minuteInterval > 0) {
        return [NSString stringWithFormat:@"%d分钟前", minuteInterval];
    }
    return [NSString stringWithFormat:@"刚才"];
}

- (NSInteger)intervalDateIndex {
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self];

    NSInteger monthInterval = interval / (30 * 24 * 3600);
    if (monthInterval > 11) {
        monthInterval = 12;
    }else if(monthInterval < 0){
        monthInterval = 0;
    }
    
    return monthInterval;
}

- (NSInteger)intervalDateAge {
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self];
    NSInteger yearInterval = interval / (365 * 24 * 3600);
    //    NSInteger yearInterval = [[NSDate date] getYear] - [self getYear];
    if (yearInterval < 0) {
        return 1;
    }
    return yearInterval + 1;
}
@end
