//
//  VoucherCell.m
//  Calculus
//
//  Created by tracedeng on 16/1/8.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "VoucherCell.h"

@interface VoucherCell ()
@property (weak, nonatomic) IBOutlet UILabel *activiyTitle
;
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityMerchant;

@end

@implementation VoucherCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVoucherInfo:(NSDictionary *)voucherInfo {
    if (voucherInfo) {
        _voucherInfo = voucherInfo;
        self.activiyTitle.text = [voucherInfo objectForKey:@"ti"];
        self.activityMerchant.text = [voucherInfo objectForKey:@"na"];
        self.expireLabel.text = [[voucherInfo objectForKey:@"et"] substringToIndex:10];
    }
}
@end
