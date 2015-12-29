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
    ECONSUMERQUERYONECREDIT,              //客户查询积分列表
    ECONSUMERCREATECONSUMPTION,               //客户消费创建消费记录
    ECONSUMERHANDLETYPEMAX,
    ECONSUMERQUERYOTHERCREDITLIST,          //查询所有积分列表
    ECONSUMERQUERYMERCHANTLIST,             //查询商户列表
    ECREDITINTERCHANGE,                     //积分互换
    ECREDITOPTYPEMAX,
};

- (void)doConsumerQueryAllCredit;
- (void)doConsumerQueryOneCredit:(NSString *)merchant;
- (void)doConsumerCreateConsumption:(NSString *)merchant money:(NSInteger)money;
- (void)doConsumerQueryOtherCreditList:(NSString *)merchant;
- (void)doConsumerQueryOtherMerchantList:(NSString *)merchant;
- (void)doCreditInterchange:(NSString *)credit from_merchant:(NSString *)from quantity:(NSInteger)quantity to_merchant:(NSString *)to exec_exchange:(BOOL)exec;

@property (nonatomic, copy) void (^afterConsumerQueryAllCredit)(NSArray *creditList);
@property (nonatomic, copy) void (^afterConsumerQueryOneCredit)(NSArray *creditList);
@property (nonatomic, copy) void (^afterConsumerCreateConsumption)();
@property (nonatomic, copy) void (^afterConsumerQueryOtherCreditList)(NSArray *creditList);
@property (nonatomic, copy) void (^afterConsumerQueryOtherMerchantList)(NSArray *merchantList);
@property (nonatomic, copy) void (^afterCreditInterchange)(NSInteger quantity, NSInteger fee);


@property (nonatomic, copy) void (^afterConsumerQueryAllCreditFailed)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerQueryOneCreditFailed)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerQueryOtherCreditListFailed)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerQueryOtherMerchantListFailed)(NSString *message);
@property (nonatomic, copy) void (^afterCreditInterchangeFailed)(NSString *message);
@end
