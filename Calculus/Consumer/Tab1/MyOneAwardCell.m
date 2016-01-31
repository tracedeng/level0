//
//  MyOneAwardCell.m
//  Calculus
//
//  Created by tracedeng on 15/12/20.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MyOneAwardCell.h"
#import "UIColor+Extension.h"


@interface MyOneAwardCell ()
//@property (weak, nonatomic) IBOutlet UILabel *merchant_name_label;
//@property (weak, nonatomic) IBOutlet UILabel *total_award_label;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *creditSymbleIMG;
@property (weak, nonatomic) IBOutlet UIImageView *creditBackgroundIMG;
@property (weak, nonatomic) IBOutlet UILabel *expireTitleLabel;


@end

@implementation MyOneAwardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAwardInfo:(NSDictionary *)awardInfo {
//    DLog(@"%@", awardInfo);
    BOOL exchanged = [[awardInfo objectForKey:@"e"] boolValue];
    if (exchanged) {
//        self.titleLabel.text = @"积分券";
        self.quantityLabel.text = [[awardInfo objectForKey:@"am"] stringValue];
        self.expireLabel.text = [[awardInfo objectForKey:@"et"] substringToIndex:10];
        self.quantityLabel.textColor = [UIColor colorWithHex:0x14bc9a];
        self.creditBackgroundIMG.image = [UIImage imageNamed:@"bg-credit-coupon"];
        self.creditSymbleIMG.image = [UIImage imageNamed:@"icon-credit-green"];
        self.expireLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
        self.expireTitleLabel.textColor = [UIColor colorWithHex:0xFFFFFF];

        
    }else{
//        self.titleLabel.text = @"待兑换券";
        self.quantityLabel.text = [[awardInfo objectForKey:@"s"] stringValue];
        self.expireLabel.text = [[awardInfo objectForKey:@"et"] substringToIndex:10];
    }
//    self.merchant_name_label.text = [awardInfo objectForKey:@"t"];
//    self.total_award_label.text = [NSString stringWithFormat:@"%ld",[[awardInfo objectForKey:@"a"] integerValue]];
    //    self.merchant_logo_image.image = [UIImage imageNamed:@"icon-mcd"];
    //    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //圆角
//    self.merchant_logo_image.clipsToBounds = YES;
//    self.merchant_logo_image.layer.cornerRadius = self.merchant_logo_image.frame.size.height / 2.0;
//    
//    NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [awardInfo objectForKey:@"l"]];
//    [self.merchant_logo_image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
}
@end
