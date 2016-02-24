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
- (void)doConsumerQueryCreditListWithout:(NSString *)merchant {
    self.type = ECONSUMERQUERYOTHERCREDITLIST;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"credit_list_detail", @"type", self.account, @"numbers", self.skey, @"session_key", merchant, @"merchant", nil];
    
    [self.net requestHttpWithData:postData];
}
- (void)doConsumerQueryMerchantListWithout:(NSString *)merchant {
    self.type = ECONSUMERQUERYMERCHANTLIST;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"verified_merchant", @"type", self.account, @"numbers", self.skey, @"session_key", nil];
    
    [self.net requestHttpWithData:postData];
}

- (void)doAllowInterchangeIn:(NSString *)merchant {
    self.type = EALLOWINTERCHANGEIN;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"allow_in", @"type", merchant, @"merchant", self.account, @"numbers", self.skey, @"session_key", nil];
    
    [self.net requestHttpWithData:postData];
}

- (void)doCreditInterchange:(NSString *)credit from_merchant:(NSString *)from quantity:(NSInteger)quantity to_merchant:(NSString *)to exec_exchange:(BOOL)exec  {
    self.type = ECREDITINTERCHANGE;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"interchange", @"type", credit, @"credit", from, @"from", to, @"to", [NSString stringWithFormat:@"%ld", (long)quantity], @"quantity", [NSString stringWithFormat:@"%d", exec], @"exec_interchange", self.account, @"numbers", self.skey, @"session_key", nil];
    
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
            case EALLOWINTERCHANGEIN:
            {
                NSString *allow = [[responseObject objectForKey:@"r"] stringValue];
                DLog(@"allow %@", allow);
                if (self.afterAllowInterchangeIn) {
                    self.afterAllowInterchangeIn(allow);
                }
                break;
            }
            case ECREDITINTERCHANGE:
            {
                NSInteger quantity = [[responseObject valueForKeyPath:@"r.quantity"] integerValue];
                NSInteger fee = [[responseObject valueForKeyPath:@"r.fee"] integerValue];
                if (self.afterCreditInterchange) {
                    self.afterCreditInterchange(quantity, fee);
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
            case EALLOWINTERCHANGEIN:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterAllowInterchangeInFailed) {
                    self.afterAllowInterchangeInFailed(message);
                }
                break;
            }
            case ECREDITINTERCHANGE:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterCreditInterchangeFailed) {
                    self.afterCreditInterchangeFailed(message);
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
//    DLog(@"%@", [responseError domain]);
    DLog(@"%ld", (long)[responseError code]);
//    DLog(@"%@", [responseError localizedDescription]);
    switch (self.type) {
        case ECONSUMERQUERYALLCREDIT:
        {
            if (self.afterConsumerQueryAllCreditFailed) {
                self.afterConsumerQueryAllCreditFailed([responseError localizedDescription]);
            }
            break;
        }
        case ECONSUMERQUERYONECREDIT:
        {
            if (self.afterConsumerQueryOneCreditFailed) {
                self.afterConsumerQueryOneCreditFailed([responseError localizedDescription]);
            }
            break;
        }
        case EALLOWINTERCHANGEIN:
        {
            if (self.afterAllowInterchangeInFailed) {
                self.afterAllowInterchangeInFailed([responseError localizedDescription]);
            }
            break;
        }
        default:
            break;
    }
}

@end
