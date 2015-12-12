//
//  DisccountCell.m
//  Calculus
//
//  Created by tracedeng on 15/12/12.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "DiscountCell.h"

@interface DiscountCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *activity;
@end

@implementation DiscountCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDiscountInfo:(NSDictionary *)discountInfo {
    self.logo.image = [UIImage imageNamed:@"icon-me"];
    self.name.text = @"麦当劳";
    self.activity.text = @"活活活活活活活活活动动动动动动动动动";
}
@end
