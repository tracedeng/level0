//
//  ActionMActivity.m
//  Calculus
//
//  Created by tracedeng on 15/12/31.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionMActivity.h"
#import "Constance.h"
#import "SKeyManager.h"
#import "MMaterialManager.h"

@interface ActionMActivity()
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) EMACTIVITYOPTYPE type;     //活动操作类型
@property (nonatomic, retain) NSString *merchant;
@property (nonatomic, retain) NSDictionary *state;  //登录态 {"accout": @"18688982240", "skey": @"_Rjdifjwe7234876sdfD"}
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *skey;

@end

@implementation ActionMActivity
- (id)init {
    self = [super init];
    if (self) {
        self.state = [SKeyManager getSkey];
        self.account = [self.state objectForKey:@"account"];
        self.skey = [self.state objectForKey:@"skey"];
        self.merchant = [[MMaterialManager getMaterial] objectForKey:@"id"];
        self.net = [[NetCommunication alloc] initWithHttpUrl:ACTIVITYURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}

- (void)doQueryMerchantActivity:(NSString *)merchant{
    self.type = EQUERYMERCHANTACTIVITY;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"retrieve", @"type", self.account, @"numbers",merchant, @"merchant", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
    
}

- (void)doDeleteMerchantActivity:(NSString *)merchant activity:(NSString *)activity {
    self.type = EDELETEMERCHANTACTIVITY;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"delete", @"type", self.account, @"numbers",merchant, @"merchant", activity, @"activity", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
    
}

- (void)doUpdateMerchantActivity:(NSString *)activity title:(NSString *)title introduce:(NSString *)introduce credit:(NSNumber *)credit poster:(NSString *)poster expire_time:(NSString *)expire_time {
    self.type = EUPDATEMERCHANTACTIVITY;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"update", @"type", self.account, @"numbers", self.merchant, @"merchant", self.skey, @"session_key", activity, @"activity", title, @"title", introduce, @"introduce", credit, @"credit", poster, @"poster", expire_time, @"expire", nil];
    [self.net requestHttpWithData:postData];
    
}

- (void)doAddMerchantActivity:(NSString *)title introduce:(NSString *)introduce credit:(NSString *)credit poster:(NSString *)poster expire_time:(NSString *)expire_time{
    self.type = EADDMERCHANTACTIVITY;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"create", @"type", self.account, @"numbers", self.merchant, @"merchant", self.skey, @"session_key", title, @"title", introduce, @"introduce", credit, @"credit", poster, @"poster", expire_time, @"expire", nil];
    [self.net requestHttpWithData:postData];
    
}

- (void)doQueryUploadToken:(NSString *)merchant {
    self.type = EQUERYUPLOADTOKEN;
    
#ifdef DEBUG
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"upload_token", @"type", @"a_poster", @"resource", merchant, @"merchant", @"debug", @"debug", self.account, @"numbers", self.skey, @"session_key", nil];
#else
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"upload_token", @"type", @"m_logo", @"resource", merchant, @"merchant", self.account, @"numbers", self.skey, @"session_key", nil];
#endif
    [self.net requestHttpWithData:postData];
}

#pragma mark -NetCommunication Delegate
//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    if (1 == [[responseObject objectForKey:@"c"] integerValue]) {
        switch (self.type) {
            case EQUERYMERCHANTACTIVITY:
            {
                NSDictionary *result = [responseObject objectForKey:@"r"];
                if (self.afterQueryMerchantActivity) {
//                    NSMutableArray *activity = [result count] > 0 ? result : nil;
                    self.afterQueryMerchantActivity(result);
                }
                break;
            }
            case EDELETEMERCHANTACTIVITY:
            {
                if (self.afterDeleteMerchantActivity) {
                    self.afterDeleteMerchantActivity();
                }
                break;
            }
            case EUPDATEMERCHANTACTIVITY:
            {
                if (self.afterUpdateMerchantActivity) {
                    self.afterUpdateMerchantActivity();
                }
                break;
            }
            case EADDMERCHANTACTIVITY:
            {
                NSString *activity = [responseObject objectForKey:@"r"];
                if (self.afterAddMerchantActivity) {
                    self.afterAddMerchantActivity(activity);
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
            default:
                break;
        }
    }else{
        switch (self.type) {
            case EQUERYMERCHANTACTIVITY:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterQueryMerchantActivityFailed) {
                    self.afterQueryMerchantActivityFailed(message);
                }
                break;
            }
            case EDELETEMERCHANTACTIVITY:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterDeleteMerchantActivityFailed) {
                    self.afterDeleteMerchantActivityFailed(message);
                }
                break;
            }
            case EUPDATEMERCHANTACTIVITY:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterUpdateMerchantActivityFailed) {
                    self.afterUpdateMerchantActivityFailed(message);
                }
                break;
            }
            case EADDMERCHANTACTIVITY:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterAddMerchantActivityFailed) {
                    self.afterAddMerchantActivityFailed(message);
                }
                break;
            }
            case EQUERYUPLOADTOKEN:
            {
                //更新用户头像，上传文件代理调用uploadSuccessResponseWith
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterQueryUploadTokenFailed) {
                    self.afterQueryUploadTokenFailed(message);
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
    DLog(@"%@", [responseError domain]);
    DLog(@"%ld", (long)[responseError code]);
    DLog(@"%@", [responseError localizedDescription]);
    switch (self.type) {
        case EQUERYMERCHANTACTIVITY:
        {
            if (self.afterQueryMerchantActivityFailed) {
                self.afterQueryMerchantActivityFailed([responseError localizedDescription]);
            }
            break;
        }
        case EDELETEMERCHANTACTIVITY:
        {
            if (self.afterDeleteMerchantActivityFailed) {
                self.afterDeleteMerchantActivityFailed([responseError localizedDescription]);
            }
            break;
        }
        case EUPDATEMERCHANTACTIVITY:
        {
            if (self.afterUpdateMerchantActivityFailed) {
                self.afterUpdateMerchantActivityFailed([responseError localizedDescription]);
            }
            
            break;
        }
        case EADDMERCHANTACTIVITY:
        {
            if (self.afterAddMerchantActivityFailed) {
                self.afterAddMerchantActivityFailed([responseError localizedDescription]);
            }
            
            break;
        }
        case EQUERYUPLOADTOKEN:
        {
            if (self.afterQueryUploadTokenFailed) {
                self.afterQueryUploadTokenFailed([responseError localizedDescription]);
            }
            
            break;
        }
            
        default:
            break;
    }

}

@end
