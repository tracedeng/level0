//
//  ActionBusiness.m
//  Calculus
//
//  Created by ben on 15/12/29.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionBusiness.h"
#import "Constance.h"
#import "SKeyManager.h"

@interface ActionBusiness()
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) EMBUSINESSOPTYE type;     //商家资料操作类型

@property (nonatomic, retain) NSDictionary *state;  //登录态 {"accout": @"18688982240", "skey": @"_Rjdifjwe7234876sdfD"}
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *skey;
@end

@implementation ActionBusiness
- (id)init {
    self = [super init];
    if (self) {
        self.state = [SKeyManager getSkey];
        self.account = [self.state objectForKey:@"account"];
        self.skey = [self.state objectForKey:@"skey"];
        self.net = [[NetCommunication alloc] initWithHttpUrl:BUSINESSURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}

- (void)doQueryBusinessParameters:(NSString *)merchant{
    self.type = EQUERYBUSINESSPARAMETERS;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"retrieve_parameters", @"type", self.account, @"numbers",merchant, @"merchant", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doModifyConsumptionRatio:(NSString *)ratio merchant:(NSString *)merchant{
    self.type = EUPDATECONSUMPTIONRATIO;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"update_consumption_ratio", @"type", ratio, @"ratio", merchant, @"merchant", self.account, @"numbers",self.skey, @"session_key",  nil];
    
    [self.net requestHttpWithData:postData];
}

#pragma mark -NetCommunication Delegate
//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    if (1 == [[responseObject objectForKey:@"c"] integerValue]) {
        switch (self.type) {
            case EQUERYBUSINESSPARAMETERS:
            {
                NSDictionary *result = [responseObject objectForKey:@"r"];
                //                NSDictionary *material = [result objectAtIndex:0];
                if (self.afterQueryBusinessParameters) {
                    NSDictionary *business = [result count] > 0 ? [NSDictionary dictionaryWithDictionary: result] : nil;
                    self.afterQueryBusinessParameters(business);
                }
                break;
            }

            case EUPDATECONSUMPTIONRATIO:
            {
                NSDictionary *result = [responseObject objectForKey:@"r"];
                if (self.afterModifyConsumptionRatio) {
                    self.afterModifyConsumptionRatio(result);
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
