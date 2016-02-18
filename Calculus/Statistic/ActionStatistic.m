//
//  ActionStatistic.m
//  Calculus
//
//  Created by tracedeng on 16/2/18.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "ActionStatistic.h"
#import "SKeyManager.h"
#import "MMaterialManager.h"
#import "RoleManager.h"
#import "Constance.h"

@interface ActionStatistic ()
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) ESTATISTICOPTYPE type;     //用户资料操作类型

@property (nonatomic, retain) NSDictionary *state;  //登录态 {"accout": @"18688982240", "skey": @"_Rjdifjwe7234876sdfD"}
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *skey;
@end

@implementation ActionStatistic
- (id)init {
    self = [super init];
    if (self) {
        self.state = [SKeyManager getSkey];
//        self.merchant = [[MMaterialManager getMaterial] objectForKey:@"id"];
        self.account = [self.state objectForKey:@"account"];
        self.skey = [self.state objectForKey:@"skey"];
        self.net = [[NetCommunication alloc] initWithHttpUrl:CREDITURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}

- (void)doReportVersion:(NSString *)version {
    self.type = ESTATISTICVERSIONREPORT;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"version", @"type", version, @"version", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doFeedback:(NSString *)version feedback:(NSString *)feedback {
    self.type = ESTATISTICFEEDBACK;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"feedback", @"type", version, @"version", feedback, @"feedback", [RoleManager currentRole], @"mode", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}


#pragma mark -NetCommunication Delegate

//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    NSInteger errorCode = [[responseObject objectForKey:@"c"] integerValue];
    if (1 == errorCode) {
        switch (self.type) {
            case ESTATISTICVERSIONREPORT:
            {
//                NSString *result = [responseObject objectForKey:@"r"];
                if (self.afterReportVersion) {
                    self.afterReportVersion();
                }
                break;
            }
//            case EQUERYONECONSUMERCREDIT:
//            {
//                NSArray *creditList = [responseObject objectForKey:@"r"];
//                if (self.afterQueryOneConsumerCredit) {
//                    self.afterQueryOneConsumerCredit(creditList);
//                }
//                break;
//            }
//            case EMERCHANTQUERYAPPLYCREDIT:
//            {
//                NSArray *creditList = [responseObject objectForKey:@"r"];
//                if (self.afterMerchantQueryApplyCredit) {
//                    self.afterMerchantQueryApplyCredit(creditList);
//                }
//                break;
//            }
            case ESTATISTICFEEDBACK:
            {
//                NSString *result = [responseObject objectForKey:@"r"];
                if (self.afterFeedback) {
                    self.afterFeedback();
                }
                break;
            }
            default:
                break;
        }
    }else{
        switch (self.type) {
            case ESTATISTICVERSIONREPORT:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterReportVersionFailed) {
                    self.afterReportVersionFailed(message);
                }
                break;
            }
//            case EQUERYONECONSUMERCREDIT:
//            {
//                NSString *message = [responseObject objectForKey:@"m"];
//                if (self.afterQueryOneConsumerCreditFailed) {
//                    self.afterQueryOneConsumerCreditFailed(message);
//                }
//                break;
//            }
//            case EMERCHANTQUERYAPPLYCREDIT:
//            {
//                NSString *message = [responseObject objectForKey:@"m"];
//                if (self.afterMerchantQueryApplyCreditFailed) {
//                    self.afterMerchantQueryApplyCreditFailed(message);
//                }
//                break;
//            }
            case ESTATISTICFEEDBACK:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterFeedbackFailed) {
                    self.afterFeedbackFailed(message);
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
        case ESTATISTICVERSIONREPORT:
        {
            if (self.afterReportVersionFailed) {
                self.afterReportVersionFailed([responseError localizedDescription]);
            }
            break;
        }
//        case EQUERYONECONSUMERCREDIT:
//        {
//            if (self.afterQueryOneConsumerCreditFailed) {
//                self.afterQueryOneConsumerCreditFailed([responseError localizedDescription]);
//            }
//            break;
//        }
//        case EMERCHANTQUERYAPPLYCREDIT:
//        {
//            if (self.afterMerchantQueryApplyCreditFailed) {
//                self.afterMerchantQueryApplyCreditFailed([responseError localizedDescription]);
//            }
//            
//            break;
//        }
        case ESTATISTICFEEDBACK:
        {
            if (self.afterFeedbackFailed) {
                self.afterFeedbackFailed([responseError localizedDescription]);
            }
            break;
        }
        default:
            break;
    }
}

@end
