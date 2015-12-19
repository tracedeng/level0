//
//  ActionMMaterial.m
//  Calculus
//
//  Created by tracedeng on 15/12/18.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionMMaterial.h"
#import "SKeyManager.h"
#import "Constance.h"

@interface ActionMMaterial ()
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) EMMATERIALOPTYPE type;     //商家资料操作类型

@property (nonatomic, retain) NSDictionary *state;  //登录态 {"accout": @"18688982240", "skey": @"_Rjdifjwe7234876sdfD"}
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *skey;
@end


@implementation ActionMMaterial

- (id)init {
    self = [super init];
    if (self) {
        self.state = [SKeyManager getSkey];
        self.account = [self.state objectForKey:@"account"];
        self.skey = [self.state objectForKey:@"skey"];
        self.net = [[NetCommunication alloc] initWithHttpUrl:MERCHANTURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}

- (void)doQueryMerchantOfAccount {
    self.type = EQUERYMERCHANT;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"retrieve", @"type", self.account, @"numbers", self.skey, @"session_key", nil];
    
    [self.net requestHttpWithData:postData];

}

- (void)doCreateMerchantOfAccount:(NSString *)name logo:(NSString *)logo {
    self.type = ECREATEMERCHNAT;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"create", @"type", name, @"name", logo, @"logo", self.account, @"numbers", self.skey, @"session_key", nil];
    
    [self.net requestHttpWithData:postData];

}

- (void)doQueryUploadToken:(NSString *)merchant {
    self.type = EQUERYUPLOADTOKEN;
    
#ifdef DEBUG
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"upload_token", @"type", @"m_logo", @"resource", merchant, @"merchant", @"debug", @"debug", self.account, @"numbers", self.skey, @"session_key", nil];
#else
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"upload_token", @"type", @"m_logo", @"resource", merchant, @"merchant", self.account, @"numbers", self.skey, @"session_key", nil];
#endif
    [self.net requestHttpWithData:postData];
}

- (void)doModifyLogo:(NSString *)logo merchant:(NSString *)merchant {
    self.type = EUPDATELOGO;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"update", @"type", logo, @"logo", merchant, @"merchant", self.account, @"numbers", self.skey, @"session_key", nil];
    
    [self.net requestHttpWithData:postData];
}

#pragma mark -NetCommunication Delegate
//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    if (0 == [[responseObject objectForKey:@"errcode"] integerValue]) {
        switch (self.type) {
            case EQUERYMERCHANT:
            {
                NSArray *result = [responseObject objectForKey:@"r"];
//                NSDictionary *material = [result objectAtIndex:0];
                if (self.afterQueryMerchantOfAccount) {
                    NSDictionary *material = [result count] > 0 ? [result objectAtIndex:0] : nil;
                    self.afterQueryMerchantOfAccount(material);
                }
                break;
            }
            case ECREATEMERCHNAT:
            {
                NSString *merchant = [responseObject objectForKey:@"r"];
                if (self.afterCreateMerchantOfAccount) {
                    self.afterCreateMerchantOfAccount(merchant);
                }
                break;
            }
            case EQUERYUPLOADTOKEN:
            {
                //更新用户头像，上传文件代理调用uploadSuccessResponseWith
                NSDictionary *result = [responseObject objectForKey:@"r"];
                if (self.afterQueryUploadToken) {
                    self.afterQueryUploadToken(result);
                }
                break;
            }
            case EUPDATELOGO:
            {
//                NSString *result = [responseObject objectForKey:@"r"];
                if (self.afterModifyLogo) {
                    self.afterModifyLogo();
                }
                break;
            }
            default:
                break;
        }
    }
}

//@optional http请求失败返回
- (void)postFailResponseWith:(AFHTTPRequestOperation *)requestOperation responseError:(NSError *)responseError {
    NSLog(@"%@", [responseError domain]);
    NSLog(@"%ld", (long)[responseError code]);
    NSLog(@"%@", [responseError localizedDescription]);
}
@end
