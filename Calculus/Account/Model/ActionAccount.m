//
//  ActionAccount.m
//  Calculus
//
//  Created by tracedeng on 15/12/10.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionAccount.h"
#import "Constance.h"

@interface ActionAccount ()
//@property (nonatomic, retain) NSDictionary *state;  //登录态
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) EACCOUNTOPTYPE type;     //用户资料操作类型


@end

@implementation ActionAccount

- (id)init {
    self = [super init];
    if (self) {
        self.net = [[NetCommunication alloc] initWithHttpUrl:ACCOUNTURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}


/**
 *  获取短信验证码
 *
 *  @param nickname <#nickname description#>
 *  type/numbers
 */
- (void)doGetSMSCode:(NSString *)numbers kind:(NSString *)kind {
    self.type = EACCOUNTGETSMSCODE;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"get_sms_code", @"type", numbers, @"numbers", kind, @"kind", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doAccountLogin:(NSString *)numbers passwordMD5:(NSString *)passwordMD5 kind:(NSString *)kind{
    self.type = EACCOUNTLOGIN;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"login", @"type", numbers, @"numbers", kind, @"kind", passwordMD5, @"password_md5", nil];
    [self.net requestHttpWithData:postData];
}



#pragma mark -NetCommunication Delegate

//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    NSInteger errorCode = [[responseObject objectForKey:@"c"] integerValue];
    if (1 == errorCode) {
        switch (self.type) {
            case EACCOUNTGETSMSCODE:
            {
                NSString *location = [responseObject objectForKey:@"location"];
                if (self.afterGetSMSCode) {
                    self.afterGetSMSCode(location);
                }
                break;
            }
            case EACCOUNTLOGIN:
            {
                NSString *location = [responseObject objectForKey:@"location"];
                if (self.afterAccountLogin) {
                    self.afterAccountLogin(location);
                }
                break;

                
            }
            case EACCOUNTCHANGEPASSWORD:
            {
                //TODO 执行修改密码成功后操作
                break;
            }
            case EACCOUNTREGISTER:
            {
                //TODO 执行注册成功后操作
                break;
            }

            default:
                break;
        }
    }else{
        switch (self.type) {
            case EACCOUNTGETSMSCODE:
            {
                //TODO 返回验证码错误的原因
                break;
            }
            case EACCOUNTLOGIN:
            {
                //TODO 返回登录错误的原因
                break;
            }
            case EACCOUNTCHANGEPASSWORD:
            {
                //TODO 返回修改密码错误的原因
                break;
            }
            case EACCOUNTREGISTER:
            {
                //TODO 返回注册错误的原因
                break;
            }
                
            default:
                break;
        }
    }
}

//@optional http请求失败返回或没网
- (void)postFailResponseWith:(AFHTTPRequestOperation *)requestOperation responseError:(NSError *)responseError {
    NSLog(@"%@", [responseError domain]);
    NSLog(@"%ld", (long)[responseError code]);
    NSLog(@"%@", [responseError localizedDescription]);
}

@end
