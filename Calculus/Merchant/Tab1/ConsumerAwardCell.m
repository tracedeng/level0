//
//  ConsumerAwardCell.m
//  Calculus
//
//  Created by tracedeng on 15/12/23.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ConsumerAwardCell.h"

@implementation ConsumerAwardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAwardInfo:(NSDictionary *)awardInfo {
//    self.nicknameLabel.text = [awardInfo objectForKey:@"ni"];
//    self.applyDateLabel.text = [awardInfo objectForKey:@"ct"];
//    self.moneyLabel.text = [[awardInfo objectForKey:@"sums"] stringValue];
//    self.identity = [awardInfo objectForKey:@"id"];
//    
//    //    圆角
//    self.avatarImageView.clipsToBounds = YES;
//    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2.0;
//    
//    NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/200/h/200", QINIUURL, [awardInfo objectForKey:@"ava"]];
//    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"avatar-placeholder"]];
    
}

@end
