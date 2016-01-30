//
//  CreditExchangeInCell.h
//  Calculus
//
//  Created by ben on 15/12/24.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditExchangeInCell : UITableViewCell
@property (nonatomic, retain) NSDictionary *awardInfo;
@property (nonatomic, retain) NSString *logoPath;
@property (nonatomic, retain) UITableView *tableView;

- (void)toggle;

@property (nonatomic, copy) void (^afterToggleAction)(BOOL checked, NSIndexPath *indexPath);
@end
