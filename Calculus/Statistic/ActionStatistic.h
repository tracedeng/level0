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
    ESTATISTICFEEDBACK,                            // 反馈
    ESTATISTICOPTYPEMAX,
};

- (void)doReportVersion:(NSString *)version;
//- (void)doQueryOneConsumerCredit:(NSString *)numbers;
//- (void)doMerchantQueryApplyCredit;
//- (void)doConfirmApplyCredit:(NSString *)identity sums:(NSInteger)sums;
- (void)doFeedback:(NSString *)version feedback:(NSString *)feedback;

@property (nonatomic, copy) void (^afterReportVersion)();
//@property (nonatomic, copy) void (^afterQueryOneConsumerCredit)(NSArray *creditList);
//@property (nonatomic, copy) void (^afterMerchantQueryApplyCredit)(NSArray *creditList);
@property (nonatomic, copy) void (^afterFeedback)();
//@property (nonatomic, copy) void (^afterRefuseApplyCredit)();

@property (nonatomic, copy) void (^afterReportVersionFailed)(NSString *message);
@property (nonatomic, copy) void (^afterFeedbackFailed)(NSString *message);
//@property (nonatomic, copy) void (^afterMerchantQueryApplyCreditFailed)(NSString *message);
//@property (nonatomic, copy) void (^afterConfirmApplyCreditFailed)(NSString *message);
//@property (nonatomic, copy) void (^afterRefuseApplyCreditFailed)(NSString *message);

@end
