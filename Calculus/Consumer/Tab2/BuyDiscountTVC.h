//
//  BuyDiscountTVC.h
//  Calculus
//
//  Created by tracedeng on 16/1/4.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyDiscountTVC : UITableViewController
@property (nonatomic, retain) NSString *merchant;   //商家ID
@property (nonatomic, assign) NSInteger needQuantity;   //活动需要的积分
@end
