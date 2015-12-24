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
typedef NS_ENUM(NSInteger, ECREDITOPTYPE) {
    ECONSUMERQUERYMERCHANTLIST,             //查询商户列表
    
};
- (void)doConsumerQueryOtherMerchantList:(NSString *)merchant;

@property (nonatomic, copy) void (^afterConsumerQueryOtherMerchantList)(NSArray *merchantList);
@property (nonatomic, copy) void (^afterConsumerQueryOtherMerchantListFailed)(NSString *message);

@end

