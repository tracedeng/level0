//
//  ActionAccount.h
//  Calculus
//
//  Created by tracedeng on 15/12/10.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetCommunication.h"

@interface ActionAccount : NSObject <NetCommunicationDelegate>
//操作类型
typedef NS_ENUM(NSInteger, EACCOUNTOPTYPE) {
    EACCOUNTGETSMSCODE = 1,              //获取短信验证码
    EACCOUNTLOGIN,              //登录
    EACCOUNTREGISTER,           //注册
    EACCOUNTCHANGEPASSWORD,     //重置密码
    EACCOUNTOPTYPEMAX,
};

- (void)doGetSMSCode:(NSString *)numbers kind:(NSString *)kind;
- (void)doAccountLogin:(NSString *)numbers passwordMD5:(NSString *)passwordMD5 kind:(NSString *)kind;
- (void)doAccountRegister:(NSString *)numbers passwordMD5:(NSString *)passwordMD5 kind:(NSString *)kind code:(NSString *) code;

@property (nonatomic, copy) void (^afterGetSMSCode)(NSString *result);
@property (nonatomic, copy) void (^afterAccountLogin)(NSString *result);
@property (nonatomic, copy) void (^afterAccountRegister)(NSString *result);

@end
