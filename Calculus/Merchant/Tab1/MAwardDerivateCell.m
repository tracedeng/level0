//
//  MAwardDerivateCell.m
//  Calculus
//
//  Created by tracedeng on 15/12/22.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MAwardDerivateCell.h"
@interface MAwardDerivateCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@end

@implementation MAwardDerivateCell

- (void)setRow:(NSInteger)row {
    switch (row) {
        case 0:
            self.name.text = @"积分申请";
            self.icon.image = [UIImage imageNamed:@"icon-apply"];
            break;
        case 1:
            self.name.text = @"客户优惠券";
            self.icon.image = [UIImage imageNamed:@"icon-coupon"];
            break;
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
            self.name.text = @"请期待";
            self.icon.image = [UIImage imageNamed:@"icon-alipay"];
            break;
            
        default:
            break;
    }
}

@end
