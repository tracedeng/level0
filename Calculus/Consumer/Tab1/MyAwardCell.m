//
//  MyAwardCell.m
//  Calculus
//
//  Created by tracedeng on 15/12/10.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MyAwardCell.h"

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
    self.total_award_label.text = [NSString stringWithFormat:@"%d",[[awardInfo objectForKey:@"a"] integerValue]];
    self.merchant_logo_image.image = [UIImage imageNamed:@"icon-mcd"];
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
@end
