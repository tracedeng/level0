//
//  ActionFlow.h
//  Calculus
//
//  Created by ben on 15/12/30.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetCommunication.h"

@interface ActionFlow : NSObject<NetCommunicationDelegate>
typedef NS_ENUM(NSInteger, EFLOWOPTYE) {
    EQUERYFLOW,   //查询剩余可发行积分
    EQRERYALLOWEXCHANGEIN,  //查询商家是否允许积分转入
    EQUERYBALANCEHISTORY,   //查询商家充值提现纪录
    EQUERYTRADENO,          //请求充值交易号
    ERECHARGE,              //充值
    EWITHDRAWALS,           //提现
    EQUERYBALANCE,          //查询帐户余额
    EFLOWOPTYPEMAX
};

- (void)doQueryFlow:(NSString *)merchant;
- (void)doQueryAllowExchangeIn:(NSString *)merchant;
- (void)doQueryBalanceHistory:(NSString *)merchant;
- (void)doQueryTradeNo:(NSString *)merchant money:(NSInteger)money;
- (void)doRecharge:(NSString *)merchant money:(NSInteger)money tradeno:(NSString *)tradeno;
- (void)doWithdrawals:(NSString *)merchant money:(NSInteger)money;
- (void)doQueryBalance:(NSString *)merchant;


@property (nonatomic, copy) void (^afterQqueryFlow)(NSDictionary *flow);
@property (nonatomic, copy) void (^afterQueryAllowExchangeIn)(NSString *allow);
@property (nonatomic, copy) void (^afterQueryBalanceHistory)(NSArray *history);
@property (nonatomic, copy) void (^afterQueryTradeNo)(NSString *tradeno, NSString *key);
@property (nonatomic, copy) void (^afterRecharge)(NSString *result);
@property (nonatomic, copy) void (^afterWithdrawals)(NSString *result);
@property (nonatomic, copy) void (^afterQueryBalance)(NSString *balance);

@property (nonatomic, copy) void (^afterQqueryFlowFailed)(NSString *message);
@property (nonatomic, copy) void (^afterQueryAllowExchangeInFailed)(NSString *message);
@property (nonatomic, copy) void (^afterQueryBalanceHistoryFailed)(NSString *message);
@property (nonatomic, copy) void (^afterQueryTradeNoFailed)(NSString *message);
@property (nonatomic, copy) void (^afterRechargeFailed)(NSString *message);
@property (nonatomic, copy) void (^afterWithdrawalsFailed)(NSString *message);
@property (nonatomic, copy) void (^afterQueryBalanceFailed)(NSString *message);
@end





