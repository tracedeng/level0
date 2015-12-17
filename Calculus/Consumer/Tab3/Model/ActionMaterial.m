//
//  ActionMaterial.m
//  Calculus
//
//  Created by tracedeng on 15/12/16.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionMaterial.h"
#import "SKeyManager.h"
#import "Constance.h"


@interface ActionMaterial ()
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) EMATERIALOPTYPE type;     //用户资料操作类型

@property (nonatomic, retain) NSDictionary *state;  //登录态 {"accout": @"18688982240", "skey": @"_Rjdifjwe7234876sdfD"}
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *skey;

@end


@implementation ActionMaterial

- (id)init {
    self = [super init];
    if (self) {
        self.state = [SKeyManager getSkey];
        self.account = [self.state objectForKey:@"account"];
        self.skey = [self.state objectForKey:@"skey"];
        self.net = [[NetCommunication alloc] initWithHttpUrl:CONSUMERURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}

- (void)doQueryUploadToken {
    self.type = EQUERYUPLOADTOKEN;
    
#ifdef DEBUG
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"upload_token", @"type", @"c_avatar", @"resource", @"debug", @"debug", self.account, @"numbers", self.skey, @"session_key", nil];
#else
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"upload_token", @"type", @"c_avatar", @"resource", self.account, @"numbers", self.skey, @"session_key", nil];
#endif
    [self.net requestHttpWithData:postData];
}

- (void)doModifyAvatar:(NSString *)avatar {
    self.type = EUPDATEAVATAR;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"update", @"type", avatar, @"avatar", self.account, @"numbers", self.skey, @"session_key", nil];

    [self.net requestHttpWithData:postData];
}

#pragma mark -NetCommunication Delegate
//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    if (0 == [[responseObject objectForKey:@"errcode"] integerValue]) {
        switch (self.type) {
            case EQUERYUPLOADTOKEN:
            {
                //更新用户头像，上传文件代理调用uploadSuccessResponseWith
                NSDictionary *result = [responseObject objectForKey:@"r"];
                if (self.afterQueryUploadToken) {
                    self.afterQueryUploadToken(result);
                }
                break;
            }
            case EUPDATEAVATAR:
            {
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
