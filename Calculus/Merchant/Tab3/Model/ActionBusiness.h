//
//  ActionBusiness.h
//  Calculus
//
//  Created by ben on 15/12/29.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetCommunication.h"

@interface ActionBusiness : NSObject<NetCommunicationDelegate>
typedef NS_ENUM(NSInteger, EMBUSINESSOPTYE) {

    EQUERYBUSINESSPARAMETERS,   //查询商户营业参数
    EUPDATECONSUMPTIONRATIO,    //更新商户兑换汇率
};

- (void)doQueryBusinessParameters:(NSString *)merchant;
- (void)doModifyConsumptionRatio:(NSString *)ratio merchant:(NSString *)merchant;


@property (nonatomic, copy) void (^afterModifyConsumptionRatio)(NSDictionary *result);
@property (nonatomic, copy) void (^afterQueryBusinessParameters)(NSDictionary *business);

@property (nonatomic, copy) void (^afterModifyConsumptionRatioFailed)(NSString *message);
@property (nonatomic, copy) void (^afterQueryBusinessParametersFailed)(NSString *message);

@end
