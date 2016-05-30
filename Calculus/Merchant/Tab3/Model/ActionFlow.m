//
//  ActionFlow.m
//  Calculus
//
//  Created by ben on 15/12/30.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionFlow.h"
#import "Constance.h"
#import "SKeyManager.h"

@interface ActionFlow()
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) EFLOWOPTYE type;     //商家资料操作类型

@property (nonatomic, retain) NSDictionary *state;  //登录态 {"accout": @"18688982240", "skey": @"_Rjdifjwe7234876sdfD"}
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *skey;

@end


@implementation ActionFlow
- (id)init {
    self = [super init];
    if (self) {
        self.state = [SKeyManager getSkey];
        self.account = [self.state objectForKey:@"account"];
        self.skey = [self.state objectForKey:@"skey"];
        self.net = [[NetCommunication alloc] initWithHttpUrl:FLOWURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}

- (void)doQueryFlow:(NSString *)merchant{
    self.type = EQUERYFLOW;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"retrieve", @"type", self.account, @"numbers",merchant, @"merchant", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doQueryAllowExchangeIn:(NSString *)merchant {
    self.type = EQRERYALLOWEXCHANGEIN;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"allow", @"type", merchant, @"merchant", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

//- (void)doQueryBusinessParameters:(NSString *)merchant{
//}

- (void)doQueryBalanceHistory:(NSString *)merchant {
    self.type = EQUERYBALANCEHISTORY;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"balance_record", @"type", merchant, @"merchant", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doRecharge:(NSString *)merchant money:(NSInteger)money {
    self.type = ERECHARGE;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"recharge", @"type", merchant, @"merchant", [NSString stringWithFormat:@"%ld", (long)money], @"money", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doWithdrawals:(NSString *)merchant money:(NSInteger)money {
    self.type = EWITHDRAWALS;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"withdrawals", @"type", merchant, @"merchant", [NSString stringWithFormat:@"%ld", (long)money], @"money", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doQueryBalance:(NSString *)merchant {
    self.type = EQUERYBALANCE;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"balance", @"type", merchant, @"merchant", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

#pragma mark -NetCommunication Delegate
//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    if (1 == [[responseObject objectForKey:@"c"] integerValue]) {
        switch (self.type) {
            case EQUERYFLOW:
            {
                NSArray *result = [responseObject objectForKey:@"r"];
                if (self.afterQqueryFlow) {
                    NSDictionary *flow = [result count] > 0 ? [result objectAtIndex:0] : nil;
//                  NSDictionary *flow = [result count] > 0 ? [NSDictionary dictionaryWithDictionary: result] : nil;
                    self.afterQqueryFlow(flow);
                }
                break;
            }
            case EQRERYALLOWEXCHANGEIN:
            {
                NSString *allow = [responseObject objectForKey:@"r"];
                if (self.afterQueryAllowExchangeIn) {
                    self.afterQueryAllowExchangeIn(allow);
                }
                break;
            }
            case EQUERYBALANCEHISTORY:
            {
                NSArray *result = [responseObject valueForKeyPath:@"r"];
                NSArray *history = [[result objectAtIndex:0] objectForKey:@"a"];
                if (self.afterQueryBalanceHistory) {
                    self.afterQueryBalanceHistory(history);
                }
                break;
            }
            case ERECHARGE:
            {
                NSString *result = [responseObject valueForKeyPath:@"r"];
                if (self.afterRecharge) {
                    self.afterRecharge(result);
                }
                break;
            }
            case EWITHDRAWALS:
            {
                NSString *result = [responseObject valueForKeyPath:@"r"];
                if (self.afterWithdrawals) {
                    self.afterWithdrawals(result);
                }
                break;
            }
            case EQUERYBALANCE:
            {
                NSString *result = [responseObject valueForKeyPath:@"r"];
                if (self.afterQueryBalance) {
                    self.afterQueryBalance(result);
                }
                break;
            }
            default:
                break;
        }
    }else{
        switch (self.type) {
            case EQUERYFLOW:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterQqueryFlowFailed) {
                    self.afterQqueryFlowFailed(message);
                }
                break;
            }
            case EQRERYALLOWEXCHANGEIN:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterQueryAllowExchangeInFailed) {
                    self.afterQueryAllowExchangeInFailed(message);
                }
                break;
            }
            case EQUERYBALANCEHISTORY:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterQueryBalanceHistoryFailed) {
                    self.afterQueryBalanceHistoryFailed(message);
                }
                break;
            }
            case ERECHARGE:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterRechargeFailed) {
                    self.afterRechargeFailed(message);
                }
                break;
            }
            case EWITHDRAWALS:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterWithdrawalsFailed) {
                    self.afterWithdrawalsFailed(message);
                }
                break;
            }
            case EQUERYBALANCE:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterQueryBalanceFailed) {
                    self.afterQueryBalanceFailed(message);
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
//    DLog(@"%ld", (long)[responseError code]);
    switch (self.type) {
        case EQUERYFLOW:
        {
            if (self.afterQqueryFlowFailed) {
                self.afterQqueryFlowFailed([responseError localizedDescription]);
            }
            break;
        }
        case EQRERYALLOWEXCHANGEIN:
        {
            if (self.afterQueryAllowExchangeInFailed) {
                self.afterQueryAllowExchangeInFailed([responseError localizedDescription]);
            }
            break;
        }
        case EQUERYBALANCEHISTORY:
        {
            if (self.afterQueryBalanceHistoryFailed) {
                self.afterQueryBalanceHistoryFailed([responseError localizedDescription]);
            }
            break;
        }
        case ERECHARGE:
        {
            if (self.afterRechargeFailed) {
                self.afterRechargeFailed([responseError localizedDescription]);
            }
            break;
        }
        case EWITHDRAWALS:
        {
            if (self.afterWithdrawalsFailed) {
                self.afterWithdrawalsFailed([responseError localizedDescription]);
            }
            break;
        }
        case EQUERYBALANCE:
        {
            if (self.afterQueryBalanceFailed) {
                self.afterQueryBalanceFailed([responseError localizedDescription]);
            }
            break;
        }
        default:
            break;
    }
}




@end