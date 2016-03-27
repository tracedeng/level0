//
//  ActionCredit.h
//  Calculus
//
//  Created by tracedeng on 15/12/10.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetCommunication.h"

@interface ActionCredit : NSObject <NetCommunicationDelegate>
//操作类型
typedef NS_ENUM(NSInteger, ECREDITOPTYPE) {
    ECONSUMERQUERYALLCREDIT = 1,              //客户查询积分列表
    ECONSUMERQUERYONECREDIT,                //客户查询拥有某商家积分列表
    ECONSUMERCREATECONSUMPTION,               //客户消费创建消费记录
    ECONSUMERQUERYOTHERCREDITLIST,          //查询所有积分列表
    ECONSUMERQUERYMERCHANTLIST,             //查询商户列表
    EALLOWINTERCHANGEIN,                    //查询积分是否允许换入某商家
    EQUERYALLOWEXCHANGEOUTCREDIT,           //查询允许换出的积分列表
    ECREDITINTERCHANGE,                     //积分互换
    ECREDITOPTYPEMAX,
};

- (void)doConsumerQueryAllCredit;
- (void)doConsumerQueryOneCredit:(NSString *)merchant;
- (void)doConsumerCreateConsumption:(NSString *)merchant money:(NSInteger)money;
- (void)doConsumerQueryCreditListWithout:(NSString *)merchant;
- (void)doConsumerQueryMerchantListWithout:(NSString *)merchant;
- (void)doCreditInterchange:(NSString *)credit from_merchant:(NSString *)from quantity:(NSInteger)quantity to_merchant:(NSString *)to exec_exchange:(BOOL)exec;
- (void)doAllowInterchangeIn:(NSString *)merchant;
- (void)doQueryAllowExchangeOutCredit:(NSString *)merchant;


@property (nonatomic, copy) void (^afterConsumerQueryAllCredit)(NSArray *creditList);
@property (nonatomic, copy) void (^afterConsumerQueryOneCredit)(NSArray *creditList);
@property (nonatomic, copy) void (^afterConsumerCreateConsumption)();
@property (nonatomic, copy) void (^afterConsumerQueryOtherCreditList)(NSArray *creditList);
@property (nonatomic, copy) void (^afterConsumerQueryOtherMerchantList)(NSArray *merchantList);
@property (nonatomic, copy) void (^afterCreditInterchange)(NSInteger quantity, NSInteger fee);
@property (nonatomic, copy) void (^afterAllowInterchangeIn)(NSString *allow);


@property (nonatomic, copy) void (^afterConsumerQueryAllCreditFailed)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerQueryOneCreditFailed)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerCreateConsumptionFailed)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerQueryOtherCreditListFailed)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerQueryOtherMerchantListFailed)(NSString *message);
@property (nonatomic, copy) void (^afterCreditInterchangeFailed)(NSString *message);
@property (nonatomic, copy) void (^afterAllowInterchangeInFailed)(NSString *message);

@property (nonatomic, copy) void (^afterConsumerQueryAllCreditFailedNetConnect)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerQueryOneCreditFailedNetConnect)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerCreateConsumptionFailedNetConnect)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerQueryOtherCreditListFailedNetConnect)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerQueryOtherMerchantListFailedNetConnect)(NSString *message);
@property (nonatomic, copy) void (^afterCreditInterchangeFailedNetConnect)(NSString *message);
@property (nonatomic, copy) void (^afterAllowInterchangeInFailedNetConnect)(NSString *message);

@end
