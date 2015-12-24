//
//  ActionMCredit.h
//  Calculus
//
//  Created by tracedeng on 15/12/22.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetCommunication.h"

@interface ActionMCredit : NSObject <NetCommunicationDelegate>
//操作类型
typedef NS_ENUM(NSInteger, EMCREDITOPTYPE) {
    EQUERYCONSUMERCREDIT = 1,                   //商家查询用户拥有的积分
    EQUERYONECONSUMERCREDIT,                    //商家查询某个用户拥有的积分
    EMERCHANTQUERYAPPLYCREDIT,                  //商家查询积分申请
    ECONFIRMAPPLYCREDIT,                        //商家确认积分申请
    EREFUSEAPPLYCREDIT,                         //商家拒绝积分申请
    EMCREDITOPTYPEMAX,
};

- (void)doQueryConsumerCredit;
- (void)doQueryOneConsumerCredit:(NSString *)numbers;
- (void)doMerchantQueryApplyCredit;
- (void)doConfirmApplyCredit:(NSString *)identity sums:(NSInteger)sums;
- (void)doRefuseApplyCredit:(NSString *)identity reason:(NSString *)reason;

@property (nonatomic, copy) void (^afterQueryConsumerCredit)(NSArray *creditList);
@property (nonatomic, copy) void (^afterQueryOneConsumerCredit)(NSArray *creditList);
@property (nonatomic, copy) void (^afterMerchantQueryApplyCredit)(NSArray *creditList);
@property (nonatomic, copy) void (^afterConfirmApplyCredit)();
@property (nonatomic, copy) void (^afterRefuseApplyCredit)();

@property (nonatomic, copy) void (^afterQueryConsumerCreditFailed)(NSString *message);
@property (nonatomic, copy) void (^afterQueryOneConsumerCreditFailed)(NSString *message);
@property (nonatomic, copy) void (^afterMerchantQueryApplyCreditFailed)(NSString *message);
@property (nonatomic, copy) void (^afterConfirmApplyCreditFailed)(NSString *message);
@property (nonatomic, copy) void (^afterRefuseApplyCreditFailed)(NSString *message);


@end
