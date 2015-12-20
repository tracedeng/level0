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
};

- (void)doConsumerQueryAllCredit;
- (void)doConsumerQueryOneCredit:(NSString *)merchant;
- (void)doConsumerCreateConsumption:(NSString *)merchant money:(NSInteger)money;

@property (nonatomic, copy) void (^afterConsumerQueryAllCredit)(NSArray *creditList);
@property (nonatomic, copy) void (^afterConsumerQueryOneCredit)(NSArray *creditList);
@property (nonatomic, copy) void (^afterConsumerCreateConsumption)();

@property (nonatomic, copy) void (^afterConsumerQueryAllCreditFailed)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerQueryOneCreditFailed)(NSString *message);

@end
