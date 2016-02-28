//
//  DisccountCell.m
//  Calculus
//
//  Created by tracedeng on 15/12/12.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "DiscountCell.h"
#import "UIImageView+WebCache.h"
#import "Constance.h"

@interface DiscountCell ()
@property (weak, nonatomic) IBOutlet UIImageView *poster;   // 活动海报
@property (weak, nonatomic) IBOutlet UILabel *title;    // 活动标题
@property (weak, nonatomic) IBOutlet UILabel *name; // 商家名称
@property (weak, nonatomic) IBOutlet UILabel *expireTime;   // 活动过期时间
@property (weak, nonatomic) IBOutlet UILabel *credit;       // 活动消耗积分
@property (weak, nonatomic) IBOutlet UILabel *introduce;    // 活动介绍

@property (weak, nonatomic) IBOutlet UIView *discountBackground;   // 背景

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
        
        self.discountBackground.clipsToBounds = YES;
        self.discountBackground.layer.cornerRadius = 4.0f;

        self.poster.clipsToBounds = YES;
        self.poster.layer.cornerRadius = 4.0f;
        
        NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [discountInfo objectForKey:@"po"]];
        [self.poster sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
        

        self.title.text = [discountInfo objectForKey:@"t"];
//        self.name.text = [discountInfo objectForKey:@"na"];
        self.expireTime.text = [[discountInfo objectForKey:@"et"] substringToIndex:10];
        self.credit.text = [[discountInfo objectForKey:@"cr"] stringValue];
        self.introduce.text = [discountInfo objectForKey:@"in"];
    }
    
}
@end
