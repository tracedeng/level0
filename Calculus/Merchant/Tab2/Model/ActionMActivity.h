//
//  ActionMActivity.h
//  Calculus
//
//  Created by tracedeng on 15/12/31.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetCommunication.h"

@interface ActionMActivity : NSObject<NetCommunicationDelegate>
typedef NS_ENUM(NSInteger, EMACTIVITYOPTYPE) {
    EQUERYMERCHANTACTIVITY,   //查询商户自有活动列表
    EDELETEMERCHANTACTIVITY,
    EUPDATEMERCHANTACTIVITY,
    EADDMERCHANTACTIVITY,
};

- (void)doQueryMerchantActivity:(NSString *)merchant;
- (void)doDeleteMerchantActivity:(NSString *)merchant activity:(NSString *)activity;
- (void)doUpdateMerchantActivity:(NSString *)merchant  activity:(NSString *)activity title:(NSString *)title introduce:(NSString *)introduce credit:(NSString *)credit poster:(NSString *)poster expire_time:(NSString *)expire_time;
- (void)doAddMerchantActivity:(NSString *)merchant title:(NSString *)title introduce:(NSString *)introduce credit:(NSString *)credit poster:(NSString *)poster expire_time:(NSString *)expire_time;


@property (nonatomic, copy) void (^afterQqueryMerchantActivity)(NSMutableArray *activity);
@property (nonatomic, copy) void (^afterDeleteMerchantActivity)(NSString *result);
@property (nonatomic, copy) void (^afterUpdateMerchantActivity)(NSString *result);
@property (nonatomic, copy) void (^afterAddMerchantActivity)(NSString *result);

@end



