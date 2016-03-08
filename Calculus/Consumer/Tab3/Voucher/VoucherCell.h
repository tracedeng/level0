//
//  VoucherCell.h
//  Calculus
//
//  Created by tracedeng on 16/1/8.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoucherCell : UITableViewCell
@property (nonatomic, retain) NSDictionary *voucherInfo;
@property (weak, nonatomic) IBOutlet UIImageView *merchantLogo;

@end
