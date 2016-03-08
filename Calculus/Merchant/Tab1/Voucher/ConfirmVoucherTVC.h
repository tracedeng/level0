//
//  ConfirmVoucherTVC.h
//  Calculus
//
//  Created by tracedeng on 16/3/5.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmVoucherTVC : UITableViewController
@property (nonatomic, retain) NSString *merchant;   // 商家ID
@property (nonatomic, retain) NSString *voucher;    // 优惠券ID
@property (nonatomic, retain) NSString *activity;   // 活动ID
@property (nonatomic, retain) NSString *number;     // 优惠券拥有者号码

@end
