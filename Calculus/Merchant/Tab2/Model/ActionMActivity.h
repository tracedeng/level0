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
    EQUERYUPLOADTOKEN,          //获取上传活动海报7牛token
    EMACTIVITYOPTYPEMAX,
};

- (void)doQueryMerchantActivity:(NSString *)merchant;
- (void)doDeleteMerchantActivity:(NSString *)merchant activity:(NSString *)activity;
- (void)doUpdateMerchantActivity:(NSString *)activity title:(NSString *)title introduce:(NSString *)introduce credit:(NSString *)credit poster:(NSString *)poster expire_time:(NSString *)expire_time;
- (void)doAddMerchantActivity:(NSString *)title introduce:(NSString *)introduce credit:(NSString *)credit poster:(NSString *)poster expire_time:(NSString *)expire_time;
- (void)doQueryUploadToken:(NSString *)merchant;


@property (nonatomic, copy) void (^afterQueryMerchantActivity)(NSDictionary *activity);
@property (nonatomic, copy) void (^afterDeleteMerchantActivity)();
@property (nonatomic, copy) void (^afterUpdateMerchantActivity)();
@property (nonatomic, copy) void (^afterAddMerchantActivity)(NSString *activity);
@property (nonatomic, copy) void (^afterQueryUploadToken)(NSDictionary *token);

@property (nonatomic, copy) void (^afterQueryMerchantActivityFailed)(NSString *message);
@property (nonatomic, copy) void (^afterDeleteMerchantActivityFailed)(NSString *message);
@property (nonatomic, copy) void (^afterUpdateMerchantActivityFailed)(NSString *message);
@property (nonatomic, copy) void (^afterAddMerchantActivityFailed)(NSString *message);
@property (nonatomic, copy) void (^afterQueryUploadTokenFailed)(NSString *message);


@property (nonatomic, copy) void (^afterQueryMerchantActivityFailedNetConnect)(NSString *message);
@property (nonatomic, copy) void (^afterDeleteMerchantActivityFailedNetConnect)(NSString *message);
@property (nonatomic, copy) void (^afterUpdateMerchantActivityFailedNetConnect)(NSString *message);
@property (nonatomic, copy) void (^afterAddMerchantActivityFailedNetConnect)(NSString *message);
@property (nonatomic, copy) void (^afterQueryUploadTokenFailedNetConnect)(NSString *message);

@end



