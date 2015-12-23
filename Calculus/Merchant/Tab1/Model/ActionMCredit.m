//
//  ActionMCredit.m
//  Calculus
//
//  Created by tracedeng on 15/12/22.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionMCredit.h"
#import "SKeyManager.h"
#import "MMaterialManager.h"
#import "Constance.h"

@interface ActionMCredit ()
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) EMCREDITOPTYPE type;     //用户资料操作类型

@property (nonatomic, retain) NSDictionary *state;  //登录态 {"accout": @"18688982240", "skey": @"_Rjdifjwe7234876sdfD"}
@property (nonatomic, retain) NSString *merchant;
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *skey;
@end

@implementation ActionMCredit

- (id)init {
    self = [super init];
    if (self) {
        self.state = [SKeyManager getSkey];
        self.merchant = [[MMaterialManager getMaterial] objectForKey:@"identity"];
        self.account = [self.state objectForKey:@"account"];
        self.skey = [self.state objectForKey:@"skey"];
        self.net = [[NetCommunication alloc] initWithHttpUrl:CREDITURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}

- (void)doQueryConsumerCredit {
    self.type = EQUERYCONSUMERCREDIT;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"credit_list_m", @"type", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}


- (void)doMerchantQueryApplyCredit {
    self.type = EMERCHANTQUERYAPPLYCREDIT;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"apply_list_m", @"type", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doConfirmApplyCredit:(NSString *)identity sums:(NSInteger)sums {
    self.type = ECONFIRMAPPLYCREDIT;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"confirm", @"type", self.merchant, @"merchant", identity, @"credit", [NSString stringWithFormat:@"%ld", (long)sums], @"sums", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doRefuseApplyCredit:(NSString *)identity reason:(NSString *)reason {
    self.type = EREFUSEAPPLYCREDIT;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"refuse", @"type", identity, @"credit", reason, @"reason", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

#pragma mark -NetCommunication Delegate

//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    NSInteger errorCode = [[responseObject objectForKey:@"c"] integerValue];
    if (1 == errorCode) {
        switch (self.type) {
            case EMERCHANTQUERYAPPLYCREDIT:
            {
                NSArray *creditList = [responseObject objectForKey:@"r"];
                if (self.afterMerchantQueryApplyCredit) {
                    self.afterMerchantQueryApplyCredit(creditList);
                }
                break;
            }
            case ECONFIRMAPPLYCREDIT:
            {
                NSArray *creditList = [responseObject objectForKey:@"r"];
                if (self.afterConfirmApplyCredit) {
                    self.afterConfirmApplyCredit(creditList);
                }
                break;
            }
            case EREFUSEAPPLYCREDIT:
            {
                NSString *credit = [responseObject objectForKey:@"r"];
                DLog(@"credit id %@", credit);
                if (self.afterRefuseApplyCredit) {
                    self.afterRefuseApplyCredit();
                }
                break;
            }
            default:
                break;
        }
    }else{
        switch (self.type) {
            case EMERCHANTQUERYAPPLYCREDIT:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterMerchantQueryApplyCreditFailed) {
                    self.afterMerchantQueryApplyCreditFailed(message);
                }
                break;
            }
            case ECONFIRMAPPLYCREDIT:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterConfirmApplyCreditFailed) {
                    self.afterConfirmApplyCreditFailed(message);
                }
                break;
            }
            case EREFUSEAPPLYCREDIT:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterRefuseApplyCreditFailed) {
                    self.afterRefuseApplyCreditFailed(message);
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
