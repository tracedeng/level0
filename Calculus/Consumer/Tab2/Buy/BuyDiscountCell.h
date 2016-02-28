//
//  BuyDiscountCell.h
//  Calculus
//
//  Created by tracedeng on 16/1/4.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyDiscountCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, retain) NSDictionary *awardInfo;
@property (nonatomic, retain) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *creditTextField;  // 打算花费多少积分

//- (void)toggle;
//- (NSInteger)updateQuantity:(NSInteger)quantity;

@property (nonatomic, copy) void (^afterToggleAction)(BOOL checked, NSIndexPath *indexPath);  //cell toggle
@property (nonatomic, copy) NSInteger (^currentNeedQuantity)(NSInteger quantity);    //当前还需要多少积分，quantity此次操作导致积分变更量
@end
