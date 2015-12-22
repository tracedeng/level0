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

- (void)doGetSMSCode:(NSString *)numbers;
- (void)doAccountLogin:(NSString *)numbers password:(NSString *)password;
- (void)doAccountRegister:(NSString *)numbers password:(NSString *)password  code:(NSString *)code;
- (void)doAccountResetPassword:(NSString *)numbers password:(NSString *)password code:(NSString *)code;

@property (nonatomic, copy) void (^afterGetSMSCode)(NSString *result);
@property (nonatomic, copy) void (^afterAccountLogin)(NSDictionary *material);
@property (nonatomic, copy) void (^afterAccountRegister)(NSString *result);
@property (nonatomic, copy) void (^afterAccountResetPassword)(NSString *result);

+ (BOOL)doWeakLogin;
+ (BOOL)doLogout;
@end
