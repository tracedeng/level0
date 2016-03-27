//
//  ActionDiscount.h
//  Calculus
//
//  Created by tracedeng on 16/1/3.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetCommunication.h"

@interface ActionDiscount : NSObject <NetCommunicationDelegate>
//操作类型
typedef NS_ENUM(NSInteger, EDISCOUNTOPTYPE) {
    ECONSUMERQUERYDISCOUNT = 1,              //客户查询优惠活动列表
    ECONSUMERBUYDISCOUNT,                    //客户购买优惠
//    ECONSUMERCREATECONSUMPTION,               //客户消费创建消费记录
//    ECONSUMERHANDLETYPEMAX,
//    ECONSUMERQUERYOTHERdisccoutList,          //查询所有积分列表
//    ECONSUMERQUERYMERCHANTLIST,             //查询商户列表
//    ECREDITINTERCHANGE,                     //积分互换
    EDISCOUNTOPTYPEMAX,
};

- (void)doConsumerQueryDiscount;
- (void)doConsumerBuyDiscount:(NSString *)discount ofMerchant:(NSString *)merchant withCredit:(NSArray *)credits;
//- (void)doConsumerCreateConsumption:(NSString *)merchant money:(NSInteger)money;
//- (void)doConsumerQueryOtherdisccoutList:(NSString *)merchant;
//- (void)doConsumerQueryOtherMerchantList:(NSString *)merchant;
//- (void)doCreditInterchange:(NSString *)credit from_merchant:(NSString *)from quantity:(NSInteger)quantity to_merchant:(NSString *)to exec_exchange:(BOOL)exec;

@property (nonatomic, copy) void (^afterConsumerQueryDiscount)(NSArray *disccoutList);
@property (nonatomic, copy) void (^afterConsumerBuyDiscount)(NSString *discout);
//@property (nonatomic, copy) void (^afterConsumerCreateConsumption)();
//@property (nonatomic, copy) void (^afterConsumerQueryOtherdisccoutList)(NSArray *disccoutList);
//@property (nonatomic, copy) void (^afterConsumerQueryOtherMerchantList)(NSArray *merchantList);
//@property (nonatomic, copy) void (^afterCreditInterchange)(NSInteger quantity, NSInteger fee);


@property (nonatomic, copy) void (^afterConsumerQueryDiscountFailed)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerBuyDiscountFailed)(NSString *message);
//@property (nonatomic, copy) void (^afterConsumerQueryOtherdisccoutListFailed)(NSString *message);
//@property (nonatomic, copy) void (^afterConsumerQueryOtherMerchantListFailed)(NSString *message);
//@property (nonatomic, copy) void (^afterCreditInterchangeFailed)(NSString *message);

@property (nonatomic, copy) void (^afterConsumerQueryDiscountFailedNetConnect)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerBuyDiscountFailedNetConnect)(NSString *message);


@end
