//
//  ActionMVoucher.m
//  Calculus
//
//  Created by tracedeng on 16/1/8.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "ActionMVoucher.h"
#import "SKeyManager.h"
#import "Constance.h"


@interface ActionMVoucher ()
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) EMVOUCHEROPTYPE type;     //用户资料操作类型

@property (nonatomic, retain) NSDictionary *state;  //登录态 {"accout": @"18688982240", "skey": @"_Rjdifjwe7234876sdfD"}
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *skey;
@end


@implementation ActionMVoucher
- (id)init {
    self = [super init];
    if (self) {
        self.state = [SKeyManager getSkey];
        self.account = [self.state objectForKey:@"account"];
        self.skey = [self.state objectForKey:@"skey"];
        self.net = [[NetCommunication alloc] initWithHttpUrl:VOUCHERURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}

- (void)doConfirmVoucher:(NSString *)voucher merchant_identity:(NSString *)merchant activity_identity:(NSString *)activity consumer_number:(NSString *)consumer exec_confirm:(BOOL)exec {
    self.type = ECONFIRMVOUCHER;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"confirm", @"type", voucher, @"voucher", merchant, @"merchant", activity, @"activity", consumer, @"consumer", [NSString stringWithFormat:@"%d", exec], @"exec_confirm", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}


#pragma mark -NetCommunication Delegate

//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    NSInteger errorCode = [[responseObject objectForKey:@"c"] integerValue];
    if (1 == errorCode) {
        switch (self.type) {
            case ECONFIRMVOUCHER:
            {
                // "invalid"-无效，"used"-已经使用，"valid"-可使用，"yes"-使用成功
                NSString *state = [responseObject objectForKey:@"r"];
                if (self.afterConfirmVoucher) {
                    self.afterConfirmVoucher(state);
                }
                break;
            }
            default:
                break;
        }
    }else{
        switch (self.type) {
            case ECONFIRMVOUCHER:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterConfirmVoucherFailed) {
                    self.afterConfirmVoucherFailed(message);
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
//    DLog(@"%ld", (long)[responseError code]);
//    DLog(@"%@", [responseError localizedDescription]);
    switch (self.type) {
        case ECONFIRMVOUCHER:
        {
            //修改昵称失败操作
            if (self.afterConfirmVoucherFailedNetConnect) {
                self.afterConfirmVoucherFailedNetConnect([responseError localizedDescription]);
            }
            
            break;
        }
                   
        default:
            break;
    }
}

@end
