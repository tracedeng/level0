//
//  VoucherCell.m
//  Calculus
//
//  Created by tracedeng on 16/1/8.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "VoucherCell.h"
#import "Constance.h"
#import "UIImageView+WebCache.h"

@interface VoucherCell ()
@property (weak, nonatomic) IBOutlet UILabel *activiyTitle
;
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityMerchant;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
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
//    self.backgroundImageView.clipsToBounds = YES;
//    self.backgroundImageView.layer.cornerRadius = 4.0f;
    if (voucherInfo) {
        _voucherInfo = voucherInfo;
        self.activiyTitle.text = [voucherInfo objectForKey:@"ti"];
        self.activityMerchant.text = [voucherInfo objectForKey:@"na"];
        self.expireLabel.text = [[voucherInfo objectForKey:@"et"] substringToIndex:10];

        self.merchantLogo.layer.cornerRadius = 4.0f;
        NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/200/h/200", QINIUURL, [voucherInfo objectForKey:@"logo"]];
        [self.merchantLogo sd_setImageWithURL:[NSURL URLWithString:path]];
    }
}
@end
