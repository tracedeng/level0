//
//  MerchantSelectCell.m
//  Calculus
//
//  Created by ben on 15/12/24.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MerchantSelectCell.h"
#import "ClickableImageView.h"
#import "UIImageView+WebCache.h"
#import "Constance.h"


@interface MerchantSelectCell()
@property (weak, nonatomic) IBOutlet UILabel *merchantLBL;
//@property (weak, nonatomic) IBOutlet UILabel *rateLBL;
//@property (weak, nonatomic) IBOutlet UILabel *amountLBL;
@property (weak, nonatomic) IBOutlet ClickableImageView *checkImageView;
@property (weak, nonatomic) IBOutlet ClickableImageView *logoImageView;

@property (nonatomic, assign) BOOL checked;     // toggle时上一个状态
@property (nonatomic, retain) UIImage *checkedImage;
@property (nonatomic, retain) UIImage *uncheckedImage;

@end

@implementation MerchantSelectCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMerchantInfo:(NSDictionary *)merchantInfo {
    if (merchantInfo) {
        self.checkedImage = [UIImage imageNamed:@"icon-radio-checked"];
        self.uncheckedImage = [UIImage imageNamed:@"icon-radio"];

        _merchantInfo = merchantInfo;
        self.merchantLBL.text = [merchantInfo objectForKey:@"n"];
        
        NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [merchantInfo objectForKey:@"logo"]];
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"logo-merchant-default"]];
        self.logoImageView.clipsToBounds = YES;
//        self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.height / 2.0;
        self.logoImageView.layer.cornerRadius = 4.0f;
        
        self.checkImageView.afterClickImageView = ^(id sender) {
            if (self.afterToggleAction) {
                self.afterToggleAction(self.checked, [self.tableView indexPathForCell:self]);
            }
        };
    }
}

- (void)toggle {
    self.checkImageView.image = self.checked ? self.uncheckedImage : self.checkedImage;
    self.checked = !self.checked;
}

@end
