//
//  MAwardApplyCell.h
//  Calculus
//
//  Created by tracedeng on 15/12/22.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAwardApplyCell : UITableViewCell
@property (nonatomic, retain) NSDictionary *awardInfo;
@property (nonatomic, retain) UITableView *tableView ;

@property (nonatomic, copy) void (^afterConfirmAction)(BOOL result, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^afterRefuseAction)(BOOL result, NSIndexPath *indexPath);

@end
