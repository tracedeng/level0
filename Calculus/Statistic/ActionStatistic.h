//
//  ActionStatistic.h
//  Calculus
//
//  Created by tracedeng on 16/2/18.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetCommunication.h"

@interface ActionStatistic : NSObject <NetCommunicationDelegate>

// 统计操作类型
typedef NS_ENUM(NSInteger, ESTATISTICOPTYPE) {
    ESTATISTICVERSIONREPORT = 1,                   // app版本上报
    ESTATISTICBOOTREPORT,                          // 启动上报
    ESTATISTICACTIVEREPORT,                        // 活跃上报
    ESTATISTICFEEDBACK,                            // 反馈
    ESTATISTICOPTYPEMAX,
};

- (void)doReportVersion:(NSString *)version;
- (void)doBootReport:(NSString *)version;
- (void)doActiveReport;
- (void)doFeedback:(NSString *)version feedback:(NSString *)feedback;

@property (nonatomic, copy) void (^afterReportVersion)();
@property (nonatomic, copy) void (^afterBootReport)();
@property (nonatomic, copy) void (^afterFeedback)();
@property (nonatomic, copy) void (^afterActiveReport)();

@property (nonatomic, copy) void (^afterReportVersionFailed)(NSString *message);
@property (nonatomic, copy) void (^afterFeedbackFailed)(NSString *message);
@property (nonatomic, copy) void (^afterBootReportFailed)(NSString *message);
@property (nonatomic, copy) void (^afterActiveReportFailed)(NSString *message);

@end
