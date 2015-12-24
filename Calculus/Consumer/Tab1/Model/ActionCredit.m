//
//  ActionCredit.m
//  Calculus
//
//  Created by tracedeng on 15/12/10.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionCredit.h"
#import "SKeyManager.h"
#import "Constance.h"

@interface ActionCredit ()
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) ECREDITOPTYPE type;     //用户资料操作类型

@property (nonatomic, retain) NSDictionary *state;  //登录态 {"accout": @"18688982240", "skey": @"_Rjdifjwe7234876sdfD"}
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *skey;
@end

@implementation ActionCredit

- (id)init {
    self = [super init];
    if (self) {
        self.state = [SKeyManager getSkey];
        self.account = [self.state objectForKey:@"account"];
        self.skey = [self.state objectForKey:@"skey"];
        self.net = [[NetCommunication alloc] initWithHttpUrl:CREDITURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}


/**
 *  客户查询所有积分
 *
 *  @param nickname <#nickname description#>
 *  type/numbers/session_key
 */
- (void)doConsumerQueryAllCredit {
    self.type = ECONSUMERQUERYALLCREDIT;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"credit_list", @"type", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doConsumerQueryOneCredit:(NSString *)merchant {
    self.type = ECONSUMERQUERYONECREDIT;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"credit_list_of_merchant", @"type", merchant, @"merchant", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];

}

- (void)doConsumerCreateConsumption:(NSString *)merchant money:(NSInteger)money {
    self.type = ECONSUMERCREATECONSUMPTION;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"consumption", @"type", [NSString stringWithFormat:@"%ld", money], @"sums", merchant, @"merchant", self.account, @"numbers", self.skey, @"session_key", nil];
    
    [self.net requestHttpWithData:postData];
}
- (void)doConsumerQueryOtherCreditList:(NSString *)merchant {
    self.type = ECONSUMERQUERYOTHERCREDITLIST;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"credit_list_detail", @"type", self.account, @"numbers", self.skey, @"session_key", nil];
    
    [self.net requestHttpWithData:postData];
}
- (void)doConsumerQueryOtherMerchantList:(NSString *)merchant{
    self.type = ECONSUMERQUERYMERCHANTLIST;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"verified_merchant", @"type", self.account, @"numbers", self.skey, @"session_key", nil];
    
    [self.net requestHttpWithData:postData];
}

#pragma mark -NetCommunication Delegate

//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    NSInteger errorCode = [[responseObject objectForKey:@"c"] integerValue];
    if (1 == errorCode) {
        switch (self.type) {
            case ECONSUMERQUERYALLCREDIT:
            {
                NSArray *creditList = [responseObject objectForKey:@"r"];
                if (self.afterConsumerQueryAllCredit) {
                    self.afterConsumerQueryAllCredit(creditList);
                }
                break;
            }
            case ECONSUMERQUERYONECREDIT:
            {
                NSArray *creditList = [responseObject valueForKeyPath:@"r.c"];
                if (self.afterConsumerQueryOneCredit) {
                    self.afterConsumerQueryOneCredit(creditList);
                }
                break;
            }
            case ECONSUMERCREATECONSUMPTION:
            {
                NSString *credit = [responseObject objectForKey:@"r"];
                DLog(@"credit id %@", credit);
                if (self.afterConsumerCreateConsumption) {
                    self.afterConsumerCreateConsumption();
                }
                break;
            }
            case ECONSUMERQUERYOTHERCREDITLIST:
            {
                NSArray *creditList = [responseObject objectForKey:@"r"];
                DLog(@"credit id %@", creditList);
                if (self.afterConsumerQueryOtherCreditList) {
                    self.afterConsumerQueryOtherCreditList(creditList);
                }
                break;
            }
            case ECONSUMERQUERYMERCHANTLIST:
            {
                NSArray *merchantList = [responseObject objectForKey:@"r"];
                DLog(@"credit id %@", merchantList);
                if (self.afterConsumerQueryOtherMerchantList) {
                    self.afterConsumerQueryOtherMerchantList(merchantList);
                }
                break;
            }
            default:
                break;
        }
    }else{
        switch (self.type) {
            case ECONSUMERQUERYALLCREDIT:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterConsumerQueryAllCreditFailed) {
                    self.afterConsumerQueryAllCreditFailed(message);
                }
                break;
            }
            case ECONSUMERQUERYONECREDIT:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterConsumerQueryOneCreditFailed) {
                    self.afterConsumerQueryOneCreditFailed(message);
                }
                break;
            }
            case ECONSUMERQUERYOTHERCREDITLIST:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterConsumerQueryOtherCreditListFailed) {
                    self.afterConsumerQueryOtherCreditListFailed(message);
                }
                break;
            }
            case ECONSUMERQUERYMERCHANTLIST:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterConsumerQueryOtherMerchantListFailed) {
                    self.afterConsumerQueryOtherMerchantListFailed(message);
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
