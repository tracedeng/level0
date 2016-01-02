//
//  ActionFlow.h
//  Calculus
//
//  Created by ben on 15/12/30.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetCommunication.h"

@interface ActionFlow : NSObject<NetCommunicationDelegate>
typedef NS_ENUM(NSInteger, EMFLOWOPTYE) {
    
    EQUERYFLOW,   //查询剩余可发行积分
};

- (void)doQueryFlow:(NSString *)merchant;
//- (void)doQueryBusinessParameters:(NSString *)merchant;
//- (void)doModifyConsumptionRatio:(NSString *)ratio merchant:(NSString *)merchant;
//
//
@property (nonatomic, copy) void (^afterQqueryFlow)(NSDictionary *flow);
//@property (nonatomic, copy) void (^afterModifyConsumptionRatio)(NSDictionary *result);
//@property (nonatomic, copy) void (^afterQueryBusinessParameters)(NSDictionary *business);


@end





