//
//  WithdrawalsTVC.h
//  Calculus
//
//  Created by tracedeng on 16/3/3.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawalsTVC : UITableViewController
@property (nonatomic, assign) CGFloat maxWithdrawalsMoney;    // 最大可提现金额
@property (nonatomic, retain) NSString *merchant;
@end
