//
//  ActionAccount.m
//  Calculus
//
//  Created by tracedeng on 15/12/10.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionAccount.h"
#import "Constance.h"
#import "SyncHttp.h"
#import "SKeyManager.h"
#import "MaterialManager.h"
#import "NSString+Md5.h"
#import "GTMBase64.h"

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
- (void)doGetSMSCode:(NSString *)numbers {
    self.type = EACCOUNTGETSMSCODE;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"get_sms_code", @"type", numbers, @"numbers", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doAccountLogin:(NSString *)numbers password:(NSString *)password {
    self.type = EACCOUNTLOGIN;
    
    NSString *passwordMd5 =[[NSString alloc] initWithData:[GTMBase64 encodeData:[[[[[password md5HexDigest] md5HexDigest] stringByAppendingString:numbers] md5HexDigest] dataUsingEncoding:NSUTF8StringEncoding]] encoding:NSUTF8StringEncoding];
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"login", @"type", numbers, @"numbers", passwordMd5, @"password_md5", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doAccountRegister:(NSString *)numbers passwordMD5:(NSString *)passwordMD5 code:(NSString *)code{
    self.type = EACCOUNTREGISTER;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"register", @"type", numbers, @"numbers", passwordMD5, @"password_md5",code,@"sms_code", nil];
    [self.net requestHttpWithData:postData];

}

- (void)doAccountResetPassword:(NSString *)numbers passwordMD5:(NSString *)passwordMD5 code:(NSString *)code{
    self.type = EACCOUNTCHANGEPASSWORD;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"change_password", @"type", numbers, @"numbers", passwordMD5, @"password_md5",code,@"sms_code",  nil];
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
                NSString *result = [responseObject objectForKey:@"r"];
                if (self.afterGetSMSCode) {
                    self.afterGetSMSCode(result);
                }
                break;
            }
            case EACCOUNTLOGIN:
            {
                NSDictionary *material = [responseObject objectForKey:@"r"];
                if (self.afterAccountLogin) {
                    self.afterAccountLogin(material);
                }
                break;

                
            }
            case EACCOUNTCHANGEPASSWORD:
            {
                NSString *result = [responseObject objectForKey:@"r"];
                if (self.afterAccountResetPassword) {
                    self.afterAccountResetPassword(result);
                }
                break;
            }
            case EACCOUNTREGISTER:
            {
                NSString *result = [responseObject objectForKey:@"r"];
                if (self.afterAccountRegister) {
                    self.afterAccountRegister(result);
                }
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


+ (BOOL)doWeakLogin {
    NSString *numbers = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    if (!numbers || !password) {
        return false;
    }
    
    // 加密
    NSString *passwordMd5 =[[NSString alloc] initWithData:[GTMBase64 encodeData:[[[[[password md5HexDigest] md5HexDigest] stringByAppendingString:numbers] md5HexDigest] dataUsingEncoding:NSUTF8StringEncoding]] encoding:NSUTF8StringEncoding];

    // 同步登陆请求
    NSDictionary *result = [SyncHttp syncPost:ACCOUNTURL data:[[NSDictionary alloc] initWithObjectsAndKeys:@"login", @"type", numbers, @"numbers", passwordMd5, @"password_md5", nil]];
    
    if (!result) {
        return false;
    }
    
    NSString *skey = [result objectForKey:@"sk"];
    [SKeyManager changeSkey:skey ofAccount:numbers];
    [MaterialManager setMaterial:result];

    return skey ? true : false;
}

+ (BOOL)doLogout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
    [SKeyManager clearSkey];
    return true;
}


@end
