//
//  ActionMerchant.h
//  Calculus
//
//  Created by ben on 15/12/24.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetCommunication.h"

@interface ActionMerchant : NSObject<NetCommunicationDelegate>
//操作类型
typedef NS_ENUM(NSInteger, EMERCHANTOPTYPE) {
    ECONSUMERQUERYMERCHANTLIST,             //查询商户列表
    EQUERYEXCHANGEINMERCHNAT,               //查询允许积分转入商家列表
    EQUERYALLOWEXCHANGEIN,
    EMERCHANTOPTYPEMAX
};
- (void)doConsumerQueryOtherMerchantList:(NSString *)merchant;
- (void)doQueryExchangInMerchantWithout:(NSString *)merchant;

@property (nonatomic, copy) void (^afterConsumerQueryOtherMerchantList)(NSArray *merchantList);
@property (nonatomic, copy) void (^afterConsumerQueryOtherMerchantListFailed)(NSString *message);
@property (nonatomic, copy) void (^afterConsumerQueryOtherMerchantListFailedNetConnect)(NSString *message);


@end

