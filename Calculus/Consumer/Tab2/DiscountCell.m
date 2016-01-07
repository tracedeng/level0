//
//  DisccountCell.m
//  Calculus
//
//  Created by tracedeng on 15/12/12.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "DiscountCell.h"

@interface DiscountCell ()
@property (weak, nonatomic) IBOutlet UIImageView *poster;   // 活动海报
@property (weak, nonatomic) IBOutlet UILabel *title;    // 活动标题
@property (weak, nonatomic) IBOutlet UILabel *name; // 商家名称
@property (weak, nonatomic) IBOutlet UILabel *expireTime;   // 活动过期时间
@property (weak, nonatomic) IBOutlet UILabel *credit;       // 活动消耗积分
@property (weak, nonatomic) IBOutlet UILabel *introduce;    // 活动介绍
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
    if (discountInfo) {
        _discountInfo = discountInfo;
        self.poster.image = [UIImage imageNamed:@"icon-me"];
        self.title.text = [discountInfo objectForKey:@"t"];
        self.name.text = [discountInfo objectForKey:@"na"];
        self.expireTime.text = [discountInfo objectForKey:@"et"];
        self.credit.text = [[discountInfo objectForKey:@"cr"] stringValue];
        self.introduce.text = [discountInfo objectForKey:@"in"];
    }
    
}
@end
