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
    ECONSUMERHANDLETYPEMAX,
};

- (void)doConsumerQueryAllCredit;

@property (nonatomic, copy) void (^afterConsumerQueryAllCredit)(NSString *location);
@end
