//
//  ActionVoucher.m
//  Calculus
//
//  Created by tracedeng on 16/1/8.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "ActionVoucher.h"
#import "SKeyManager.h"
#import "Constance.h"


@interface ActionVoucher ()
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) EVOUCHEROPTYPE type;     //用户资料操作类型

@property (nonatomic, retain) NSDictionary *state;  //登录态 {"accout": @"18688982240", "skey": @"_Rjdifjwe7234876sdfD"}
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *skey;
@end


@implementation ActionVoucher
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


- (void)doQueryVoucher {
    self.type = EQUERYVOUCHER;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"retrieve", @"type", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doMerchantQueryVoucher:(NSString *)merchant {
    self.type = EMERCHANTQUERYVOUCHER;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"confirm", @"type", merchant, @"merchant", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doConfirmVoucher:(NSString *)voucher merchant_identity:(NSString *)merchant consumer_number:(NSString *)consumer{
    self.type = ECONFIRMVOUCHER;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"confirm", @"type", voucher, @"voucher", merchant, @"merchant", consumer, @"consumer", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}


#pragma mark -NetCommunication Delegate

//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    NSInteger errorCode = [[responseObject objectForKey:@"c"] integerValue];
    if (1 == errorCode) {
        switch (self.type) {
            case EQUERYVOUCHER:
            {
                NSArray *voucherList = [responseObject objectForKey:@"r"];
                if (self.afterQueryVoucher) {
                    self.afterQueryVoucher(voucherList);
                }
                break;
            }
            case EMERCHANTQUERYVOUCHER:
            {
                NSArray *voucherList = [responseObject objectForKey:@"r"];
//                DLog(@"disccout id %@", disccout);
                if (self.afterMerchantQueryVoucher) {
                    self.afterMerchantQueryVoucher(voucherList);
                }
                break;
            }
            case ECONFIRMVOUCHER:
            {
//                NSString *result = [responseObject objectForKey:@"r"];
                if (self.afterConfirmVoucher) {
                    self.afterConfirmVoucher();
                }
                break;
            }
            default:
                break;
        }
    }else{
        switch (self.type) {
            case EQUERYVOUCHER:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterQueryVoucherFailed) {
                    self.afterQueryVoucherFailed(message);
                }
                break;
            }
            case EMERCHANTQUERYVOUCHER:
            {
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterMerchantQueryVoucherFailed) {
                    self.afterMerchantQueryVoucherFailed(message);
                }
                break;
            }
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
    DLog(@"%@", [responseError domain]);
    DLog(@"%ld", (long)[responseError code]);
    DLog(@"%@", [responseError localizedDescription]);
    switch (self.type) {
        case EQUERYVOUCHER:
        {
            //七牛token失败操作
            if (self.afterQueryVoucherFailed) {
                self.afterQueryVoucherFailed([responseError localizedDescription]);
            }
            break;
        }
        case EMERCHANTQUERYVOUCHER:
        {
            //修改头像失败操作
            if (self.afterMerchantQueryVoucherFailed) {
                self.afterMerchantQueryVoucherFailed([responseError localizedDescription]);
            }
            break;
        }
        case ECONFIRMVOUCHER:
        {
            //修改昵称失败操作
            if (self.afterConfirmVoucherFailed) {
                self.afterConfirmVoucherFailed([responseError localizedDescription]);
            }
            
            break;
        }
                   
        default:
            break;
    }
}

@end
