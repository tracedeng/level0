//
//  ActionDiscount.m
//  Calculus
//
//  Created by tracedeng on 16/1/3.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "ActionDiscount.h"
#import "SKeyManager.h"
#import "Constance.h"

@interface ActionDiscount ()
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) EDISCOUNTOPTYPE type;     //用户资料操作类型

@property (nonatomic, retain) NSDictionary *state;  //登录态 {"accout": @"18688982240", "skey": @"_Rjdifjwe7234876sdfD"}
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *skey;
@end

@implementation ActionDiscount

- (id)init {
    self = [super init];
    if (self) {
        self.state = [SKeyManager getSkey];
        self.account = [self.state objectForKey:@"account"];
        self.skey = [self.state objectForKey:@"skey"];
        self.net = [[NetCommunication alloc] initWithHttpUrl:DISCOUNTURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}


/**
 *  客户查询优惠活动
 *
 *  @param nickname <#nickname description#>
 *  type/numbers/session_key
 */
- (void)doConsumerQueryDiscount {
    self.type = ECONSUMERQUERYDISCOUNT;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"consumer_retrieve", @"type", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doConsumerBuyDiscount:(NSString *)discount ofMerchant:(NSString *)merchant withCredit:(NSArray *)credits {
    self.type = ECONSUMERBUYDISCOUNT;
    
    // 积分列表转换成json格式
    NSString *creditJson = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:credits options:0 error:nil] encoding:NSUTF8StringEncoding];
//    NSString *creditJson = @"{\"identity\": \"ad\", \"quantity\": 2}";
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"buy", @"type", discount, @"discount", merchant, @"merchant", creditJson, @"spend", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
    
}
//
//- (void)doConsumerCreateConsumption:(NSString *)merchant money:(NSInteger)money {
//    self.type = ECONSUMERCREATECONSUMPTION;
//    
//    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"consumption", @"type", [NSString stringWithFormat:@"%ld", money], @"sums", merchant, @"merchant", self.account, @"numbers", self.skey, @"session_key", nil];
//    
//    [self.net requestHttpWithData:postData];
//}
//- (void)doConsumerQueryOtherdisccoutList:(NSString *)merchant {
//    self.type = ECONSUMERQUERYOTHERdisccoutLIST;
//    
//    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"disccout_list_detail", @"type", self.account, @"numbers", self.skey, @"session_key", nil];
//    
//    [self.net requestHttpWithData:postData];
//}
//- (void)doConsumerQueryOtherMerchantList:(NSString *)merchant{
//    self.type = ECONSUMERQUERYMERCHANTLIST;
//    
//    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"verified_merchant", @"type", self.account, @"numbers", self.skey, @"session_key", nil];
//    
//    [self.net requestHttpWithData:postData];
//}
//
//- (void)dodisccoutInterchange:(NSString *)disccout from_merchant:(NSString *)from quantity:(NSInteger)quantity to_merchant:(NSString *)to exec_exchange:(BOOL)exec  {
//    self.type = EdisccoutINTERCHANGE;
//    
//    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"interchange", @"type", disccout, @"disccout", from, @"from", to, @"to", [NSString stringWithFormat:@"%ld", (long)quantity], @"quantity", [NSString stringWithFormat:@"%d", exec], @"exec_interchange", self.account, @"numbers", self.skey, @"session_key", nil];
//    
//    [self.net requestHttpWithData:postData];
//}

#pragma mark -NetCommunication Delegate

//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    NSInteger errorCode = [[responseObject objectForKey:@"c"] integerValue];
    if (1 == errorCode) {
        switch (self.type) {
            case ECONSUMERQUERYDISCOUNT:
            {
                NSArray *disccoutList = [responseObject objectForKey:@"r"];
                if (self.afterConsumerQueryDiscount) {
                    self.afterConsumerQueryDiscount(disccoutList);
                }
                break;
            }
            case ECONSUMERBUYDISCOUNT:
            {
                NSString *discount = [responseObject objectForKey:@"r"];
                if (self.afterConsumerBuyDiscount) {
                    self.afterConsumerBuyDiscount(discount);
                }
                break;
            }
//            case ECONSUMERCREATECONSUMPTION:
//            {
//                NSString *disccout = [responseObject objectForKey:@"r"];
//                DLog(@"disccout id %@", disccout);
//                if (self.afterConsumerCreateConsumption) {
//                    self.afterConsumerCreateConsumption();
//                }
//                break;
//            }
//            case ECONSUMERQUERYOTHERdisccoutLIST:
//            {
//                NSArray *disccoutList = [responseObject objectForKey:@"r"];
//                DLog(@"disccout id %@", disccoutList);
//                if (self.afterConsumerQueryOtherdisccoutList) {
//                    self.afterConsumerQueryOtherdisccoutList(disccoutList);
//                }
//                break;
//            }
//            case ECONSUMERQUERYMERCHANTLIST:
//            {
//                NSArray *merchantList = [responseObject objectForKey:@"r"];
//                DLog(@"disccout id %@", merchantList);
//                if (self.afterConsumerQueryOtherMerchantList) {
//                    self.afterConsumerQueryOtherMerchantList(merchantList);
//                }
//                break;
//            }
//            case EdisccoutINTERCHANGE:
//            {
//                NSInteger quantity = [[responseObject valueForKeyPath:@"r.quantity"] integerValue];
//                NSInteger fee = [[responseObject valueForKeyPath:@"r.fee"] integerValue];
//                if (self.afterdisccoutInterchange) {
//                    self.afterdisccoutInterchange(quantity, fee);
//                }
//                break;
//            }
            default:
                break;
        }
    }else{
        switch (self.type) {
            case ECONSUMERQUERYDISCOUNT:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterConsumerQueryDiscountFailed) {
                    self.afterConsumerQueryDiscountFailed(message);
                }
                break;
            }
            case ECONSUMERBUYDISCOUNT:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterConsumerBuyDiscountFailed) {
                    self.afterConsumerBuyDiscountFailed(message);
                }
                break;
            }
//            case ECONSUMERQUERYOTHERdisccoutLIST:
//            {
//                NSString *message = [responseObject objectForKey:@"m"];
//                if (self.afterConsumerQueryOtherdisccoutListFailed) {
//                    self.afterConsumerQueryOtherdisccoutListFailed(message);
//                }
//                break;
//            }
//            case ECONSUMERQUERYMERCHANTLIST:
//            {
//                NSString *message = [responseObject objectForKey:@"m"];
//                if (self.afterConsumerQueryOtherMerchantListFailed) {
//                    self.afterConsumerQueryOtherMerchantListFailed(message);
//                }
//                break;
//            }
//            case EdisccoutINTERCHANGE:
//            {
//                NSString *message = [responseObject objectForKey:@"m"];
//                if (self.afterdisccoutInterchangeFailed) {
//                    self.afterdisccoutInterchangeFailed(message);
//                }
//                break;
//            }
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
        case ECONSUMERQUERYDISCOUNT:
        {
            if (self.afterConsumerQueryDiscountFailed) {
                self.afterConsumerQueryDiscountFailed([responseError localizedDescription]);
            }
            break;
        }
        case ECONSUMERBUYDISCOUNT:
        {
            if (self.afterConsumerBuyDiscountFailed) {
                self.afterConsumerBuyDiscountFailed([responseError localizedDescription]);
            }
            break;
        }
        default:
            break;
    }
}

@end


