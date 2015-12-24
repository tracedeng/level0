//
//  CreditExchangeCell.m
//  Calculus
//
//  Created by ben on 15/12/24.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "CreditExchangeCell.h"
@interface CreditExchangeCell ()
@property (weak, nonatomic) IBOutlet UILabel *creditDueLBL;
@property (weak, nonatomic) IBOutlet UILabel *creditAmountLBL;
@property (weak, nonatomic) IBOutlet UIImageView *raionIMG;

@property (nonatomic, assign) BOOL rowselected;


@end


@implementation CreditExchangeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAwardInfo:(NSDictionary *)awardInfo {
    self.creditDueLBL.text = [awardInfo objectForKey:@"et"];
    self.creditAmountLBL.text = [NSString stringWithFormat:@"%d",[[awardInfo objectForKey:@"qu"] integerValue]];

//    self.merchant_name_label.text = [awardInfo objectForKey:@"t"];
//    self.total_award_label.text = [NSString stringWithFormat:@"%ld",[[awardInfo objectForKey:@"a"] integerValue]];
//    //    self.merchant_logo_image.image = [UIImage imageNamed:@"icon-mcd"];
//    //    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//    //圆角
//    self.merchant_logo_image.clipsToBounds = YES;
//    self.merchant_logo_image.layer.cornerRadius = self.merchant_logo_image.frame.size.height / 2.0;
//    
//    NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [awardInfo objectForKey:@"l"]];
//    [self.merchant_logo_image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
}
-(void) setRaionIMG:(UIImageView *)raionIMG {
    self.raionIMG.image = [UIImage imageNamed:@"icon-radio-selected"];

}

@end
