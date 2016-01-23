//
//  AwardDerivateCell.m
//  Calculus
//
//  Created by tracedeng on 15/12/12.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "AwardDerivateCell.h"
@interface AwardDerivateCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@end

@implementation AwardDerivateCell

- (void)setRow:(NSInteger)row {
    switch (row) {
        case 0:
            self.name.text = @"扫一扫";
            self.icon.image = [UIImage imageNamed:@"icon-scan"];
            break;
        case 1:
            self.name.text = @"积分汇率";
            self.icon.image = [UIImage imageNamed:@"icon-change"];
            break;
        case 2:
            self.name.text = @"积分转入";
            self.icon.image = [UIImage imageNamed:@"icon-import"];
            break;
        case 3:
            self.name.text = @"积分助手";
            self.icon.image = [UIImage imageNamed:@"icon-assist"];
            break;
        case 4:
            self.name.text = @"一积分";
            self.icon.image = [UIImage imageNamed:@"icon-alipay"];
            break;
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
