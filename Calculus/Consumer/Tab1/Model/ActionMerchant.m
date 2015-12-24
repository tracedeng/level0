//
//  ActionMerchant.m
//  Calculus
//
//  Created by ben on 15/12/24.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionMerchant.h"
#import "SKeyManager.h"
#import "Constance.h"

@interface ActionMerchant ()
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) ECREDITOPTYPE type;     //用户资料操作类型

@property (nonatomic, retain) NSDictionary *state;  //登录态 {"accout": @"18688982240", "skey": @"_Rjdifjwe7234876sdfD"}
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *skey;
@end

@implementation ActionMerchant

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