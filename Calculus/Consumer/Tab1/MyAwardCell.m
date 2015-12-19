//
//  MyAwardCell.m
//  Calculus
//
//  Created by tracedeng on 15/12/10.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MyAwardCell.h"
#import "UIImageView+WebCache.h"
#import "Constance.h"


@interface MyAwardCell ()
@property (weak, nonatomic) IBOutlet UIImageView *merchant_logo_image;
@property (weak, nonatomic) IBOutlet UILabel *merchant_name_label;
@property (weak, nonatomic) IBOutlet UILabel *total_award_label;

@end

@implementation MyAwardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAwardInfo:(NSDictionary *)awardInfo {
    self.merchant_name_label.text = [awardInfo objectForKey:@"t"];
    self.total_award_label.text = [NSString stringWithFormat:@"%ld",[[awardInfo objectForKey:@"a"] integerValue]];
//    self.merchant_logo_image.image = [UIImage imageNamed:@"icon-mcd"];
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //圆角
    self.merchant_logo_image.clipsToBounds = YES;
    self.merchant_logo_image.layer.cornerRadius = self.merchant_logo_image.frame.size.height / 2.0;

    NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [awardInfo objectForKey:@"l"]];
    [self.merchant_logo_image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
}
@end
