//
//  ActionMVoucher.h
//  Calculus
//
//  Created by tracedeng on 16/1/8.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetCommunication.h"

@interface ActionMVoucher : NSObject <NetCommunicationDelegate>

typedef NS_ENUM(NSInteger, EMVOUCHEROPTYPE) {
//    EQUERYVOUCHER = 1,            //获取优惠券
//    EMERCHANTQUERYVOUCHER,        //商家获取优惠券
    ECONFIRMVOUCHER = 1,              //管理员确认优惠券
    EVOUCHEROPTYPEMAX,
};

//- (void)doQueryVoucher;
//- (void)doMerchantQueryVoucher:(NSString *)merchant;
- (void)doConfirmVoucher:(NSString *)voucher merchant_identity:(NSString *)merchant activity_identity:(NSString *)activity consumer_number:(NSString *)consumer exec_confirm:(BOOL)exec;
//

////操作成功后回调Blcok
//@property (nonatomic, copy) void (^afterQueryVoucher)(NSArray *voucher);
//@property (nonatomic, copy) void (^afterMerchantQueryVoucher)(NSArray *voucher);
@property (nonatomic, copy) void (^afterConfirmVoucher)(NSString *state); 


//@property (nonatomic, copy) void (^afterQueryVoucherFailed)(NSString *messge);
//@property (nonatomic, copy) void (^afterMerchantQueryVoucherFailed)(NSString *message);
@property (nonatomic, copy) void (^afterConfirmVoucherFailed)(NSString *message);

@property (nonatomic, copy) void (^afterConfirmVoucherFailedNetConnect)(NSString *message);

@end
