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
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"delete", @"type", self.account, @"numbers",merchant, @"merchant", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
    
}

- (void)doUpdateMerchantActivity:(NSString *)merchant  activity:(NSString *)activity title:(NSString *)title introduce:(NSString *)introduce credit:(NSNumber *)credit poster:(NSString *)poster expire_time:(NSString *)expire_time{
    self.type = EUPDATEMERCHANTACTIVITY;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"create", @"type", self.account, @"numbers",merchant, @"merchant", self.skey, @"session_key", activity, @"activity", title, @"title", introduce, @"introduce", credit, @"credit", poster, @"poster", expire_time, @"expire", nil];
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
    if (0 == [[responseObject objectForKey:@"errcode"] integerValue]) {
        switch (self.type) {
            case EQUERYMERCHANTACTIVITY:
            {
                NSMutableArray *result = [responseObject objectForKey:@"r"];
                //                NSDictionary *material = [result objectAtIndex:0];
                if (self.afterQueryMerchantActivity) {
                    NSMutableArray *activity = [result count] > 0 ? result : nil;
                    self.afterQueryMerchantActivity(activity);
                }
                break;
            }
            case EDELETEMERCHANTACTIVITY:
            {
                NSString *result = [responseObject objectForKey:@"r"];
                //                NSDictionary *material = [result objectAtIndex:0];
                if (self.afterDeleteMerchantActivity) {
                    
                   
                    //                  NSDictionary *flow = [result count] > 0 ? [NSDictionary dictionaryWithDictionary: result] : nil;
                    self.afterDeleteMerchantActivity(result);
                }
                break;
            }
            case EUPDATEMERCHANTACTIVITY:
            {
                NSString *result = [responseObject objectForKey:@"r"];
                //                NSDictionary *material = [result objectAtIndex:0];
                if (self.afterUpdateMerchantActivity) {
//                    NSMutableArray *activity = [result count] > 0 ? [result objectAtIndex:0] : nil;
                    //                  NSDictionary *flow = [result count] > 0 ? [NSDictionary dictionaryWithDictionary: result] : nil;
                    self.afterUpdateMerchantActivity(result);
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
//            case EMERCHANTQUERYAPPLYCREDIT:
//            {
//                NSString *message = [responseObject objectForKey:@"m"];
//                if (self.afterMerchantQueryApplyCreditFailed) {
//                    self.afterMerchantQueryApplyCreditFailed(message);
//                }
//                break;
//            }
//            case ECONFIRMAPPLYCREDIT:
//            {
//                NSString *message = [responseObject objectForKey:@"m"];
//                if (self.afterConfirmApplyCreditFailed) {
//                    self.afterConfirmApplyCreditFailed(message);
//                }
//                break;
//            }
//            case EREFUSEAPPLYCREDIT:
//            {
//                NSString *message = [responseObject objectForKey:@"m"];
//                if (self.afterRefuseApplyCreditFailed) {
//                    self.afterRefuseApplyCreditFailed(message);
//                }
//                break;
//            }
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
}

@end
