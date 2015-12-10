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

@end
